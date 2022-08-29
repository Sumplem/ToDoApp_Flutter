import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {
  String name;
  bool status;
  num progress;

  String? refId;

  ToDo(this.name, {this.status = false, this.progress = 0 , this.refId}) {
    if(progress < 0) {
      progress = 0;
    }else if(progress > 100) {
      progress = 100;
    }
  }

  factory ToDo.fromSnapshot(DocumentSnapshot snapshot) {
    final newToDo = ToDo.fromJson(snapshot.data() as Map<String, dynamic>);
    newToDo.refId = snapshot.reference.id;
    return newToDo;
  }

  factory ToDo.fromJson(Map<String, dynamic> json) => _toDoFromJson(json);

  Map<String, dynamic> toJson() => _toDoToJson(this);
}

//convert Json to Todo
ToDo _toDoFromJson(Map<String, dynamic> json) {
  return ToDo(json['name'] as String, status: json['status'] as bool,progress: json['progress']);
}

// convert Todo to Json
Map<String, dynamic> _toDoToJson(ToDo toDo) =>
    <String, dynamic>{'name': toDo.name, 'status': toDo.status, 'progress': toDo.progress};
