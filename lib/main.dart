import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:guardian/auth/auth.dart';
import 'package:guardian/auth/login_or_register.dart';
import 'package:guardian/firebase_options.dart';
import 'package:guardian/pages/home_page.dart';
import 'package:guardian/theme/dark_mode.dart';
import 'package:guardian/theme/light_mode.dart';

import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/calender_page.dart'; // Make sure this import exists


void main() async {
//   runApp(const HomePage());
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
    	return MaterialApp(	
			debugShowCheckedModeBanner: false,
      // home: const AuthPage(),
      // home: const HomePage(),
      home: const WeeklySchedulePage(activities: mockUserActivities),
      theme: darkMode
      // theme: lightMode,
      // darkTheme: darkMode,
		);
  	}	
}

