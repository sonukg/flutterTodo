// lib/home_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_bloc.dart';

Color _generateColor(String text) {
  final List<Color> colors = [
    Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple,
    Colors.teal, Colors.pink, Colors.amber, Colors.indigo, Colors.deepOrange
  ];

  int hash = text.hashCode;
  return colors[hash % colors.length]; // Select color based on hash
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Todo App')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Add Todo',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () {
                    context.read<TodoBloc>().add(AddTodo(controller.text));
                    controller.clear();
                  },
                ),
              ),textCapitalization: TextCapitalization.sentences,
            ),
          ),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TodoLoaded) {
                  return ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (context, index) {
                      final todo = state.todos[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: CupertinoListTile(
                          //leading: Icon(Icons.add, color: CupertinoColors.systemGreen, size: 24),
                          leading: CircleAvatar(
                            backgroundColor: _generateColor(todo['description']), // Assign unique color
                            child: Text(
                              todo['description'].isNotEmpty ? todo['description'][0].toUpperCase() : '?',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          title: Text(todo['description'],),
                          trailing: IconButton(
                            icon: Icon(Icons.delete,color: Colors.red,),
                            onPressed: () {
                              int todoId = todo['id'];
                              print("Delete button clicked for ID: $todoId");
                              _showDeleteDialogOne(context, todoId );
                              //context.read<TodoBloc>().add(DeleteTodo(todo['id']));// Dismiss dialog

                              //context.read<TodoBloc>().add(DeleteTodo(todo['id']));
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


void _showDeleteDialogOne(BuildContext context, int todoId) {
  print("Opening delete dialog for ID: $todoId");

  showCupertinoDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return CupertinoAlertDialog(
        title: Text("Delete Todo"),
        content: Text("Are you sure you want to delete this todo?"),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: Text("Cancel"),
            onPressed: () {
              print("Delete canceled for ID: $todoId");
              Navigator.of(dialogContext).pop();
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text("Delete"),
            onPressed: () {
              print("Confirmed delete for ID: $todoId");
              Navigator.of(dialogContext).pop();

              // Ensure ID is passed correctly
              context.read<TodoBloc>().add(DeleteTodo(todoId));
            },
          ),
        ],
      );
    },
  );
}

