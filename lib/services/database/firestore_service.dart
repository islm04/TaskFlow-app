import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskflow/models/task_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // reference to a user's task collection
  CollectionReference<Map<String, dynamic>> getUserTaskCollection(String uid) {
    return _db.collection('Users').doc(uid).collection('Tasks');
  }

  // create a new task
  Future<void> addTask(String uid, String title, String description) async {
    await getUserTaskCollection(uid).add({
      'title': title,
      'description': description,
      'isDone': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // get a stream of tasks for real-time updates
  Stream<List<Task>> getTasks(String uid) {
    return getUserTaskCollection(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Task.fromDocumentSnapshot(doc)).toList());
  }

  // update a task
  Future<void> updateTask(
    String uid,
    String taskId, {
    String? title,
    String? description,
    bool? isDone,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (isDone != null) data['isDone'] = isDone;

    await getUserTaskCollection(uid).doc(taskId).update(data);
  }

  // delete a task
  Future<void> deleteTask(String uid, String taskId) async {
    await getUserTaskCollection(uid).doc(taskId).delete();
  }
}
