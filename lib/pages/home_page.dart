import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// To connect to Chris' server
import 'package:http/http.dart' as http;


Future<void> setSchedule() async {
  // Example Http request
  var url = Uri.parse('https://guardian-api-3uje.onrender.com/set_schedule/');
  var response = await http.post(
    url, 
    headers: {"Content-Type": "application/json"},  
    body: jsonEncode({ 
      "name": "Teoman", 
      "schedule": "CMPT 307: MON 1200-130 WED 1200-230, CMPT 383: TUE 230-6, CMPT:431: FRI 230-6" }),
  );
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  // print(await http.read(Uri.parse('https://guardian-api-3uje.onrender.com/set_schedule/')));
}

Future<void> setScheduleChange() async {
  // Example Http request
  var url = Uri.parse('https://guardian-api-3uje.onrender.com/schedule_change/');

  var response = await http.post(
    url, 
    headers: {"Content-Type": "application/json"},  
    body: jsonEncode({ 
      "name": "Teoman", 
      "change": "Remove CMPT 383, and update 307 so it ends at 1330" }),
  );
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  // print(await http.read(Uri.parse('https://guardian-api-3uje.onrender.com/schedule_change/')));
}

Future<void> saveNameToFirestore(String name) async {
  final url = Uri.parse('https://guardian-api-3uje.onrender.com/save');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'name': name}),
  );

  if (response.statusCode == 200) {
    print('Success: ${response.body}');
  } else {
    print('Failed with status: ${response.statusCode}');
  }
}

Future<void> readNameFromFirestore(String name) async {
  final url = Uri.parse('https://guardian-api-3uje.onrender.com/read');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'name': name})
  );

  if(response.statusCode == 200){
    print(jsonDecode(response.body));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // setSchedule();
    // setScheduleChange();
    // saveNameToFirestore("Test Name");
    // readNameFromFirestore("Test Name");

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
           onPressed: logout, 
           icon: Icon(Icons.logout),
          ),
        ],
      )
    );
  }
}