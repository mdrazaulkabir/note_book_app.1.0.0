// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:note_book_app/all_screen/signin_screen.dart';
// // import 'package:note_book_app/all_screen/signup_screen.dart';
//
// class RichText1 extends StatefulWidget {
//   final String text1;
//   final String? text2;//it's not required,, it can be given also not given both accept => text2?? " Sign up"
//   // final VoidCallback? onTap1;
//   final TapGestureRecognizer? onTap1;
//   const RichText1({super.key, required this.text1, this.text2,this.onTap1});
//
//   @override
//   State<RichText1> createState() => _RichText1State();
// }
//
// class _RichText1State extends State<RichText1> {
//   @override
//   Widget build(BuildContext context) {
//     return RichText(
//       text: TextSpan(
//         text: widget.text1,
//         style: TextStyle(color: Colors.black),
//         children: [
//           TextSpan(
//             // text: text2,
//             text: widget.text2?? " Sign in",
//             style: TextStyle(color: Colors.greenAccent),
//             recognizer:widget.onTap1?? TapGestureRecognizer()..onTap=(){
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
//             }
//           ),
//         ],
//       ),
//     );
//   }
// }

/*
   vvi => Flutter developers often avoid "recognizer: TapGestureRecognizer" unless necessary because:
   * Risk of memory leaks if not disposed properly              //vvi
   * More boilerplate code                                      //vvi
   * Harder to read / maintain
   * Simple alternatives (GestureDetector or InkWell) cover 90% of common use cases
   * They do not avoid it completely — it’s just used only when needed, especially for rich, inline clickable text.
*/

import 'package:flutter/material.dart';
import 'package:note_book_app/all_screen/signin_screen.dart';

class RichText1 extends StatelessWidget {
  final String text1;
  final String? text2;
  final VoidCallback? onTap;

  const RichText1({
    super.key,
    required this.text1,
    this.text2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text1,
          style: const TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: onTap ?? () {
            //Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
            Navigator.pushReplacementNamed(context, SignInScreen.name);
              },
          child: Text(
            text2 ?? " Sign in",
            style: const TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
