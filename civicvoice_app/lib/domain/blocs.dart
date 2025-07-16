import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api_service.dart';


abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent(this.email, this.password);
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class RegisterResearcherEvent extends AuthEvent {
  final String email;
  final String password;
  final String organization;
  RegisterResearcherEvent(this.email, this.password, this.organization);
}

// Report Events
abstract class ReportEvent {}

class SubmitReportEvent extends ReportEvent {
  final String title;
  final String category;
  final String description;
  final double latitude;
  final double longitude;
  final String language;
  final File? attachment;

  SubmitReportEvent({
    required this.title,
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.language = 'en',
    this.attachment,
  });
}

class TrackReportEvent extends ReportEvent {
  final String referenceCode;
  final String passphrase;
  TrackReportEvent(this.referenceCode, this.passphrase);
}

class LoadModeratorReportsEvent extends ReportEvent {
  final String status;
  final int page;
  final String? category;

  LoadModeratorReportsEvent({
    this.status = 'pending',
    this.page = 1,
    this.category,
  });
}

class ModerateReportEvent extends ReportEvent {
  final String reportId;
  final String action;
  final String notes;

  ModerateReportEvent({
    required this.reportId,
    required this.action,
    this.notes = '',
  });
}

class LoadPublicReportsEvent extends ReportEvent {
  final String? category;
  final String? startDate;
  final String? endDate;
  final int page;

  LoadPublicReportsEvent({
    this.category,
    this.startDate,
    this.endDate,
    this.page = 1,
  });
}

class LoadCategoriesEvent extends ReportEvent {}

// Language Events
abstract class LanguageEvent {}

class ChangeLanguageEvent extends LanguageEvent {
  final Locale locale;
  ChangeLanguageEvent(this.locale);
}

class LoadLanguageEvent extends LanguageEvent {}

// Data Purchase Events
abstract class DataPurchaseEvent {}

class InitiatePurchaseEvent extends DataPurchaseEvent {
  final Map<String, dynamic>? filters;
  InitiatePurchaseEvent({this.filters});
}

class ConfirmPurchaseEvent extends DataPurchaseEvent {
  final String paymentIntentId;
  ConfirmPurchaseEvent(this.paymentIntentId);
}

class DownloadDataEvent extends DataPurchaseEvent {
  final String downloadToken;
  DownloadDataEvent(this.downloadToken);
}

// =====================
// STATES
// =====================

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final String role;
  final String userId;
  AuthSuccess(this.role, this.userId);
}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
class RegistrationSuccess extends AuthState {}

// Report States
abstract class ReportState {}

class ReportInitial extends ReportState {}
class ReportLoading extends ReportState {}

class ReportSubmissionSuccess extends ReportState {
  final String reportId;
  final String referenceCode;
  final String passphrase;

  ReportSubmissionSuccess({
    required this.reportId,
    required this.referenceCode,
    required this.passphrase,
  });
}

class ReportTracked extends ReportState {
  final Map<String, dynamic> report;
  final List<Map<String, dynamic>> statusHistory;

  ReportTracked({
    required this.report,
    required this.statusHistory,
  });
}

class ModeratorReportsLoaded extends ReportState {
  final List<Map<String, dynamic>> reports;
  final Map<String, dynamic> pagination;

  ModeratorReportsLoaded({
    required this.reports,
    required this.pagination,
  });
}

class PublicReportsLoaded extends ReportState {
  final List<Map<String, dynamic>> reports;
  final Map<String, dynamic> pagination;

  PublicReportsLoaded({
    required this.reports,
    required this.pagination,
  });
}

class CategoriesLoaded extends ReportState {
  final List<String> categories;
  CategoriesLoaded(this.categories);
}

class ReportModerationSuccess extends ReportState {
  final String message;
  ReportModerationSuccess(this.message);
}

class ReportFailure extends ReportState {
  final String message;
  ReportFailure(this.message);
}

class LanguageState {
  final Locale locale;
  const LanguageState(this.locale);
}

abstract class DataPurchaseState {}

class DataPurchaseInitial extends DataPurchaseState {}
class DataPurchaseLoading extends DataPurchaseState {}

