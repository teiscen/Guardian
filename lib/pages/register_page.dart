import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guardian/components/my_button.dart';
import 'package:guardian/components/my_textfield.dart';
import 'package:guardian/helper/helper_function.dart';

class RegisterPage extends StatefulWidget {

  final void Function()? onTap;  

 	RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();

  TextEditingController emailController    = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  void register() async { 
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if(passwordController.text != confirmPasswordController.text){
      Navigator.pop(context);
      displayMessageToUser("Passwords don't match!", context);
    
    } else {
      try {
        UserCredential? userCredential = 
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, 
            password: passwordController.text,
          );

          Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        displayMessageToUser(e.code, context);
      }
    }
  }

	@override
  	Widget build(BuildContext context) {
    	return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ), 
                const SizedBox(height: 15),
                const Text(
                  "M O G I",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 30),
                MyTextfield(
                  hintText: 'Enter Username', 
                  obscureText: true, 
                  controller: usernameController
                ),
                const SizedBox(height: 10),
                MyTextfield(
                  hintText: 'Enter E-mail.',
                  obscureText: false,
                  controller: emailController
                ),
                const SizedBox(height: 10),
                MyTextfield(
                  hintText: 'Enter Password', 
                  obscureText: true, 
                  controller: passwordController
                ),
                const SizedBox(height: 10),
                MyTextfield(
                  hintText: 'Confirm Password', 
                  obscureText: true, 
                  controller: confirmPasswordController
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary
                      ), 
                    )
                  ]
                ),
                MyButton(
                  text: 'Register', 
                  onTap: register
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary
                      )
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "login Here",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    )
                  ],
                )
              ]),
          ),
        )
      );
  	}
}