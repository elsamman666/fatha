import 'dart:async';
import 'dart:io';
import 'package:fatha/lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as Path;
import '../LangVar.dart';
import 'ChooseLanguage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'HomeScreen.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool initialized = false;

  Database db;

  List<Map<String, dynamic>> databaseResult;
  List<String> ayatAsWords;
  String finalResult = " ";
  String orginal = "";

  initdatabse() async {
    var databasesPath = await getDatabasesPath();
    var path = Path.join(databasesPath, "dic.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(Path.dirname(path)).create(recursive: true);
      } catch (_) {
        print("EErrors");
      }
      print("finish copy database");

      // Copy from asset
      ByteData data = await rootBundle.load(Path.join("assets", "dic.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    initialized = true;

// open the database
    db = await openDatabase(path, readOnly: true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initdatabse();
    Timer(Duration(seconds: 3),()async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String lang = preferences.getString("lang");
      if(lang==null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChooseLanguage()));
      }else{
        getCurrentLang(setState);
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
        child: SvgPicture.asset("images/LOGO.svg",height: 200,width: 200,fit: BoxFit.fill,),
      ),
    );
  }
}