class PurchaseInitiated extends DataPurchaseState {
  final String clientSecret;
  final int reportCount;
  final double totalAmount;
  final String paymentIntentId;

  PurchaseInitiated({
    required this.clientSecret,
    required this.reportCount,
    required this.totalAmount,
    required this.paymentIntentId,
  });
}

class PurchaseConfirmed extends DataPurchaseState {
  final String downloadToken;
  final String expiresAt;

  PurchaseConfirmed({
    required this.downloadToken,
    required this.expiresAt,
  });
}

class DataDownloaded extends DataPurchaseState {
  final List<int> fileData;
  DataDownloaded(this.fileData);
}

class DataPurchaseFailure extends DataPurchaseState {
  final String message;
  DataPurchaseFailure(this.message);
}

// =====================
// BLOCS
// =====================

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<RegisterResearcherEvent>(_onRegisterResearcher);
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    try {
      final isAuthenticated = await ApiService.isAuthenticated();
      if (isAuthenticated) {
        final role = await ApiService.getUserRole();
        final userId = await ApiService.getUserId();
        if (role != null && userId != null) {
          emit(AuthSuccess(role, userId));
        } else {
          emit(AuthInitial());
        }
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await ApiService.moderatorLogin(
        email: event.email,
        password: event.password,
      );

      emit(AuthSuccess(
        response['user']['role'],
        response['user']['id'],
      ));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('Login failed: $e'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await ApiService.logout();
    emit(AuthInitial());
  }

  Future<void> _onRegisterResearcher(RegisterResearcherEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await ApiService.registerResearcher(
        email: event.email,
        password: event.password,
        organization: event.organization,
      );

      emit(RegistrationSuccess());
    } on ApiException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('Registration failed: $e'));
    }
  }
}

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportInitial()) {
    on<SubmitReportEvent>(_onSubmitReport);
    on<TrackReportEvent>(_onTrackReport);
    on<LoadModeratorReportsEvent>(_onLoadModeratorReports);
    on<ModerateReportEvent>(_onModerateReport);
    on<LoadPublicReportsEvent>(_onLoadPublicReports);
    on<LoadCategoriesEvent>(_onLoadCategories);
  }

  Future<void> _onSubmitReport(SubmitReportEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final response = await ApiService.submitReport(
        title: event.title,
        category: event.category,
        description: event.description,
        latitude: event.latitude,
        longitude: event.longitude,
        language: event.language,
        attachment: event.attachment,
      );

      emit(ReportSubmissionSuccess(
        reportId: response['report_id'],
        referenceCode: response['reference_code'],
        passphrase: response['passphrase'],
      ));
    } on ApiException catch (e) {
      emit(ReportFailure(e.message));
    } catch (e) {
      emit(ReportFailure('Failed to submit report: $e'));
    }
  }

  Future<void> _onTrackReport(TrackReportEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final response = await ApiService.trackReport(
        referenceCode: event.referenceCode,
        passphrase: event.passphrase,
      );

      emit(ReportTracked(
        report: response['report'],
        statusHistory: List<Map<String, dynamic>>.from(response['status_history']),
      ));
    } on ApiException catch (e) {
      emit(ReportFailure(e.message));
    } catch (e) {
      emit(ReportFailure('Failed to track report: $e'));
    }
  }

  Future<void> _onLoadModeratorReports(LoadModeratorReportsEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final response = await ApiService.getModeratorReports(
        status: event.status,
        page: event.page,
        category: event.category,
      );

      emit(ModeratorReportsLoaded(
        reports: List<Map<String, dynamic>>.from(response['reports']),
        pagination: response['pagination'],
      ));
    } on ApiException catch (e) {
      emit(ReportFailure(e.message));
    } catch (e) {
      emit(ReportFailure('Failed to load reports: $e'));
    }
  }

  Future<void> _onModerateReport(ModerateReportEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final response = await ApiService.moderateReport(
        reportId: event.reportId,
        action: event.action,
        notes: event.notes,
      );

      emit(ReportModerationSuccess(response['message']));
    } on ApiException catch (e) {
      emit(ReportFailure(e.message));
    } catch (e) {
      emit(ReportFailure('Failed to moderate report: $e'));
    }
  }

  Future<void> _onLoadPublicReports(LoadPublicReportsEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final response = await ApiService.getPublicReports(
        category: event.category,
        startDate: event.startDate,
        endDate: event.endDate,
        page: event.page,
      );

      emit(PublicReportsLoaded(
        reports: List<Map<String, dynamic>>.from(response['reports']),
        pagination: response['pagination'],
      ));
    } on ApiException catch (e) {
      emit(ReportFailure(e.message));
    } catch (e) {
      emit(ReportFailure('Failed to load public reports: $e'));
    }
  }

  Future<void> _onLoadCategories(LoadCategoriesEvent event, Emitter<ReportState> emit) async {
    try {
      final categories = await ApiService.getCategories();
      emit(CategoriesLoaded(categories));
    } on ApiException catch (e) {
      emit(ReportFailure(e.message));
    } catch (e) {
      emit(ReportFailure('Failed to load categories: $e'));
    }
  }
}

