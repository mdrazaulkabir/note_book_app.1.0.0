class UserModel {
  late String id;
  late String email;
  late String firstName;
  late String lastName;
  late String mobile;
  String? photo;
  UserModel.fromJson(Map<String,dynamic>json){
    id = json['_id'];
    email=json['email'];
    firstName=json['firstName'];
    lastName=json['lastName'];
    mobile=json['mobile'];
    photo=json["photo"];
  }
  Map<String ,dynamic>toJson(){
    return {
      '_id': id,
      'email': email,
      'firstName':firstName,
      'lastName':lastName,
      'mobile':mobile,
      'photo':photo,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? mobile,
    String? photo,
  }) {
    return UserModel.fromJson({
      '_id': id ?? this.id,
      'email': email ?? this.email,
      'firstName': firstName ?? this.firstName,
      'lastName': lastName ?? this.lastName,
      'mobile': mobile ?? this.mobile,
      'photo': photo ?? this.photo,
    });
  }

}