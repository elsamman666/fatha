import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../LeftToRight.dart';
import 'HomeScreen.dart';
class ChooseLanguage extends StatefulWidget {
  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  bool dropDownState = false;
  String lang = "en";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("images/LOGO.svg",height: 180,width: 180,fit: BoxFit.fill),
            SizedBox(height: 15,),
            Text("اختر اللغة",style: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            Text("choose language",style: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            SizedBox(height: 30,),
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 60,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Colors.black
                      ),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            dropDownState = true;
                          });
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          margin: EdgeInsets.all(1),
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              color: Colors.white
                          ),
                          child: lang == "en" ? Row(
                                children: [
                                  Icon(Icons.keyboard_arrow_down),
                                  Spacer(),
                                  Text("English"),
                                  SizedBox(width: 8,),
                                  Image.asset("images/english.png")
                                ],
                              ):Row(
                            children: [
                              Icon(Icons.keyboard_arrow_down),
                              Spacer(),
                              Text("Arabic"),
                              SizedBox(width: 8,),
                              Image.asset("images/arabic.png")
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 80,)
                  ],
                ),
                dropDownState?Card(
                  margin: EdgeInsets.only(top:5,right: 50,left: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (){
                            setState(() {
                              dropDownState = false;
                              lang = "en";
                            });
                          },
                          child: Container(
                            height: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("English"),
                                  SizedBox(width: 8,),
                                  Image.asset("images/english.png")
                                ],
                              ),
                          ),
                        ),
                        Divider(),
                        InkWell(
                          onTap: (){
                            setState(() {
                              dropDownState = false;
                              lang = "ar";
                            });
                          },
                          child: Container(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Arabic"),
                                SizedBox(width: 8,),
                                Image.asset("images/arabic.png")
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ):SizedBox()
              ],
            ),
            SizedBox(height: 25,),
            InkWell(
              onTap: ()async{
                // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen(2)));
                SharedPreferences preferences = await SharedPreferences.getInstance();
                preferences.setString("lang", lang);
                translator.setNewLanguage(
                    context,
                    newLanguage: lang,
                    restart: true);
              },
              child: Container(
                height: 55,
                margin: EdgeInsets.symmetric(horizontal: 45),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    // stops: [
                    //   0.7,
                    //   0.3,
                    // ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xffAF1FAA),Color(0xff9318D1)],
                  ),
                ),
                child: Text(tr("submit"),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
