class TaskCountModel {
  late String id;
  late int sum;
  TaskCountModel.formJson(Map<String,dynamic>json){
    id=json['_id'];
    sum=json["sum"];
  }
}