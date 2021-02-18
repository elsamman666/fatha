import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<String> langList = ['ar', 'en'];
  String langDire = 'lang/';

  // await translator.init(assetsDirectory: langDire,languagesList: langList,localeDefault: LocalizationDefaultType.device);
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Alfateha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // fontFamily: Google,
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme).copyWith(
          body1: GoogleFonts.cairo(textStyle: Theme.of(context).textTheme.body1),
        ),
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

