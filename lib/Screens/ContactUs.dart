import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../lang.dart';
import 'HomeScreen.dart';
class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  double padding = 15 ,padding2 = 15 , padding3 = 15;

  var contentController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen(1)));
            },
            child: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: 35,)),

      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.only(right: 15,left: 15,top: 10,),
          child: ListView(
            children: [
              SizedBox(height: 30,),
              SvgPicture.asset("images/LOGO.svg",height: 200,),
              SizedBox(height: 20,),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  controller: nameController,
                  // textAlign: TextAlign.right,
                  // maxLines: 15,
                  onTap: (){
                    setState(() {
                      padding = 35;
                    });
                  },
                  validator: (value){
                    if(value.isEmpty){
                      return enterName;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: name,
                    contentPadding: EdgeInsets.symmetric(horizontal: padding),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Colors.purple, width: 1)
                    ),

                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Colors.purple, width: 1)
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1)
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Colors.purple, width: 1)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  controller: phoneController,
                  // textAlign: TextAlign.right,
                  // maxLines: 15,
                  keyboardType: TextInputType.phone,
                  onTap: (){
                    setState(() {
                      padding2 = 35;
                    });
                  },
                  validator: (value){
                    if(value.isEmpty){
                      return enterPhone;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: phone,
                    contentPadding: EdgeInsets.symmetric(horizontal: padding2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Colors.purple, width: 1)
                    ),

                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Colors.purple, width: 1)
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1)
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Colors.purple, width: 1)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  controller: contentController,
                  // textAlign: TextAlign.right,
                  maxLines: 9,
                  onTap: (){
                    setState(() {
                      padding3 = 35;
                    });
                  },
                  validator: (value){
                    if(value.isEmpty){
                      return enterMsg;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: msg,
                    contentPadding: EdgeInsets.symmetric(horizontal: padding3,vertical: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Colors.purple, width: 1)
                    ),

                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Colors.purple, width: 1)
                    ),

                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1)
                    ),

                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Colors.purple, width: 1)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              InkWell(
                onTap: (){
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen(2)));
                  if(formKey.currentState.validate()) {
                    PostContactData();
                  }
                },
                child: Container(
                  height: 55,
                  // margin: EdgeInsets.symmetric(horizontal: 45),
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
                  child: Text(send,style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> PostContactData() async{
    var request = http.MultipartRequest('POST', Uri.parse('https://api.moshafkids.eqratech.com/contact/sendMsg.php'));
    request.fields.addAll({
      'userid': '12',
      "name": nameController.text,
      "mobile": phoneController.text,
      "content": contentController.text,
    });
    Fluttertoast.showToast(
        msg: sendContact,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );
  }
}
