import 'dart:async';
import 'package:fatha/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChooseLanguage.dart';
import 'package:flutter_svg/flutter_svg.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3),()async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String lang = preferences.getString("lang");
      if(lang==null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChooseLanguage()));
      }else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen(2)));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SvgPicture.asset("images/LOGO.svg",height: 200,width: 200,fit: BoxFit.fill),
      ),
    );
  }
}
