import 'package:flutter/material.dart';
import 'package:note_book_app/api_service/all_url.dart';
import 'package:note_book_app/api_service/network_caller.dart';
import 'package:note_book_app/custom_method/show_my_snack_bar.dart';
import 'package:note_book_app/custom_widget/display_card.dart';
import 'package:note_book_app/model/new_task_model.dart';
import 'package:note_book_app/model/task_count_model.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskInProgress=false;
  List<NewTaskModel>newTaskModelData=[];
  bool _getTaskCountInProgress=false;
  List<TaskCountModel>taskCountModelData=[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _newTaskList();
      _taskCountList();
    });
  }
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.sizeOf(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height:size.height*.1,
            child: Visibility(
              visible: _getTaskCountInProgress==false,
              replacement: CMCircularProgress(),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  shrinkWrap: true,
                  itemCount: taskCountModelData.length,
                  itemBuilder: (context,index){
                    return Container(
                      color: Colors.greenAccent,
                      height: size.height*.1,
                      width: size.width*.2,
                      margin: EdgeInsets.all(10),
                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${taskCountModelData[index].sum}",style: TextStyle(color: Colors.black),),
                          Text(taskCountModelData[index].id,style: TextStyle(color: Colors.black),),
                        ],
                      )),
                    );
                  }),
            ),
          ),
          Visibility(
            visible: _getNewTaskInProgress==false,
            replacement: CMCircularProgress(),
            child: Expanded(                               //this expanded need because of listView.builder in parent of column
              child: ListView.builder(
                  itemCount:newTaskModelData.length,       //vvi =>when you not give the itemCount that time we need to Expended also need in api because we don't know the api length also
                  itemBuilder: (context,index){
                    return DisplayCard(textType: TextType.tNew,
                      newTaskModel: newTaskModelData[index],
                      onStausUpdate: () {
                      _newTaskList();
                      _taskCountList();
                      },);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Future<void>_newTaskList()async{
    _getNewTaskInProgress=true;
    if(mounted){
      setState(() {});
    }
    NetworkResponse response=await NetworkCaller.getData(url:AllUrl.newTaskListUrl);
    if(response.isSuccess){
      final List<NewTaskModel>data=[];
      for(Map<String,dynamic>listData in response.body!['data']){
        data.add(NewTaskModel.formJson(listData));
      }
      newTaskModelData=data.reversed.toList();
    }
    else{
      if(mounted){
        CMSnackBar(context, response.errorMessage.toString());
      }
    }
    _getNewTaskInProgress=false;
    if(mounted){
      setState(() {});
    }
  }

  Future<void>_taskCountList()async{
    _getTaskCountInProgress=true;
    setState(() {});
    NetworkResponse response=await NetworkCaller.getData(url: AllUrl.taskCountListUrl);
    if(response.isSuccess){
      final List<TaskCountModel>taskCountList=[];
      for(Map<String,dynamic>listData2 in response.body!['data']){
        //taskCountList.add(TaskCountModel.formJson(listData2));
        final model=TaskCountModel.formJson(listData2);
        if(["New", "Completed", "Canceled", "Progressed"].contains(model.id)){
          taskCountList.add(model);
        }
      }
      taskCountModelData=taskCountList;
    }
    else{
      if(mounted){
        CMSnackBar(context, response.errorMessage.toString());
      }
    }
    _getTaskCountInProgress=false;
    if(mounted){
      setState(() {});
    }
  }
}

