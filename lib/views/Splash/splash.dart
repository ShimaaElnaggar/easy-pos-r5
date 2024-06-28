import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:easy_pos_r5/views/On%20Boarding/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with SingleTickerProviderStateMixin{
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoarding()),
      );
    });
  }
  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Colors.blue.shade300,
              ],
                  begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: FadeInUp(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: SizedBox(height:45,width:45,child: Image.asset('assets/images/pos.png')),
              ),
              const SizedBox(height: 20,),
              const Text(
                'Easy Pos',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize:32,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}