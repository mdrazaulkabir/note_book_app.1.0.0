import 'package:note_book_app/api_service/all_url.dart';
import 'package:note_book_app/api_service/network_caller.dart';
import 'package:note_book_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';

class ForgotApiService {

  Future<Either<Failure,dynamic>> forgotEmilVerify(dynamic payload)async{
    try{
      final NetworkResponse result=await NetworkCaller.getData(url: AllUrl.emailVerifyUrl(payload));

      return Right(result);
    }
    catch(e){
      return Left(handleException(e, StackTrace.current));
    }
  }


}