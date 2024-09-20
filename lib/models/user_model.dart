import 'package:expanses_task11/data/local/db_helper.dart';

class UserModel {
  String fname;
  String lname;
  String email;
  int phone;
  String pass;
  int? uid;

  UserModel({this.uid,
    required this.fname,
    required this.lname,
    required this.pass,
    required this.email,
    required this.phone});

  factory UserModel.fromMap(Map<String, dynamic>map){
    return UserModel(
      uid: map[DbHelper.User_Id],
        fname: map[DbHelper.User_fname],
        lname: map[DbHelper.User_lname],
        pass: map[DbHelper.User_pass],
        email: map[DbHelper.User_email],
        phone: map[DbHelper.User_phone]);
  }

  Map<String,dynamic> toMap(){
    return {
      DbHelper.User_fname : fname,
      DbHelper.User_lname : lname,
      DbHelper.User_email : email,
      DbHelper.User_phone : phone,
      DbHelper.User_pass : pass,
    };
  }
}

