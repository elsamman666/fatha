import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../LeftToRight.dart';
import 'ListningNewMuslimScreen.dart';
import 'ListningScreen.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
            ),
            Container(
              height: MediaQuery.of(context).size.height*.65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(170),bottomLeft:Radius.circular(170)),
                gradient: LinearGradient(
                  // stops: [
                  //   0.7,
                  //   0.3,
                  // ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff9318D1),Color(0xffAF1FAA),],
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(left: 40,right: 40,top: MediaQuery.of(context).size.height*.08,bottom: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height*.15,
                        child: SvgPicture.asset("images/logoWhite.svg",height: 150,)),
                    SizedBox(height: 20,),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(55)),
                      ),
                      color: Colors.white,
                      child: Container(
                        height: MediaQuery.of(context).size.height*.6,
                        padding: EdgeInsets.only(left: 20,right: 20,top: 30,),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ListningScreen(tr("smallLearn"),0,0)));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(flex:1,child: Image.asset("images/small.png",)),
                                      SizedBox(height: 5,),
                                      Expanded(flex:1,child: Text(tr("smallLearn"),textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 17,fontWeight: FontWeight.bold))),
                                      // SizedBox(height: 10,)
                                    ],
                                  ),
                                )
                            ),
                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ListningScreen(tr("largeLearn"),0,1)));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(flex:1,child: Image.asset("images/large.png",)),
                                      SizedBox(height: 5,),
                                      Expanded(flex:1,child: Text(tr("largeLearn"),textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 17,fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                )
                            ),
                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ListningNewMuslimScreen(tr("newLearn"),0)));
                                  },
                                  child: Column(
                                    children: [
                                      // SizedBox(height: 5,),
                                      Expanded(flex:1,child: Image.asset("images/new.png",)),
                                      SizedBox(height: 5,),
                                      Expanded(flex:1,child: Text(tr("newLearn"),textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
      ),
    );
  }
}
