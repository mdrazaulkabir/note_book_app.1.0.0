import 'package:flutter/material.dart';
import 'package:note_book_app/all_screen/signin_screen.dart';
import 'package:note_book_app/api_service/all_url.dart';
import 'package:note_book_app/api_service/network_caller.dart';
import 'package:note_book_app/custom_method/show_my_snack_bar.dart';
import 'package:note_book_app/custom_widget/rich_text1.dart';
import 'package:note_book_app/model/email_verify_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});
  static final String name='setPasswordScreen';
  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController passTEController=TextEditingController();
  final TextEditingController confirmTEController=TextEditingController();
  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
  bool setPasswordProgress=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Set Password",
                  style: TextTheme.of(context).titleLarge,
                ),
                SizedBox(height: 15,),
                Text(
                  "Minimum length password 8 character with \n Latter and number combination",
                  style: TextStyle(fontSize: 17,color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: passTEController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: "Enter password"),
                  validator: (value){
                    if(value==null||value.trim().isEmpty){
                      return "Enter valid password!";
                    }
                    else if(value.length<6||value.length>12){
                      return "Password must be 6 to 12 character";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: confirmTEController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: "Enter confirm password"),
                  validator: (value){
                    if(value!.trim()!=passTEController.text){
                      return "Your password doesn't match!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: setPasswordProgress==false,
                  replacement: CMCircularProgress(),
                  child: ElevatedButton.icon(onPressed: (){
                    _verifyButton();
                  },label:Text("Confirm")),
                ),
                SizedBox(height: 50),
                RichText1(text1: "Have account?",text2: ' Sign in',),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _verifyButton(){
    if(_formKey.currentState!.validate()){
      //navigator
      setPasswordApiCall();
    }
  }

  Future<void>setPasswordApiCall()async{
    setPasswordProgress=true;
    setState(() {
    });
    SharedPreferences sh=await SharedPreferences.getInstance();
    Map<String,dynamic>requestBody={
      'email':sh.getString('email'),
      'OTP':sh.getString('userOtp'),
      'password':confirmTEController.text.trim()
    };
    NetworkResponse response =await NetworkCaller.postData(url: AllUrl.setPasswordUrl,body: requestBody,isLoggedIn: false);
    if(response.statusCode==200){
      EmailVerifyModel emailVerifyModel=EmailVerifyModel.fromJson(response.body!);
      String? status1=emailVerifyModel.status;
      String? data1=emailVerifyModel.data;
      if(status1=='success'){
        setPasswordProgress=false;
       if(mounted){
         passTEController.clear();
         confirmTEController.clear();
         CMSnackBar(context, "$status1 $data1");
         //print('$status1 $data1'); //this is good practice because always you can't use context,,so just check in terminal by print ,,after check you can comment this
         CMSnackBar(context, "now you can login your new password!");
         Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (route)=>false);
       }
      }
      else{
        setPasswordProgress=false;
        setState(() {
        });
        //CMSnackBar(context, "$status1 $data1");
        print("$status1 $data1");
      }
    }
    else{
      setPasswordProgress=false;
      if(mounted){
        setState(() {
        });
        CMSnackBar(context, response.errorMessage!);
      }
    }
  }
  @override
  void dispose() {
    super.dispose();
    passTEController.dispose();
    confirmTEController.dispose();
  }
}
