import 'package:flutter/material.dart';
import 'package:note_book_app/all_screen/email_adress_screen.dart';
import 'package:note_book_app/all_screen/pin_verification_screen.dart';
import 'package:note_book_app/all_screen/set_password_screen.dart';
import 'package:note_book_app/all_screen/signin_screen.dart';
import 'package:note_book_app/all_screen/signup_screen.dart';
import 'package:note_book_app/bottom_navigator_bar_all_screen/add_new_task.dart';
import 'package:note_book_app/bottom_navigator_bar_all_screen/main_navigator_screen.dart';
import 'package:note_book_app/bottom_navigator_bar_all_screen/profile_update_screen.dart';
import 'package:note_book_app/splash_screen.dart';

class NoteBookApp extends StatelessWidget {
  const NoteBookApp({super.key});
  static GlobalKey<NavigatorState>navigator=GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: TextTheme(titleLarge: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),

          inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey[350],
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color:Colors.greenAccent,width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color:Colors.greenAccent,width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color:Colors.greenAccent,width: 2),
          ),
        ),
          elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              // fixedSize: Size(double.infinity, 15),
              minimumSize: Size(double.infinity, 40)
          ),
        )
      ),
     // home: SplashScreen(),
      initialRoute: '/',
      routes: {
        '/':(context)=>SplashScreen(),
        SignInScreen.name:(context)=>SignInScreen(),
        EmailAddressScreen.name:(context)=>EmailAddressScreen(),
        PinVerificationScreen.name:(context)=>PinVerificationScreen(),
        SetPasswordScreen.name:(context)=>SetPasswordScreen(),
        SignUpScreen.name:(context)=>SignUpScreen(),
        MainNavigatorScreen.name:(context)=>MainNavigatorScreen(),
        AddNewTask.name:(context)=>AddNewTask(),
        ProfileUpdateScreen.name:(context)=>ProfileUpdateScreen()
      },
    );
  }
}
