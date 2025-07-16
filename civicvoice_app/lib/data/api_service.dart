// lib/data/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static final http.Client _client = http.Client();

  static Future<Map<String, String>> _getHeaders({bool includeAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final token = await _secureStorage.read(key: 'auth_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final responseBody = utf8.decode(response.bodyBytes);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(responseBody);
    } else {
      final errorData = json.decode(responseBody);
      throw ApiException(
        message: errorData['error'] ?? 'Unknown error occurred',
        statusCode: response.statusCode,
      );
    }
  }

  static Future<Map<String, dynamic>> submitReport({
    required String title,
    required String category,
    required String description,
    required double latitude,
    required double longitude,
    String language = 'en',
    File? attachment,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/reports');
      final request = http.MultipartRequest('POST', uri);

      request.fields.addAll({
        'title': title,
        'category': category,
        'description': description,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'language': language,
      });

      if (attachment != null) {
        final mimeType = lookupMimeType(attachment.path);
        final multipartFile = await http.MultipartFile.fromPath(
          'attachment',
          attachment.path,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Failed to submit report: $e');
    }
  }

  static Future<Map<String, dynamic>> trackReport({
    required String referenceCode,
    required String passphrase,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$baseUrl/api/reports/track'),
        headers: headers,
        body: json.encode({
          'reference_code': referenceCode,
          'passphrase': passphrase,
        }),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Failed to track report: $e');
    }
  }

  static Future<Map<String, dynamic>> moderatorLogin({
    required String email,
    required String password,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: headers,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 30));

      final data = _handleResponse(response);

      if (data['token'] != null) {
        await _secureStorage.write(key: 'auth_token', value: data['token']);
        await _secureStorage.write(key: 'user_id', value: data['user']['id']);
        await _secureStorage.write(key: 'user_role', value: data['user']['role']);
      }

      return data;
    } catch (e) {
      throw ApiException(message: 'Login failed: $e');
    }
  }

  static Future<Map<String, dynamic>> getModeratorReports({
    String status = 'pending',
    int page = 1,
    int perPage = 10,
    String? category,
  }) async {
    try {
      final headers = await _getHeaders(includeAuth: true);
      final queryParams = {
        'status': status,
        'page': page.toString(),
        'per_page': perPage.toString(),
        if (category != null) 'category': category,
      };

      final uri = Uri.parse('$baseUrl/api/moderator/reports')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Failed to load reports: $e');
    }
  }

  static Future<Map<String, dynamic>> moderateReport({
    required String reportId,
    required String action,
    String notes = '',
  }) async {
    try {
      final headers = await _getHeaders(includeAuth: true);
      final response = await _client.post(
        Uri.parse('$baseUrl/api/moderator/reports/$reportId/verify'),
        headers: headers,
        body: json.encode({
          'action': action,
          'notes': notes,
        }),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Failed to moderate report: $e');
    }
  }

  static Future<Map<String, dynamic>> getPublicReports({
    String? category,
    String? startDate,
    String? endDate,
    int page = 1,
    int perPage = 50,
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = {
        'page': page.toString(),
        'per_page': perPage.toString(),
        if (category != null) 'category': category,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      };

      final uri = Uri.parse('$baseUrl/api/public/reports')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Failed to load public reports: $e');
    }
  }

  static Future<Map<String, dynamic>> registerResearcher({
    required String email,
    required String password,
    required String organization,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$baseUrl/api/auth/register/researcher'),
        headers: headers,
        body: json.encode({
          'email': email,
          'password': password,
          'organization': organization,
        }),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Registration failed: $e');
    }
  }


  static Future<Map<String, dynamic>> purchaseData({
    Map<String, dynamic>? filters,
  }) async {
    try {
      final headers = await _getHeaders(includeAuth: true);
      final response = await _client.post(
        Uri.parse('$baseUrl/api/data/purchase'),
        headers: headers,
        body: json.encode({
          'filters': filters ?? {},
        }),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Failed to initiate purchase: $e');
    }
  }

  static Future<Map<String, dynamic>> confirmPurchase({
    required String paymentIntentId,
  }) async {
    try {
      final headers = await _getHeaders(includeAuth: true);
      final response = await _client.post(
        Uri.parse('$baseUrl/api/data/confirm-purchase'),
        headers: headers,
        body: json.encode({
          'payment_intent_id': paymentIntentId,
        }),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Failed to confirm purchase: $e');
    }
  }

  static Future<List<int>> downloadData({
    required String downloadToken,
  }) async {
    try {
      final headers = await _getHeaders(includeAuth: true);
      final response = await _client.get(
        Uri.parse('$baseUrl/api/data/download/$downloadToken'),
        headers: headers,
      ).timeout(const Duration(seconds: 60)); // Longer timeout for downloads

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        final errorData = json.decode(response.body);
        throw ApiException(
          message: errorData['error'] ?? 'Download failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException(message: 'Failed to download data: $e');
    }
  }

  static Future<List<String>> getCategories() async {
    try {
      final headers = await _getHeaders();
      final response = await _client.get(
        Uri.parse('$baseUrl/api/categories'),
        headers: headers,
      ).timeout(const Duration(seconds: 30));

      final data = _handleResponse(response);
      return List<String>.from(data['categories']);
    } catch (e) {
      throw ApiException(message: 'Failed to load categories: $e');
    }
  }

  static Future<Map<String, dynamic>> healthCheck() async {
    try {
      final headers = await _getHeaders();
      final response = await _client.get(
        Uri.parse('$baseUrl/api/health'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Health check failed: $e');
    }
  }

  static Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'user_id');
    await _secureStorage.delete(key: 'user_role');
  }

  static Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: 'auth_token');
    return token != null;
  }

  static Future<String?> getUserRole() async {
    return await _secureStorage.read(key: 'user_role');
  }

  static Future<String?> getUserId() async {
    return await _secureStorage.read(key: 'user_id');
  }

  static void dispose() {
    _client.close();
  }
}

// Custom Exception Class
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errorData;

  ApiException({
    required this.message,
    this.statusCode,
    this.errorData,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isNetworkError => statusCode == null;
}