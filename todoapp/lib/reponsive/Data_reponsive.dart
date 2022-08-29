// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/services/auth.dart';

class DataReponsitory {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("todo_users").doc(AuthService().getUid()).collection('todos');

  Stream<QuerySnapshot> getStream() {
    return collectionReference.snapshots();
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
