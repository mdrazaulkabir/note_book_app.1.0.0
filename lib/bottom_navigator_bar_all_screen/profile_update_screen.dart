import 'dart:convert';
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_book_app/api_service/all_url.dart';
import 'package:note_book_app/api_service/network_caller.dart';
import 'package:note_book_app/auth_controller/auth_controller.dart';
import 'package:note_book_app/custom_method/show_my_snack_bar.dart';
import 'package:note_book_app/custom_widget/appBar_navigator.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});
  static final String name='profileUpdate';

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final TextEditingController emailTEController=TextEditingController();
  final TextEditingController fistNTEController=TextEditingController();
  final TextEditingController lastNTEController=TextEditingController();
  final TextEditingController mobileTEController=TextEditingController();
  final TextEditingController passwordTEController=TextEditingController();
  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
  final ImagePicker imagePicker=ImagePicker();
  XFile? _selectedImage;
  bool updateInProgress=false;
  @override
  void initState() {
    super.initState();
    // emailTEController.text=AuthController.userModel!.email; //it's can be wrong because there we talk force not null
    emailTEController.text=AuthController.userModel?.email??'';
    fistNTEController.text=AuthController.userModel?.firstName??'';
    lastNTEController.text=AuthController.userModel?.lastName??'';
    mobileTEController.text=AuthController.userModel?.mobile??'';
  }
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child:AppbarNavigator()),
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
                  "Update Profile",
                  style: TextTheme.of(context).titleLarge,
                ),
                SizedBox(height: size.height*.05,),
                Container(
                height: size.height*.06,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: size.height*.06,
                        width: size.width*.2,
                        // width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child:Center(child:IconButton(onPressed: (){
                          onTapPickedImage();
                        }, icon: Text("Photo"))),
                      ),
                      // SizedBox(width: size.width*.05,),
                      Expanded(
                        child: Text(_selectedImage == null?'Photo is not selected' : _selectedImage!.name,style: TextStyle(overflow:TextOverflow.ellipsis),
                          textAlign: TextAlign.center,
                          maxLines: 1,overflow: TextOverflow.ellipsis,),
                      ),
                    ],
                  ),

                ),
                SizedBox(height: size.height*.02,),
                TextFormField(
                  controller: emailTEController,
                  enabled: false,
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
                    int length1=value?.length??0;
                    if(length1>0&&length1<=6){
                      return "Enter valid password!";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: "Enter your password:"),
                ),
                SizedBox(height: size.height*.03,),
                ElevatedButton.icon(onPressed: (){
                  _updateButton();
                }, label: Text("Update"),icon: Icon(Icons.open_in_browser),),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _updateButton(){
    if(_formKey.currentState!.validate()){
      _updateApiCall();
    }
  }
  Future onTapPickedImage()async{
    final XFile? imagePicked= await imagePicker.pickImage(source: ImageSource.camera);
    if(imagePicked!=null){
      _selectedImage=imagePicked;
      setState(() {

      });
    }
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

  Future<void> _updateApiCall()async{
    updateInProgress=true;
    if(mounted){
      setState(() {});
    }
    Map<String,dynamic>requestBody={
      'email':emailTEController.text.trim(),
      'firstName':fistNTEController.text.trim(),
      'lastName':lastNTEController.text.trim(),
      'mobile':mobileTEController.text.trim()
    };
    if(passwordTEController.text.isNotEmpty){
      requestBody['password']=passwordTEController.text.trim();
    }
    // if(_selectedImage!=null){
    //   Uint8List imageBytes= await _selectedImage!.readAsBytes();
    //    requestBody['photo']=base64Encode(imageBytes);
    // }
    if (_selectedImage != null) {
      final Uint8List imageBytes =
      await _selectedImage!.readAsBytes();

      final String mimeType =
          lookupMimeType(_selectedImage!.path) ?? 'image/jpeg';

      requestBody['photo'] =
      'data:$mimeType;base64,${base64Encode(imageBytes)}';
    }
    NetworkResponse response=await NetworkCaller.postData(url: AllUrl.updateUrl,body: requestBody);

    updateInProgress=false;
    if(mounted){
      setState(() {});
    }

    if(response.isSuccess){
      AuthController.userModel=AuthController.userModel!.copyWith(
        firstName: fistNTEController.text.trim(),
        lastName: lastNTEController.text.trim(),
        mobile: mobileTEController.text.trim(),
        // photo: _selectedImage != null ? base64Encode(await _selectedImage!.readAsBytes()) : AuthController.userModel!.photo,
          photo: _selectedImage != null
              ? requestBody['photo']
              : AuthController.userModel!.photo
      );
      passwordTEController.clear();
      if(mounted){
        CMSnackBar(context, "Successfully update profile!");
      }
    }
    else{
      if(mounted){
        CMSnackBar(context, 'Not updated profile!');
      }
    }
  }
}
