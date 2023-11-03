import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseauth/categories/addCard.dart';
import 'package:firebaseauth/screens/homepage.dart';
import 'package:firebaseauth/siginandup/login.dart';
import 'package:firebaseauth/siginandup/signup.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes ',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          titleTextStyle: const TextStyle(color: Colors.orange,fontSize:15,fontWeight: FontWeight.bold),
          iconTheme: const IconThemeData(
            color: Colors.orange,
          ),
        ),
      ),
      home: (
          FirebaseAuth.instance.currentUser!=null&&FirebaseAuth.instance.currentUser!.emailVerified)?
       HomePage():const Login(),
      routes: {
        "signup":(context) => const SignUp(),
        "login":(context) => const Login(),
        "homepage": (context) =>   HomePage(),
        "addCategory": (context) =>  const AddCategory(),

      },
      
    );
  }
}