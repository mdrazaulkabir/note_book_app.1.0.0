import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:note_book_app/auth_controller/auth_controller.dart';
import 'package:note_book_app/bottom_navigator_bar_all_screen/profile_update_screen.dart';

import '../all_screen/signin_screen.dart';
class AppbarNavigator extends StatefulWidget {
  const AppbarNavigator({super.key});

  @override
  State<AppbarNavigator> createState() => _AppbarNavigatorState();
}

class _AppbarNavigatorState extends State<AppbarNavigator> {
  @override
  Widget build(BuildContext context) {

    final String? photo = AuthController.userModel?.photo;

    ImageProvider? profileImage;

    if (photo != null && photo.isNotEmpty) {
      try {
        final String pureBase64 =
        photo.contains(',') ? photo.split(',').last : photo;

        profileImage = MemoryImage(base64Decode(pureBase64));
      } catch (_) {
        profileImage = null;
      }
    }

    return  AppBar(
      backgroundColor: Colors.green,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              _appBarButtonTap();
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.greenAccent,
                    // backgroundImage: AuthController.userModel?.photo==null? null: MemoryImage(base64Decode(AuthController.userModel!.photo!)),
                    backgroundImage: profileImage,
                  ),
                ),
                Column(
                  children: [
                    Text("${AuthController.userModel?.firstName}",style:TextStyle(fontSize: 20,color: Colors.white),),
                    Text("${AuthController.userModel?.email}",style:TextStyle(fontSize: 10,color: Colors.white),)

                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(onPressed: (){
            _logoutButton();
          }, icon: Icon(Icons.logout))
        ],
      ),
    );
  }
  void _appBarButtonTap(){
    final currentRoute=ModalRoute.of(context)!.settings.name;
   if(currentRoute==ProfileUpdateScreen.name){
     return ;
   }
    Navigator.pushNamed(context, ProfileUpdateScreen.name).then((_){
      setState(() {
      });
    });
  }
  Future<void> _logoutButton()async{
    await AuthController.clearData();
    Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate)=>false);
  }
}
