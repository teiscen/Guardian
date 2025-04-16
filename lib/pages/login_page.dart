import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guardian/components/my_button.dart';
import 'package:guardian/components/my_textfield.dart';
import 'package:guardian/helper/helper_function.dart';


class LoginPage extends StatefulWidget {
  final void Function()? onTap;

 	LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController    = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void login() async { 
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text,
      );

      if (context.mounted) Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      displayMessageToUser(e.code, context);
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
                  text: 'Login', 
                  onTap: login
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary
                      )
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register Here",
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