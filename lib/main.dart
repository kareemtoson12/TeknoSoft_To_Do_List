import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teknotodolist/firebase_options.dart';
import 'package:teknotodolist/pages/addTodo.dart';

import 'package:teknotodolist/pages/homepage.dart';
import 'package:teknotodolist/pages/signUp.dart';

import 'package:teknotodolist/service/Auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentpage = SignUp();
  AuthClass authClass = AuthClass();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    checklogin();
  }

  void checklogin() async {
    String? token = await authClass.gettoken();
    if (token != null) {
      setState(() {
        currentpage = AddToDo();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'to_doApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage());
  }
}
