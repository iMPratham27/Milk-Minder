
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:milkminder/splash_screen.dart";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      // Enter your project credentials
      apiKey: "XXXXX...", 
      appId: "XXXX...", 
      messagingSenderId: "XXX...", 
      projectId: "XXXX...."
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{

  const MyApp({super.key});

  @override  
  Widget build(BuildContext context){
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}