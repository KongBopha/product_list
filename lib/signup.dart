import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_frebase/login.dart';

 
class Item {
  String id;
  String name;

  Item({required this.id, required this.name});

  factory Item.fromMap(Map<String, dynamic> map, String id) {
    return Item(id: id, name: map['name']);
  }
}

 
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email = "", password = "", name = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController mailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

 
  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: mailController.text.trim(),
          password: passController.text.trim(),
        );

         
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': nameController.text.trim(),
          'email': mailController.text.trim(),
        });

        print("User signed up: ${userCredential.user!.email}");

         
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      } catch (e) {
        print("Error: $e");
        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                'https://th.bing.com/th/id/OIP.5UBwLl4qUftwsOZ9ieK_LQHaFL?rs=1&pid=ImgDetMain',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30)),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Name",
                          hintStyle: TextStyle(
                            color: Colors.black, fontSize: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30)),
                      child: TextFormField(
                        controller: mailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: Colors.black, fontSize: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
                        controller: passController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: Colors.black, fontSize: 12,
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    ElevatedButton(
                      onPressed: signUp,
                      child: Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
