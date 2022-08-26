// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/Data/Data_user.dart';

class DataReponsitory{
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection("Data");

  //add data zo
  Future<DocumentReference> addUser(DataUser user){


    //tra ve duoi dang json 
    return collectionReference.add(user.toJson());
  }

  //Update thong tin khach
  void updateData(DataUser data) async{
    // duoc xac dinh boi id user
    //lay duoc cai book theo refid roi update data
    //truyen du lieu vao json
    await collectionReference.doc(data.refID).update(data.toJson());
  }

  void deleteData(DataUser data) async{
  // duoc xac dinh boi id user
    //lay duoc cai book theo refid roi xoa data
    await collectionReference.doc(data.refID).delete();
  }
}