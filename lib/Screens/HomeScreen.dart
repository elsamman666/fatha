import 'package:flutter/material.dart';
import '../LeftToRight.dart';
import 'AboutApp.dart';
import 'ChooseLanguage.dart';
import 'HomePage.dart';
import 'Settings.dart';
class HomeScreen extends StatefulWidget {
  int currentIndex;

  HomeScreen(this.currentIndex);
  @override
  _HomeScreenState createState() => _HomeScreenState(this.currentIndex);
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex;

  _HomeScreenState(this.currentIndex);

  List<Widget> currentPage = [Settings(),AboutApp(),HomePage()];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        if(currentIndex==2) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChooseLanguage()));
        }else{
          setState(() {
            currentIndex = 2;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: currentPage[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [BottomNavigationBarItem(icon: Icon(Icons.settings),label: tr("setting"),activeIcon: Icon(Icons.settings,color: Colors.purple,)),
            BottomNavigationBarItem(icon: Icon(Icons.error),label: tr("about"),activeIcon: Icon(Icons.error,color: Colors.purple,)),
            BottomNavigationBarItem(icon: Icon(Icons.home),label: tr("home"),activeIcon: Icon(Icons.home,color: Colors.purple,))],
            currentIndex: currentIndex,
          iconSize: 28,
          onTap: (index){
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
