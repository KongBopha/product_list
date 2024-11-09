import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_frebase/login.dart';
import 'package:project_frebase/homescreen.dart';
import 'package:project_frebase/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',  
      routes: {
        '/': (context) => AuthWrapper(), 
        '/login': (context) => Login(),
        '/signup': (context) => Signup(),
        '/home': (context) => Home(userId: '',),  
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return Home(userId: '',);  
        } else {
          return Login(); 
        }
      },
    );
  }
}
