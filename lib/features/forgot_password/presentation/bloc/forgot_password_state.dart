part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordState {}

final class ForgotPasswordInitial extends ForgotPasswordState {}
final class ForgotPasswordLoading extends ForgotPasswordState{}
final class ForgotPasswordEmailVerifySuccess extends ForgotPasswordState{
  final String message;
  ForgotPasswordEmailVerifySuccess({required this.message});
}
final class ForgotPasswordFetchFailed extends ForgotPasswordState{
  final String message;
  ForgotPasswordFetchFailed({required this.message});
}