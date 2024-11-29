
import 'package:flutter/material.dart';
import 'package:milkminder/home_screen.dart';
import 'package:milkminder/landingpage.dart';
import 'package:milkminder/session_data.dart';

class SplashScreen extends StatelessWidget{

  const SplashScreen({super.key});

  static bool status = false;

  void navigate(BuildContext context){
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        
        await SessionData.getSessionData();

        if(SessionData.isLogin == true){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context){
              return HomeScreen(
                userEmail :SessionData.emailId!,
              );
            })
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context){
              return const LandingPage();
            })
          );
        }
      }
    );
  }

  @override  
  Widget build(BuildContext context){
    navigate(context);
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 250,
          width: 250,
          child: Image.asset("./assets/924995327559Milk.gif"),
        ),
      ),
    );
  }
}