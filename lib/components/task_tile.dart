import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskflow/models/task_model.dart';
import 'package:taskflow/services/database/firestore_service.dart';

class TaskTile extends StatelessWidget {
  final String uid;
  final List<Task> tasks;
  final void Function(Task task) editTheTask;

  const TaskTile({
    super.key,
    required this.tasks,
    required this.uid,
    required this.editTheTask,
  });

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Slidable(
            key: ValueKey(task.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => editTheTask(task),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (context) async {
                    await firestoreService.deleteTask(uid, task.id);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: task.description.isNotEmpty
                  ? Text(task.description)
                  : null,
              trailing: Checkbox(
                value: task.isDone,
                onChanged: (value) {
                  firestoreService.updateTask(
                    uid,
                    task.id,
                    isDone: value ?? false,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
