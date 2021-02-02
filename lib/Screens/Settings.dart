import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../LeftToRight.dart';
import 'PrivacyScreen.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String lang;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 0), ()async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        lang = preferences.getString("lang");
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 10,bottom: 10,left: 20,right: 20),
        child: ListView(
          children: [
            Text(tr("setting"),textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: lang=="en"?MainAxisAlignment.start:MainAxisAlignment.end,
              children: [
                Text(tr("chooseLang"),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ],
            ),
            SizedBox(height: 8,),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              elevation: 7,
              child: Container(
                height: 125,
                child: Column(
                  children: [
                    Expanded(
                      flex:1,
                      child: ListTile(
                        onTap: ()async{
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          setState(() {
                            lang = 'ar';
                            preferences.setString("lang", lang);
                            translator.setNewLanguage(
                                context,
                                newLanguage: lang,
                                restart: true);
                          });
                        },
                        title: Row(
                          mainAxisAlignment: lang=="en"?MainAxisAlignment.start:MainAxisAlignment.end,
                          children: [
                            Text(tr("arabic"))
                          ],
                        ),
                        leading: lang=="en"?Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: Colors.blue
                          ),
                          child: Container(
                            margin: EdgeInsets.all(1),
                            height: 13,
                            width: 13,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                color: Colors.white
                            ),
                            child: lang=='ar'?Container(
                              margin: EdgeInsets.all(1),
                              height: 13,
                              width: 13,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: Colors.blue
                              ),
                            ):SizedBox(),
                          ),
                        ):SizedBox(),
                        trailing: lang=="ar"?Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.blue
                          ),
                          child: Container(
                            margin: EdgeInsets.all(1),
                            height: 13,
                            width: 13,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                color: Colors.white
                            ),
                            child: lang=='ar'?Container(
                              margin: EdgeInsets.all(1),
                              height: 13,
                              width: 13,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: Colors.blue
                              ),
                            ):SizedBox(),
                          ),
                        ):SizedBox(),
                      ),
                    ),
                    Divider(),
                    Expanded(
                      flex:1,
                      child: ListTile(
                        onTap: ()async{
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          setState(()  {
                              lang = 'en';
                              preferences.setString("lang", lang);
                              translator.setNewLanguage(
                                  context,
                                  newLanguage: lang,
                                  restart: true);
                            });
                        },
                        title: Row(
                          mainAxisAlignment: lang=="en"?MainAxisAlignment.start:MainAxisAlignment.end,
                          children: [
                            Text(tr("english"))
                          ],
                        ),
                        leading: lang=="en"?Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: Colors.blue
                          ),
                          child: Container(
                            margin: EdgeInsets.all(1),
                            height: 13,
                            width: 13,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                color: Colors.white
                            ),
                            child: lang=='en'?Container(
                              margin: EdgeInsets.all(1),
                              height: 13,
                              width: 13,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: Colors.blue
                              ),
                            ):SizedBox(),
                          ),
                        ):SizedBox(),
                        trailing: lang=="ar"?Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: Colors.blue
                          ),
                          child: Container(
                            margin: EdgeInsets.all(1),
                            height: 13,
                            width: 13,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                color: Colors.white
                            ),
                            child: lang=='en'?Container(
                              margin: EdgeInsets.all(1),
                              height: 13,
                              width: 13,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: Colors.blue
                              ),
                            ):SizedBox(),
                          ),
                        ):SizedBox(),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 40,),
            // Text("أخري",textAlign: TextAlign.right,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            // SizedBox(height: 7,),
            // Card(
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.all(Radius.circular(10))
            //   ),
            //   elevation: 7,
            //   child: ListTile(
            //     onTap: (){
            //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PrivacyScreen()));
            //     },
            //     title: Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         Text("سياسة الخصوصية",style: TextStyle(color: Color(0xffDF0CFF)),),
            //       ],
            //     ),
            //     trailing: Image.asset("images/praivacy.png"),
            //     leading: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: 30,),
            //   ),
            // ),
            // SizedBox(height: 5,),
            // Card(
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(10))
            //   ),
            //   elevation: 7,
            //   child: ListTile(
            //     onTap: (){
            //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PrivacyScreen()));
            //     },
            //     title: Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         Text("الشروط والأحكام",style: TextStyle(color: Color(0xff37C703)),),
            //       ],
            //     ),
            //     trailing: Image.asset("images/password.png"),
            //     leading: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: 30,),
            //   ),
            // ),
            // SizedBox(height: 5,),
            // Card(
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(10))
            //   ),
            //   elevation: 7,
            //   child: ListTile(
            //     onTap: (){
            //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PrivacyScreen()));
            //     },
            //     title: Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         Text("نبذة",style: TextStyle(color: Color(0xffF0B000)),),
            //       ],
            //     ),
            //     trailing: Image.asset("images/book.png"),
            //     leading: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: 30,),
            //   ),
            // ),
            // SizedBox(height: 50,),
            // Card(
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(10))
            //   ),
            //   elevation: 7,
            //   child: ListTile(
            //     title: Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         Text("خروج",style: TextStyle(color: Color(0xffC70101)),),
            //       ],
            //     ),
            //     trailing: Image.asset("images/logout.png"),
            //     leading: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: 30,),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
