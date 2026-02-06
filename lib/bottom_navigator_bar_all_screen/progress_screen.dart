import 'package:flutter/material.dart';
import 'package:note_book_app/api_service/all_url.dart';
import 'package:note_book_app/api_service/network_caller.dart';
import 'package:note_book_app/custom_method/show_my_snack_bar.dart';
import 'package:note_book_app/custom_widget/display_card.dart';
import 'package:note_book_app/model/new_task_model.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool progressInProgress=false;
  List<NewTaskModel>progressData=[];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _progressTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Visibility(
          visible: progressInProgress==false,
          replacement: CMCircularProgress(),
          child: ListView.builder(
              itemCount:progressData.length,
              itemBuilder: (context,index){
                 return DisplayCard(textType: TextType.Progress, newTaskModel: progressData[index], onStausUpdate: () { _progressTaskList(); },);
              }),
        )
    );
  }

  Future<void>_progressTaskList()async{
    progressInProgress=true;
    if(mounted){
      setState(() {});
    }
    NetworkResponse response=await NetworkCaller.getData(url: AllUrl.progressTaskListUrl);
    if(response.isSuccess){
      final List<NewTaskModel>listData=[];
      for(Map<String,dynamic>listData1 in response.body!['data']){
        listData.add(NewTaskModel.formJson(listData1));
      }
      progressData=listData;
    }
    else{
      if(mounted){
        CMSnackBar(context, response.errorMessage!);
      }
    }
    progressInProgress=false;
    if(mounted){
      setState(() {});
    }
  }
}
