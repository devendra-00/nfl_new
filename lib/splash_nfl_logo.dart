import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfl_new/home_screen.dart';
//import 'package:nfl_final/home_screen.dart';
import 'package:nfl_new/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class SplashNFL extends StatefulWidget {
  const SplashNFL({super.key});

  @override
  State<SplashNFL> createState() => _SplashNFLState();
}

class _SplashNFLState extends State<SplashNFL> {
  final _storage = FlutterSecureStorage();
  @override
  void initState(){
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.teal.shade100,Colors.grey.shade200, ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
            ),
          ),
        child: Center(
          child: SvgPicture.asset("assets/images/National_Fertilizers_Logo.svg",
            width: 200,height: 200,)
              .animate()
              .fadeIn()
              .then().shimmer(duration: Duration(seconds: 4)),
        )
        ),
    );
  }
  void whereToGo() async {
    String? isLoggedIn = await _storage.read(key: "LoggedIn");
    print(isLoggedIn);

    Timer(Duration(seconds: 4), () {
      if (isLoggedIn != null) {
        if (isLoggedIn == "true") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => homeScrren()), // Replace Login() with your home screen widget
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    });
  }
}

