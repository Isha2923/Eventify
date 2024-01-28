// ignore_for_file: use_build_context_synchronously
import 'package:eventify/Myhomepage.dart';
import 'package:eventify/page2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);


  @override
  _SignUpState createState() => _SignUpState();
}


class _SignUpState extends State<SignUp> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;


    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up", style: TextStyle(color:Colors.white70),),
        backgroundColor:  Color(0xff9B61BD),
        automaticallyImplyLeading: false,

      ),
      body:Stack(
        children: [
        Image.asset(
        "images/bg2.jpg",
        height: size.height,
        width: size.width,
        fit: BoxFit.cover,
        ),
        SingleChildScrollView(
          child :SizedBox(
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  top: size.height * 0.1,
                  right: 20,
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                      width: 20,
                    ),
                    Image.asset(
                      "images/signup.png",
                      height: 100,
                      width:500,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Enter Email",
                        icon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      controller: _emailTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Enter Password",
                        icon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),


                      controller: _passwordTextController,
                      obscureText: true, // Hide the password
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: helper,
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        backgroundColor: Color(0xffAE72FD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(150, 50),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => MyPage()));
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        ],
      ),
    );
  }


  Future<bool> doesUserExist(String email) async {
    try {
      // Check if the email is already registered
      var methods =
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);


      // If methods is not empty, a user with this email exists
      return methods.isNotEmpty;
    } catch (e) {

      return false;
    }
  }


  void helper() async {
    final userExists = await doesUserExist(_emailTextController.text);
    if (userExists) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('User Exists'),
          content: const Text('This email is already registered.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailTextController.text,
            password: _passwordTextController.text);
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('New User Registered.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyPage()));
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } on FirebaseAuthException catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Error'),
            content: Text("Error ${error.toString()}"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
