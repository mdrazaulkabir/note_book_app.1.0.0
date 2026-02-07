part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordEvent {}
final class ForgotPasswordEmailVerify extends ForgotPasswordEvent{
  final String email;
  ForgotPasswordEmailVerify({required this.email});
}
