import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/reponsive/Data_reponsive.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final repository = DataReponsitory();
  final nameControl = TextEditingController();
  double progressControl = 0;
  bool statusControl = false;

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final todo = ToDo.fromSnapshot(snapshot);
    return Card(
      color: todo.status ? Colors.green : Colors.red,
      child: ListTile(
        title: Text(
          todo.name,
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text('${todo.progress}%'),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete this Todo ?'),
                    actions: [
                      TextButton(
                          onPressed: (() {
                            Navigator.pop(context);
                          }),
                          child: const Text('Cancle')),
                      TextButton(
                          onPressed: (() {
                            repository.deleteToDo(todo);
                            Navigator.pop(context);
                          }),
                          child: const Text('Delete'))
                    ],
                  );
                });
          },
        ),
        onTap: () {
          nameControl.text = todo.name;
          progressControl = todo.progress.toDouble();
          statusControl = todo.status;
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Edit Todo'),
                    content: Container(
                      height: 150,
                      child: Column(
                        children: [
                          TextField(
                            controller: nameControl,
                          ),
                          Row(
                            children: [
                              const Text('Progress:'),
                              Slider(
                                value: progressControl,
                                onChanged: ((value) {
                                  setState(() => progressControl = value);
                                }),
                                min: 0,
                                max: 100,
                                divisions: 200,
                                label: '$progressControl%',
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Status:'),
                              Switch(
                                value: statusControl,
                                onChanged: ((value) {
                                  setState(() {
                                    statusControl = value;
                                  });
                                }),
                                activeTrackColor: Colors.green,
                                inactiveTrackColor: Colors.red,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            todo.name = nameControl.text;
                            todo.progress = progressControl;
                            todo.status = statusControl;

                            repository.updateToDo(todo);

                            Navigator.pop(context);
                            nameControl.text = '';
                            progressControl = 0;
                            statusControl = false;
                          },
                          child: const Text('Edit'))
                    ],
                  );
                });
              });
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshots) {
    return ListView(
      children: snapshots.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        actions: [
          IconButton(
            onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: const Text('Add Todo'),
                      content: Container(
                        height: 150,
                        child: Column(
                          children: [
                            TextField(
                              controller: nameControl,
                            ),
                            Row(
                              children: [
                                const Text('Progress:'),
                                Slider(
                                  value: progressControl,
                                  onChanged: ((value) {
                                    setState(() => progressControl = value);
                                  }),
                                  min: 0,
                                  max: 100,
                                  divisions: 200,
                                  label: '$progressControl%',
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('Status:'),
                                Switch(
                                  value: statusControl,
                                  onChanged: ((value) {
                                    setState(() {
                                      statusControl = value;
                                    });
                                  }),
                                  activeTrackColor: Colors.green,
                                  inactiveTrackColor: Colors.red,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () {
                              repository.addTodo(ToDo(nameControl.text,
                                  status: statusControl,
                                  progress: progressControl));
                              Navigator.pop(context);
                              nameControl.text = '';
                              progressControl = 0;
                              statusControl = false;
                            },
                            child: const Text('Add'))
                      ],
                    );
                  });
                }),
            //style: ElevatedButton.styleFrom(shape: const CircleBorder()),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: repository.getStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LinearProgressIndicator();
          return _buildList(context, snapshot.data?.docs ?? []);
        },
      ),
    );
  }
}
