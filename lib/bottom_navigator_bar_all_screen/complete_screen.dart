import 'package:flutter/material.dart';
import 'package:note_book_app/api_service/all_url.dart';
import 'package:note_book_app/api_service/network_caller.dart';
import 'package:note_book_app/custom_method/show_my_snack_bar.dart';
import 'package:note_book_app/custom_widget/display_card.dart';
import 'package:note_book_app/model/new_task_model.dart';
class CompleteScreen extends StatefulWidget {
  const CompleteScreen({super.key});

  @override
  State<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
  bool completedTaskInProgress=false;
  List<NewTaskModel>completedTaskData=[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _completedTaskList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: completedTaskInProgress==false,
        replacement: CMCircularProgress(),
        child: ListView.builder(
            itemCount: completedTaskData.length,
            itemBuilder: (context,index){
              return DisplayCard(textType: TextType.Complete, newTaskModel: completedTaskData[index], onStausUpdate: () { _completedTaskList(); },);
        }),
      )
    );
  }

  Future<void>_completedTaskList()async{
    completedTaskInProgress=true;
    if(mounted){
      setState(() {});
    }
    NetworkResponse response=await NetworkCaller.getData(url: AllUrl.completedTaskListUrl);
    if(response.isSuccess){
      final List<NewTaskModel>listData=[];
      for(Map<String,dynamic>listData1 in response.body!['data']){
        listData.add(NewTaskModel.formJson(listData1));
      }
      completedTaskData=listData;
    }
    else{
      if(mounted){
        CMSnackBar(context, response.errorMessage!);
      }
    }
    completedTaskInProgress=false;
    if(mounted){
      setState(() {});
    }
  }
}
