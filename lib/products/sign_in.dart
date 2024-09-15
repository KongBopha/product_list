import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
      ),
      body: Column(
        children: [
          // Image and overlay text
          Container(
            height: MediaQuery.of(context).size.height * 0.2, // Adjust height as needed
            child: Stack(
              children: [
                // Background image
                Positioned.fill(
                  child: Image.network(
                    "https://deploy.equinix.com/media/blog/images/42e7aaa88b48137a16a1acd04ed91125/CBaY-bloghow.to.win.at.platform.engineering.webp",
                    fit: BoxFit.cover,
                  ),
                ),
                // Overlay text
                Positioned(
                  top: 20,
                  left: 20,
                  child: Text(
                    'Welcome,\n Sign In',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Spacer between image and TextField
          SizedBox(height: 20),
          // TextField
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: ("Full Name"),
                enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.green,
                width: 2.0,
              ),
              ),
            ),
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: ("Email"),
                enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.green,
                width: 2.0,
              ),
              ),
            ),
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: ("Password"),
                enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.green,
                width: 2.0,
              ),
              ),
            ),
          ),
          ),
        SizedBox(height: 20.0,),
        ElevatedButton(
          onPressed: (){
          print("Button Pressed!");
          },
           child:Text("Sign up")),
        ],
      ),
    );
  }
}
