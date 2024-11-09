import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  final String userId;
 const Home({Key? key, required this.userId}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference _taskCollection = FirebaseFirestore.instance.collection('tasks');
  TextEditingController _taskController = TextEditingController();
  String? _taskToUpdateId;
 final ImagePicker picker = ImagePicker();
  File? imagePick;
  bool check = false;
  Future<void> _addTask(String task) async {
  if (task.isNotEmpty && currentUser != null) {
    try {
      await _taskCollection.add({
        'task': task,
        'userId': currentUser!.uid,
        'createdAt': Timestamp.now(),  
      });
      _taskController.clear();
      Navigator.of(context).pop();
    } catch (e) {
      print("Error adding task: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add task: $e'),
      ));
    }
  }
}

Future<void> _updateTask(String taskId, String updatedTask) async {
  if (updatedTask.isNotEmpty) {
    await _taskCollection.doc(taskId).update({
      'task': updatedTask,
      'updatedAt': Timestamp.now(),  
    });
    _taskController.clear();
    Navigator.of(context).pop();
  }
}
void _showNoteDetails(DocumentSnapshot task) {
  try {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Format the createdAt and updatedAt timestamps
        String formattedCreatedAt = task['createdAt'] != null
            ? DateFormat('yyyy-MM-dd').format(task['createdAt'].toDate())
            : 'None';
        
        String formattedUpdatedAt = task['updatedAt'] != null
            ? DateFormat('yyyy-MM-dd').format(task['updatedAt'].toDate())
            : 'None';
        
        return AlertDialog(
          title: const Text("Note Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [       
              Text("Task: ${task['task'] ?? 'None'}"),
              const SizedBox(height: 10),
              task['imageUrl'] != null && task['imageUrl'] != ''
                  ? Image.network(task['imageUrl'])
                  : const Text("Image: None"),

              const SizedBox(height: 10),
              Text("Created At: $formattedCreatedAt"),
              Text("Updated At: $formattedUpdatedAt"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    print("Error displaying task details: $e");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error displaying task details: $e'),
    ));
  }
}
void _showProfileDialog() async {
  String userId = currentUser?.uid ?? widget.userId;

  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User ID is not available.'))
    );
    return;
  }

  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (!userDoc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User not found.'))
      );
      return;
    }
 
    String name = userDoc['name'] ?? 'No name found';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Profile Information"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundImage: currentUser?.photoURL != null
                    ? NetworkImage(currentUser!.photoURL!)
                    : const AssetImage('images/image.png') as ImageProvider,
              ),
              const SizedBox(height: 10),
              Text("Name: $name"),
              const SizedBox(height: 5),
              Text("Email: ${currentUser?.email ?? 'No email provided'}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    print("Error fetching user profile: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to fetch profile information.'))
    );
  }
}

void _handleProfileTap() {
  if (currentUser != null) {
    _showProfileDialog();
  } else {
    Navigator.pushReplacementNamed(context, '/login');
  }
}
  
 // Function to show dialog for task input (both add and update)
void _showTaskDialog({String? taskId, String? currentTask}) {
  if (taskId != null && currentTask != null) {
    _taskController.text = currentTask;
    _taskToUpdateId = taskId;
  } else {
    _taskController.clear();
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(taskId == null ? 'Add Task' : 'Update Task'),
        content: TextField(
          controller: _taskController,
          decoration: InputDecoration(hintText: "Enter your task"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (taskId == null) {
                 
                _addTask(_taskController.text);
              } else {
                 
                _updateTaskWithTimestamp(taskId, _taskController.text);   
              }
            },
            child: Text(taskId == null ? 'Add' : 'Update'),
          ),
        ],
      );
    },
  );
}

Future<void> _updateTaskWithTimestamp(String taskId, String updatedTask) async {
  if (updatedTask.isNotEmpty) {
    try {
      await _taskCollection.doc(taskId).update({
        'task': updatedTask,   
        'updatedAt': Timestamp.now(),  
      });
      _taskController.clear();
      Navigator.of(context).pop();
    } catch (e) {
      print("Error updating task: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update task: $e'),
      ));
    }
  }
}

  // Function to delete a task
  Future<void> _deleteTask(String id) async {
    await _taskCollection.doc(id).delete();
  }
  
 // Function to pick and upload photo to Firebase Storage
Future<void> _pickAndUploadPhoto(String taskId) async {
  
  final ImageSource? source = await showDialog<ImageSource>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Gallery'),
          ),
        ],
      );
    },
  );

  if (source != null) {
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      File file = File(image.path);
      try {
        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("user_uploads/${currentUser!.uid}/$taskId.jpg");
        await storageRef.putFile(file);

        // Get the download URL
        String downloadURL = await storageRef.getDownloadURL();

        // Update Firestore document with the image URL
        await _taskCollection.doc(taskId).update({'imageUrl': downloadURL});

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Photo uploaded successfully!'),
        ));
      } catch (e) {
        print("Error uploading photo: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to upload photo: $e'),
        ));
      }
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 20.0),
            Text('Home'),
          ],
        ),
          actions: [
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  _handleProfileTap();
                },
              ),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ]
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Expanded(
                  child:Text('Add your Task here'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showTaskDialog();
                  },
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
          Expanded(
  child: StreamBuilder(
    stream: _taskCollection.where('userId', isEqualTo: currentUser?.uid).snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      var tasks = snapshot.data!.docs;

      return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          var task = tasks[index];
          return ListTile(
            title: Text(task['task']),
            onTap: () {
              _showNoteDetails(task);  
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showTaskDialog(
                      taskId: task.id,
                      currentTask: task['task'],
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteTask(task.id);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () {
                    _pickAndUploadPhoto(task.id);
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  ),
),
        ],
      ),
    );
  }
}
