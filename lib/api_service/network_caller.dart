import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:note_book_app/all_screen/signin_screen.dart';
import 'package:note_book_app/auth_controller/auth_controller.dart';
import 'package:note_book_app/note_book_app.dart';

class NetworkResponse{
  final bool isSuccess;
  final int statusCode;
  final Map<String,dynamic>? body;
  final String? errorMessage;

  NetworkResponse({required this.isSuccess, required this.statusCode, this.body, this.errorMessage});
}
class NetworkCaller {
  static final  String _defaultErrorMessage="Api can't fetch the server and data";

  static Future<NetworkResponse>getData({required String url})async{
    Uri uri=Uri.parse(url);
    final Map<String,String>headers1={
      "token":AuthController.userToken??''
    };
    _logRequest(url,headers1, null);
    Response response=await get(uri,headers:headers1);
    _logResponse(url, response);
    try{
      if(response.statusCode==200){
        final decodedData=jsonDecode(response.body);
        return NetworkResponse(isSuccess: true, statusCode: response.statusCode,body: decodedData);
      }
      else if(response.statusCode==401){
          _unAuthorized();
        final decodedData=jsonDecode(response.body);
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode, body: decodedData,errorMessage:decodedData['data']?? _defaultErrorMessage);
      }
      else{
        final decodedData=jsonDecode(response.body);
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode,body:decodedData,errorMessage: decodedData['data']??_defaultErrorMessage);
      }
    }
    catch(e){
      return NetworkResponse(isSuccess: false, statusCode: -1,errorMessage: e.toString());
    }
  }

  static Future<NetworkResponse> postData({required String url,Map<String,dynamic>?body,bool isLoggedIn=false})async{
    final uri=Uri.parse(url);
    final Map<String,String>headers1={
    "content-type": "application/json",
      "token":AuthController.userToken ?? '',
    };
    _logRequest(url,headers1,body);
    final response= await post(
        uri,
        body: jsonEncode(body),
        headers: headers1,
        );
    _logResponse(url, response);

    try{
      if(response.statusCode==200){
        final decodedData=jsonDecode(response.body);
        return NetworkResponse(isSuccess: true, statusCode: response.statusCode,body: decodedData);
      }
      else if(response.statusCode==401){
        if(!isLoggedIn){
          _unAuthorized();
        }
        final decodedData=jsonDecode(response.body);
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode, body: decodedData,errorMessage:decodedData['data']?? _defaultErrorMessage);
      }
      else{
        final decodedData=jsonDecode(response.body);
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode,body: decodedData,errorMessage:decodedData['data']?? _defaultErrorMessage);
      }
    }
    catch(e){
      return NetworkResponse(isSuccess: false, statusCode: -1,errorMessage: e.toString());
    }
  }





 static void _logRequest(String uri,Map<String,dynamic>?headers,Map<String,dynamic>?body){
    debugPrint("''''''''''''''''''''Request''''''''''''''''''''''''''\n"
        "uri is:$uri\n "
        "headers:$headers\n"
        "body is :$body\n"
        "'''''''''''''''''''''''''''''''''''''''''''''''''''''"
    );
  }

  static void _logResponse(String uri,Response response){
    debugPrint("''''''''''''''''''Response''''''''''''''''''''''''''\n"
        "uri is :$uri\n"
        "status code: ${response.statusCode}\n"
        "response is:${response.body}\n"
        "'''''''''''''''''''''''''''''''''''''''''''''''''''''''");
  }
  static Future<void> _unAuthorized()async{
    await AuthController.clearData();
    Navigator.of(NoteBookApp.navigator.currentContext!).pushNamedAndRemoveUntil(SignInScreen.name, (predicate)=>false);
  }

}