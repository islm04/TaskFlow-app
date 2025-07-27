import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskflow/components/my_drawer.dart';
import 'package:taskflow/models/task_model.dart';
import 'package:taskflow/services/database/firestore_service.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // firestore
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Add a new task function
  void openTaskBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'TaskName'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              titleController.clear();
              descriptionController.clear();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final description = descriptionController.text.trim();

              if (title.isNotEmpty) {
                await FirestoreService().addTask(
                  widget.uid,
                  title,
                  description,
                );
                Navigator.pop(context);
                titleController.clear();
                descriptionController.clear();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Home Page",
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 21, 55, 112),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: MyDrawer(),

      // floating action button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 21, 55, 112),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(25),
        ),
        elevation: 0,
        onPressed: () => openTaskBox(),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      //body
      body: StreamBuilder<List<Task>>(
        stream: FirestoreService().getTasks(widget.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          final tasks = snapshot.data!;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Slidable(
                key: ValueKey(task.id),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        // edit
                      },
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context) async {
                        await firestoreService.deleteTask(widget.uid, task.id);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: task.description.isNotEmpty
                        ? Text(task.description)
                        : null,
                    trailing: Checkbox(
                      value: task.isDone,
                      onChanged: (value) {
                        firestoreService.updateTask(
                          widget.uid,
                          task.id,
                          isDone: value,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
