import 'package:flutter/material.dart';
import 'package:note_book_app/api_service/all_url.dart';
import 'package:note_book_app/api_service/network_caller.dart';
import 'package:note_book_app/custom_widget/rich_text1.dart';
import 'package:note_book_app/custom_method/show_my_snack_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static final String name='signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailTEController=TextEditingController();
  final TextEditingController fistNTEController=TextEditingController();
  final TextEditingController lastNTEController=TextEditingController();
  final TextEditingController mobileTEController=TextEditingController();
  final TextEditingController passwordTEController=TextEditingController();
  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
  bool _signupProgressIndicator=false;
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.sizeOf(context);
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
                  "Join With Us",
                  style: TextTheme.of(context).titleLarge,
                ),
                SizedBox(height: size.height*.05,),
                TextFormField(
                  controller: emailTEController,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter valid email';
                    }
                    else if(!value.contains('@')||!value.contains('.')){
                      return "Missing sign '@' and '.' ";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: "Enter your email:"),
                ),
                SizedBox(height: size.height*.02,),
                TextFormField(
                  controller: fistNTEController,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter valid first name';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: "Enter your fist name:"),
                ),
                SizedBox(height: size.height*.02,),
                TextFormField(
                  controller: lastNTEController,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter valid last name';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: "Enter your last name:"),
                ),
                SizedBox(height: size.height*.02,),
                TextFormField(
                  controller: mobileTEController,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter valid mobile number';
                    }
                    else if(value.length!=11){
                      return 'Mobile number must be 11 digit';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: "Enter your mobile number:"),
                ),
                SizedBox(height: size.height*.02,),
                TextFormField(
                  controller: passwordTEController,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter valid password!';
                    }
                    else if(value.length<6||value.length>12){
                      return 'Password must be 6 to 12 character';
                    }
                    // else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) { //this collect by online
                    //   return "Password must contain both letters and numbers";
                    // }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: "Enter your password:"),
                ),
                SizedBox(height: size.height*.03,),
                // ElevatedButton(
                //   onPressed: () {},
                //   child: Text("Login"),
                // ),
                Visibility(
                  visible: _signupProgressIndicator==false,
                  replacement: CMCircularProgress(),
                  child: ElevatedButton.icon(onPressed: (){
                    _signUPButton();
                  }, label: Text("Sign up"),icon: Icon(Icons.open_in_browser),),
                ),
                SizedBox(height: 50),
                RichText1(text1: "Have account?",text2: "Sign in",),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _signUPButton(){
    if(_formKey.currentState!.validate()){
      _signUp();
    }
  }
  Future<void> _signUp()async{
    _signupProgressIndicator=true;
    setState(() {});
    Map<String,dynamic>responseBody={
        "email": emailTEController.text.trim(),
        "firstName":fistNTEController.text.trim(),
        "lastName":lastNTEController.text.trim(),
        "mobile":mobileTEController.text.trim(),
        "password":passwordTEController.text.trim()
    };
    NetworkResponse response=await NetworkCaller.postData(url: "${AllUrl.registrationUrl}", body: responseBody);

    _signupProgressIndicator=false;
    setState(() {});

    if(response.isSuccess){
      _textFormClear();
      CMSnackBar(context, "Successfully registration.Now you can login!");
    }
    else{
      CMSnackBar(context, response.errorMessage.toString());
    }
  }

  void _textFormClear(){
    emailTEController.clear();
    fistNTEController.clear();
    lastNTEController.clear();
    mobileTEController.clear();
    passwordTEController.clear();
  }


  @override
  void dispose() {
    super.dispose();
    emailTEController.dispose();
    fistNTEController.dispose();
    lastNTEController.dispose();
    mobileTEController.dispose();
    passwordTEController.dispose();
  }
}
