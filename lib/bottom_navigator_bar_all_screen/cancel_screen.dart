import 'package:flutter/material.dart';
import 'package:note_book_app/api_service/all_url.dart';
import 'package:note_book_app/api_service/network_caller.dart';
import 'package:note_book_app/custom_method/show_my_snack_bar.dart';
import 'package:note_book_app/custom_widget/display_card.dart';
import 'package:note_book_app/model/new_task_model.dart';

class CancelScreen extends StatefulWidget {
  const CancelScreen({super.key});

  @override
  State<CancelScreen> createState() => _CancelScreenState();
}

class _CancelScreenState extends State<CancelScreen> {
  bool cancelInProgress=false;
  List<NewTaskModel>cancelTaskListData=[];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _cancelApiCall();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Visibility(
          visible: cancelInProgress==false,
          replacement: CMCircularProgress(),
          child: ListView.builder(
              itemCount: cancelTaskListData.length,
              itemBuilder: (context,index){
                 return DisplayCard(textType: TextType.Cancel, newTaskModel: cancelTaskListData[index], onStausUpdate: () { _cancelApiCall(); },);
              }),
        )
    );
  }

  Future<void>_cancelApiCall()async{
    cancelInProgress=true;
    if(mounted){
      setState(() {});
    }
    NetworkResponse response=await NetworkCaller.getData(url: AllUrl.cancelTaskListUrl);
    if(response.isSuccess){
      final List<NewTaskModel>listData=[];
      for(Map<String,dynamic>listData1 in response.body!['data']){
        listData.add(NewTaskModel.formJson(listData1));
      }
      cancelTaskListData=listData;
    }
    else{
      if(mounted){
        CMSnackBar(context, response.errorMessage!);
      }
    }
    cancelInProgress=false;
    if(mounted){
      setState(() {});
    }
  }
}
