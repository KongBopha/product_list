import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        title: const Text("Welcome to To do List"),
      ),
      body:SafeArea(
        child:SingleChildScrollView(
        child: Container(
        child:Column(
          children: [
          Image.network("https://capitalxtend.com/uploads/w-how-does-forex-trading-work.webp"),
          Padding(padding: const EdgeInsets.all(10.0),
          ),
        TextField(
          style: TextStyle(fontSize: 16,color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email, color: Colors.blue), // Color of prefixIcon
            contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
            hintText: 'Email',
            hintStyle: TextStyle(color:Colors.blue),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.blueAccent,
                width: 2.0,
              ),
              
            )
          ),
        ),
         SizedBox(height: 20), 
        TextField(
          obscureText: true,
          style: TextStyle(fontSize: 16,color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: Colors.blue), // Color of prefixIcon
            suffixIcon: Icon(Icons.visibility_off, color: Colors.blue), // Color of suffixIcon
            contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
            hintText: 'Password',
            hintStyle: TextStyle(color:Colors.blue),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.blueAccent,
                width: 2.0,
              ),
              
            )
          ),
        ),
        SizedBox(height: 20.0,),
        ElevatedButton(
          onPressed: (){
          print("Button Pressed!");
          },
           child:Text("Sign up")),
        SizedBox(height: 20.0,),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child:  Text("Don't have account yet?"), 
            ),
            SizedBox(width: 25.0,),
            ElevatedButton(
              onPressed: (){
                print("Account Created!");
              }, child: Text("Click here to sign in"))
          ],
        ),
        ],
          ),
      ),
      ),
      ),
    );
  }
}