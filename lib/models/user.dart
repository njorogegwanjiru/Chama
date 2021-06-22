import 'package:firebase_database/firebase_database.dart';

class UserModel {
  final String uid;
  final String name;

  UserModel({this.uid, this.name});

  factory UserModel.fromJson(json) {
    return UserModel(
        name: json['name'],
        uid: json['id'],
        );
  }

}

