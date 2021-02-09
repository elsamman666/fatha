import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rating_bar/rating_bar.dart';

import '../LeftToRight.dart';
import 'HomeScreen.dart';
class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double totalRate = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen(1)));
            },
            child: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: 35,)),
      ),
      body: Column(
        children: [
          Container(height: MediaQuery.of(context).padding.top),
          SizedBox(height: 10,),
          Container(
            alignment: Alignment.center,
            child: SvgPicture.asset("images/LOGO.svg",),
          ),
          SizedBox(height: 20,),
          RatingBar(
            initialRating: totalRate,
            isHalfAllowed: false,
            filledColor: Colors.amber,
            // maxRating: 7,
            emptyColor: Colors.black,
            emptyIcon: Icons.star_border,
            filledIcon: Icons.star,
            onRatingChanged: (double rating) {
              setState(() {
                totalRate = rating;
                print(totalRate);
              });
            },
          ),
          SizedBox(height: 50,),
          InkWell(
            onTap: (){
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen(2)));
            },
            child: Container(
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 25),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(
                  // stops: [
                  //   0.7,
                  //   0.3,
                  // ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffBE7DFF),Color(0xff791AB8)],
                ),
              ),
              child: Text(tr("send"),style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
