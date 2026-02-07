import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:note_book_app/features/forgot_password/data/service/forgot_api_service.dart';
part 'forgot_password_event.dart';
part 'forgot_password_state.dart';


class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotApiService service=ForgotApiService();
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordEmailVerify>(handleForgotPasswordEmailVerify);
  }
  Future<void> handleForgotPasswordEmailVerify(ForgotPasswordEmailVerify event, Emitter<ForgotPasswordState>emit)async{

    emit(ForgotPasswordLoading());
    final payload={
      'email':event.email
    };

    try{

      final result= await service.forgotEmilVerify(payload);
      result.fold(

              (failed){
                emit(ForgotPasswordFetchFailed(message: failed.message));
              },
              (success){
                emit(ForgotPasswordEmailVerifySuccess(message:success));
              });

    }
    catch(e){
      emit(ForgotPasswordFetchFailed(message: e.toString()));
    }
  }
}
