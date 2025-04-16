import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const MyTextfield({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context){
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText, 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
    );
  }

}