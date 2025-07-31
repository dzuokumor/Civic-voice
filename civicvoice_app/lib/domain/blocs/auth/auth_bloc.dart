import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/api_service.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final String userType;

  const LoginEvent({
    required this.email,
    required this.password,
    required this.userType,
  });

  @override
  List<Object?> get props => [email, password, userType];
}

class SignupEvent extends AuthEvent {
  final String email;
  final String password;
  final String? organization;
  final String userType;

  const SignupEvent({
    required this.email,
    required this.password,
    this.organization,
    required this.userType,
  });

  @override
  List<Object?> get props => [email, password, organization, userType];
}

class LogoutEvent extends AuthEvent {}

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;
  final String role;

  const AuthAuthenticated({
    required this.userId,
    required this.email,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, email, role];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthSignupSuccess extends AuthState {
  final String message;

  const AuthSignupSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event,
      Emitter<AuthState> emit,
      ) async {
    try {
      final isAuthenticated = await ApiService.isAuthenticated();

      if (isAuthenticated) {
        final userId = await ApiService.getUserId();
        final role = await ApiService.getUserRole();

        if (userId != null && role != null) {
          emit(AuthAuthenticated(
            userId: userId,
            email: '',
            role: role,
          ));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(
      LoginEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      final response = await ApiService.moderatorLogin(
        email: event.email,
        password: event.password,
      );

      if (response['user'] != null) {
        emit(AuthAuthenticated(
          userId: response['user']['id'],
          email: response['user']['email'],
          role: response['user']['role'],
        ));
      } else {
        emit(const AuthError('Login failed. Please try again.'));
      }
    } on ApiException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(const AuthError('An unexpected error occurred. Please try again.'));
    }
  }

  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await ApiService.register(
        email: event.email,
        password: event.password,
        userType: event.userType,
        organization: event.organization,
      );

      emit(AuthSignupSuccess(
        'Account created successfully! Please check your email for verification.',
      ));
    } on ApiException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Registration failed: $e'));
    }
  }

  Future<void> _onLogout(
      LogoutEvent event,
      Emitter<AuthState> emit,
      ) async {
    try {
      await ApiService.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }
}