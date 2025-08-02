import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskflow/components/my_drawer.dart';
import 'package:taskflow/components/task_tile.dart';
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
  void openTaskBox({Task? task}) {
    // prefill if editing
    if (task != null) {
      titleController.text = task.title;
      descriptionController.text = task.description;
    }
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
                if (task != null) {
                  // update task
                  await firestoreService.updateTask(widget.uid, task.id, title: title, description: description);
                }
                else {
                  // add new task
                  await FirestoreService().addTask(
                    widget.uid,
                    title,
                    description,
                  );
                }
                
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

          return TaskTile(
            tasks: tasks,
            uid: widget.uid,
            editTheTask: (task) => openTaskBox(task: task),
          );
        },
      ),
    );
  }
}
