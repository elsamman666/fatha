import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'HomeScreen.dart';
class PrivacyScreen extends StatefulWidget {
  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(right: 25,left: 25,top: 10,bottom: 10),
        child: ListView(
          children: [
            Row(
              children: [
                InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen(0)));
                    },
                    child: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: 35,)),
              ],
            ),
            SizedBox(height: 30,),
            SvgPicture.asset("images/LOGO.svg",height: 170,),
            SizedBox(height: 20,),
            Text("لوريم ايبسوم هو نموذج افتراضي يوضع في التصاميم لتعرض على العميل ليتصور طريقه وضع النصوص بالتصاميم سواء كانت تصاميم مطبوعه ... بروشور او فلاير على سبيل المثال ... او نماذج مواقع انترنت \n\n وعند موافقه العميل المبدئيه على التصميم يتم ازالة هذا النص من التصميم ويتم وضع النصوص النهائية المطلوبة للتصميم ويقول البعض ان وضع النصوص التجريبية بالتصميم قد تشغل المشاهد عن وضع الكثير من الملاحظات او الانتقادات للتصميم الاساسي. \n\nوخلافاَ للاعتقاد السائد فإن لوريم إيبسوم ليس نصاَ عشوائياً، بل إن له جذور في الأدب اللاتيني الكلاسيكي منذ العام 45 قبل الميلاد. من كتاب \"حول أقاصي الخير والشر\"",
            textAlign: TextAlign.right,textDirection: TextDirection.rtl,style: TextStyle(fontSize: 17),)
          ],
        ),
      ),
    );
  }
}
