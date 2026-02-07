import 'package:flutter/material.dart';
import 'package:note_book_app/features/forgot_password/presentation/pages/pin_verification_screen.dart';
import 'package:note_book_app/api_service/all_url.dart';
import 'package:note_book_app/api_service/network_caller.dart';
import 'package:note_book_app/custom_method/show_my_snack_bar.dart';
import 'package:note_book_app/custom_widget/rich_text1.dart';
import 'package:note_book_app/model/email_verify_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailAddressScreen extends StatefulWidget {
  const EmailAddressScreen({super.key});
  static final String name='emailAddressScreen';
  @override
  State<EmailAddressScreen> createState() => _EmailAddressScreenState();
}

class _EmailAddressScreenState extends State<EmailAddressScreen> {
  final TextEditingController emailTEController=TextEditingController();
  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
  bool emailVerifyProcess=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Your Email Address",
                  style: TextTheme.of(context).titleLarge,
                ),
                SizedBox(height: 15,),
                Text(
                  "A 6 digit verification pin will\n send to your email address",
                  //style: TextTheme.of(context).titleSmall,  //but you can't take any color because you can take only one =>textTheme
                  style: TextStyle(fontSize: 17,color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: emailTEController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: "Enter your email"),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter your valid email';
                    }
                    else if(!value.contains("@")||!value.contains('.')){
                      return "Missing the '@' sign and '.' ";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: emailVerifyProcess==false,
                  replacement: CMCircularProgress(),
                  child: ElevatedButton.icon(onPressed: (){
                    if(_formKey.currentState!.validate()){
                      //Navigator.pushReplacementNamed(context, PinVerificationScreen.name);
                      recoverEmailApiCall();
                    }
                    // _onTapEmailAddress();
                  }, label:Icon(Icons.arrow_circle_right_outlined,size: 30,),),
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
  Future<void>recoverEmailApiCall()async{
    emailVerifyProcess=true;
    setState(() {});
    NetworkResponse response=await NetworkCaller.getData(url: AllUrl.emailVerifyUrl(emailTEController.text.trim()));
    if(response.statusCode==200){
      EmailVerifyModel emailVerifyModel=EmailVerifyModel.fromJson(response.body!);
      String? status1=emailVerifyModel.status;
      String? data1=emailVerifyModel.data;

        if(status1=='success'){
          SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
          sharedPreferences.setString("email", emailTEController.text.trim());
          if(mounted){
            emailTEController.clear();
          CMSnackBar(context, "$status1 $data1");
          Navigator.pushNamedAndRemoveUntil(context, PinVerificationScreen.name, (route)=>false);
          }
        }
        else{
          emailVerifyProcess=false;
          if(mounted){
            setState(() {});
            CMSnackBar(context, "$status1 \n $data1");
          }
        }

    }
    else{
      emailVerifyProcess=false;
      if(mounted){
        CMSnackBar(context, response.errorMessage!);
      }
    }
    emailVerifyProcess=false;
    setState(() { });
  }
  @override
  void dispose() {
    super.dispose();
    emailTEController.dispose();
  }
}
