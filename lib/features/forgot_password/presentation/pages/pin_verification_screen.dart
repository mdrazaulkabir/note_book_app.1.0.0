import 'package:flutter/material.dart';
import 'package:note_book_app/features/forgot_password/presentation/pages/set_password_screen.dart';
import 'package:note_book_app/api_service/all_url.dart';
import 'package:note_book_app/api_service/network_caller.dart';
import 'package:note_book_app/custom_method/show_my_snack_bar.dart';
import 'package:note_book_app/custom_widget/rich_text1.dart';
import 'package:note_book_app/model/email_verify_model.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  static final String name="pinVerification";

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  TextEditingController pinTEController=TextEditingController();
  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
  bool pinVerificationProgress=false;
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
                  "PIN Verification",
                  style: TextTheme.of(context).titleLarge,
                ),
                SizedBox(height: 15,),
                Text(
                  "A 6 digit verification pin will\n send to your email address",
                  style: TextStyle(fontSize: 17,color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  enableActiveFill: false,      //in border color default stay red color
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.blue.shade50,
                  controller: pinTEController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'OTP required';
                    }
                    if (value.length != 6) {
                      return 'Enter 6 digit OTP';
                    }
                    return null;
                  },
                  appContext: (context),                                         //vvi

                ),
                SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {},
                //   child: Text("Login"),
                // ),
                Visibility(
                  visible: pinVerificationProgress==false,
                  replacement: CMCircularProgress(),
                  child: ElevatedButton.icon(onPressed: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>SetPasswordScreen()));
                    _setPassword();
                  },label:Text("Verify")),
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

  //with out validate we can write this way  but ist's for small app
  // void _setPassword(){
  //   String pin=pinTEController.text.trim();
  //   if(pin.isEmpty||pin.length!=6){
  //     return _showMessage("Enter your valid 6 pin number");
  //   }
  //   Navigator.pushReplacementNamed(context, SetPasswordScreen.name);
  // }
  // void _showMessage(String msg){
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  // }

  void _setPassword(){
    if(_formKey.currentState!.validate()){
      pinVerifyOtpApiCall();
    }
  }
  Future<void>pinVerifyOtpApiCall()async{
    pinVerificationProgress=true;
    setState(() {});

    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String? email1=sharedPreferences.getString('email');
    sharedPreferences.setString('userOtp', pinTEController.text.trim());

    NetworkResponse response=await NetworkCaller.getData(url: AllUrl.pinOtpUrl(email1!, pinTEController.text.trim()));
    if(response.statusCode==200){
      EmailVerifyModel emailVerifyModel=EmailVerifyModel.fromJson(response.body!);
      String? status1=emailVerifyModel.status;
      String? data1=emailVerifyModel.data;

      if(status1=='success'){
        pinTEController.clear();
        if(mounted){
         CMSnackBar(context, "$status1 $data1");
          CMSnackBar(context, "Now you can set your new password!");
          // Navigator.pushNamed(context, SetPasswordScreen.name);
          Navigator.pushNamedAndRemoveUntil(context, SetPasswordScreen.name, (route)=>false);
        }
      }
      else{
        pinVerificationProgress=false;
        if(mounted){
          setState(() {});
          CMSnackBar(context, '$status1 $data1');
        }
      }

    }
    else{
      pinVerificationProgress=false;
      if(mounted){
        setState(() {});
        CMSnackBar(context, response.errorMessage!);
      }
    }

  }

  @override
  void dispose() {
    super.dispose();
    pinTEController.dispose();
  }
}
