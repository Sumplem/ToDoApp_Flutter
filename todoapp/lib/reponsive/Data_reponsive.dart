// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/Data/Data_user.dart';
import 'package:todoapp/models/todo.dart';

class DataReponsitory {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("todos");

  Stream<QuerySnapshot> getStream() {
    return collectionReference.snapshots();
  }

  //add data zo
  Future<DocumentReference> addUser(DataUser user) {
    //tra ve duoi dang json
    return collectionReference.add(user.toJson());
  }

  //Update thong tin khach
  void updateData(DataUser data) async {
    // duoc xac dinh boi id user
    //lay duoc cai book theo refid roi update data
    //truyen du lieu vao json
    await collectionReference.doc(data.refID).update(data.toJson());
  }

  void deleteData(DataUser data) async {
    // duoc xac dinh boi id user
    //lay duoc cai book theo refid roi xoa data
    await collectionReference.doc(data.refID).delete();
  }

  Future<DocumentReference> addTodo(ToDo todo) {
    return collectionReference.add(todo.toJson());
  }

  void updateToDo(ToDo todo) async {
    await collectionReference.doc(todo.refId).update(todo.toJson());
  }

  void deleteToDo(ToDo todo) async {
    await collectionReference.doc(todo.refId).delete();
  }
}
