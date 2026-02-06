class NewTaskModel {
  late String id;
  late String title;
  late String description;
  late String status;
  late String email;
  late String createData;
  NewTaskModel.formJson(Map<String,dynamic>json){
    id=json["_id"]??'';
    title=json['title']??'';
    description=json['description']??'';
    status=json['status']??'';
    email=json['email']??'';
    createData=json['createdDate']??'';
  }
}