class LanguageBloc extends HydratedBloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState(Locale('en', 'US'))) {
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<LoadLanguageEvent>(_onLoadLanguage);
  }

  Future<void> _onLoadLanguage(LoadLanguageEvent event, Emitter<LanguageState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language') ?? 'en';
    emit(LanguageState(Locale(languageCode, languageCode == 'en' ? 'US' : 'FR')));
  }

  Future<void> _onChangeLanguage(ChangeLanguageEvent event, Emitter<LanguageState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', event.locale.languageCode);
    emit(LanguageState(event.locale));
  }

  @override
  LanguageState? fromJson(Map<String, dynamic> json) {
    final langCode = json['language'] ?? 'en';
    return LanguageState(Locale(langCode, langCode == 'en' ? 'US' : 'FR'));
  }

  @override
  Map<String, dynamic>? toJson(LanguageState state) {
    return {'language': state.locale.languageCode};
  }
}

class DataPurchaseBloc extends Bloc<DataPurchaseEvent, DataPurchaseState> {
  DataPurchaseBloc() : super(DataPurchaseInitial()) {
    on<InitiatePurchaseEvent>(_onInitiatePurchase);
    on<ConfirmPurchaseEvent>(_onConfirmPurchase);
    on<DownloadDataEvent>(_onDownloadData);
  }

  Future<void> _onInitiatePurchase(InitiatePurchaseEvent event,
      Emitter<DataPurchaseState> emit) async {
    emit(DataPurchaseLoading());
    try {
      final response = await ApiService.purchaseData(filters: event.filters);

      emit(PurchaseInitiated(
        clientSecret: response['client_secret'],
        reportCount: response['report_count'],
        totalAmount: response['total_amount'].toDouble(),
        paymentIntentId: response['payment_intent_id'],
      ));
    } on ApiException catch (e) {
      emit(DataPurchaseFailure(e.message));
    } catch (e) {
      emit(DataPurchaseFailure('Failed to initiate purchase: $e'));
    }
  }

  Future<void> _onConfirmPurchase(ConfirmPurchaseEvent event,
      Emitter<DataPurchaseState> emit) async {
    emit(DataPurchaseLoading());
    try {
      final response = await ApiService.confirmPurchase(
        paymentIntentId: event.paymentIntentId,
      );

      emit(PurchaseConfirmed(
        downloadToken: response['download_token'],
        expiresAt: response['expires_at'],
      ));
    } on ApiException catch (e) {
      emit(DataPurchaseFailure(e.message));
    } catch (e) {
      emit(DataPurchaseFailure('Failed to confirm purchase: $e'));
    }
  }

  Future<void> _onDownloadData(DownloadDataEvent event,
      Emitter<DataPurchaseState> emit) async {
    emit(DataPurchaseLoading());
    try {
      final fileData = await ApiService.downloadData(
        downloadToken: event.downloadToken,
      );

      emit(DataDownloaded(fileData));
    } on ApiException catch (e) {
      emit(DataPurchaseFailure(e.message));
    } catch (e) {
      emit(DataPurchaseFailure('Failed to download data: $e'));
    }
  }
}

