import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lang.dart';
import 'ContactUs.dart';
import 'RatingScreen.dart';
class AboutApp extends StatefulWidget {
  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  double totalRate = 5;

  String lang="";

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
      body: Column(
        children: [
          Container(height: MediaQuery.of(context).padding.top),
          SizedBox(height: 10,),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: SvgPicture.asset("images/LOGO.svg",),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Card(
                      color: Colors.purple,
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ContactUs()));
                                },
                                child: lang=="ar"?Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(contact,style: GoogleFonts.elMessiri(
                                        textStyle: TextStyle(fontSize: 20,color: Colors.white)
                                    )),
                                    SizedBox(width: 7,),
                                    Image.asset("images/mail.png")
                                  ],
                                ):Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset("images/mail.png"),
                                    SizedBox(width: 7,),
                                    Text(contact,style: GoogleFonts.elMessiri(
                                        textStyle: TextStyle(fontSize: 20,color: Colors.white)
                                    )),
                                  ],
                                ),
                              ),
                            ),
                            Divider(color: Colors.white,),
                            Expanded(
                              flex: 1,
                              child: lang=="ar"?Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(invite,style: GoogleFonts.elMessiri(
                                      textStyle: TextStyle(fontSize: 20,color: Colors.white)
                                  )),
                                  SizedBox(width: 12,),
                                  Image.asset("images/share.png")
                                ],
                              ):Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset("images/share.png"),
                                  SizedBox(width: 12,),
                                  Text(invite,style:  GoogleFonts.elMessiri(
                                      textStyle: TextStyle(fontSize: 20,color: Colors.white)
                                  )),
                                ],
                              ),
                            ),
                            Divider(color: Colors.white,),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RatingScreen()));
                                },
                                child: lang=="ar"?Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(rate,style:  GoogleFonts.elMessiri(
                                        textStyle: TextStyle(fontSize: 20,color: Colors.white)
                                    )),
                                    SizedBox(width: 7,),
                                    Image.asset("images/star.png")
                                  ],
                                ):Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset("images/star.png"),
                                    SizedBox(width: 7,),
                                    Text(rate,style: GoogleFonts.elMessiri(
                                        textStyle: TextStyle(fontSize: 20,color: Colors.white)
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Future<void> showRatingDialog() {
    return showDialog(context: context, builder: (BuildContext){
      return AlertDialog(
          content: SingleChildScrollView(
              child: ListBody(
                children: [
                  SizedBox(height: 10,),
                  RatingBar(
                    initialRating: totalRate,
                    isHalfAllowed: false,
                    // filledColor: Colors.amber,
                    emptyColor: Colors.amber,
                    emptyIcon: Icons.star,
                    filledIcon: Icons.star_border,
                    onRatingChanged: (double rating) {
                      setState(() {
                        totalRate = rating-1;
                      });
                  },
                  ),

                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                          color: Colors.purple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Text("إلغاء",textDirection: TextDirection.rtl,style: TextStyle(fontSize: 16,color: Colors.white),),
                          padding: EdgeInsets.all(15),
                          onPressed: (){
                            Navigator.pop(context);
                          }
                      ),
                      SizedBox(width: 10,),
                      RaisedButton(
                          color: Colors.purple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Text("إضافة",textDirection: TextDirection.rtl,style: TextStyle(fontSize: 16,color: Colors.white),),
                          padding: EdgeInsets.all(15),
                          onPressed: (){
                            // AddMyRate(id);
                            Navigator.pop(context);
                          }
                      ),
                    ],
                  ),

                  SizedBox(height: 15,),
                ],
              )
          )
      );
    });
  }

}
