import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_frebase/signup.dart';
import 'package:project_frebase/homescreen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;   

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;   
      });
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        print("User logged in: ${userCredential.user!.email}");
        
         
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(userId: userCredential.user!.uid), 
          ),
        );
      } catch (e) {
        print("Error: $e");
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Failed'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;   
        });
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
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email field
                    _buildTextField(
                      controller: emailController,
                      hintText: "Email",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30.0),

                    // Password field
                    _buildTextField(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30.0),

                    // Login button with loading indicator
                    _isLoading
                        ? CircularProgressIndicator()  
                        : ElevatedButton(
                            onPressed: login,
                            child: Text('Login'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                            ),
                          ),
                    const SizedBox(height: 15.0),
                    
                     
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      child: Text('Don\'t have an account? Sign up'),
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
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black, fontSize: 12),
        ),
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}
