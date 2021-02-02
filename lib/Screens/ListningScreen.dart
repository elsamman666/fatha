import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/tau.dart';
import 'package:flutter_svg/svg.dart';
import '../LeftToRight.dart';
import 'HomeScreen.dart';
import 'ReadingScreen.dart';
class ListningScreen extends StatefulWidget {
  String dept;
  int index,deptId;
  ListningScreen(this.dept,this.index,this.deptId);

  @override
  _ListningScreenState createState() => _ListningScreenState(this.index,this.deptId);
}


class _ListningScreenState extends State<ListningScreen> {
  int index;
  int deptId;
  _ListningScreenState(this.index,this.deptId);
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  Map ayat = {"records": [
    {
      "id": 1,
      "surahIndex": "1",
      "ayahIndex": "1",
      "tokensCount": "4",
      "verse": "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
      "aya": "بسم الله الرحمان الرحيم",
      "translatedverse": "In the Name of Allāh, the Most Gracious, the Most Merciful",
      "audio": "-",
      "prize": "10",
      "complete": "0"
    },
    {
      "id": 2,
      "surahIndex": "1",
      "ayahIndex": "2",
      "tokensCount": "4",
      "verse": "ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ",
      "aya": "الحمد لله رب العالمين",
      "translatedverse": "All praise and thanks are Allāh’s, the Lord(1) of the ʻĀlamīn (mankind, jinn and all that exists)",
      "audio": "-",
      "prize": "10",
      "complete": "0"
    },
    {
      "id": 3,
      "surahIndex": "1",
      "ayahIndex": "3",
      "tokensCount": "2",
      "verse": "ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
      "aya": "الرحمن الرحيم",
      "translatedverse": "The Most Gracious, the Most Merciful",
      "audio": "-",
      "prize": "10",
      "complete": "0"
    },
    {
      "id": 4,
      "surahIndex": "1",
      "ayahIndex": "4",
      "tokensCount": "3",
      "verse": "مَٰلِكِ يَوْمِ ٱلدِّينِ",
      "aya": "مالك يوم الدين",
      "translatedverse": "The Only Owner (and the Only Ruling Judge) of the Day of Recompense (i.e. the Day of Resurrection)",
      "audio": "-",
      "prize": "10",
      "complete": "0"
    },
    {
      "id": 5,
      "surahIndex": "1",
      "ayahIndex": "5",
      "tokensCount": "4",
      "verse": "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
      "aya": "إياك نعبد وإياك نستعين",
      "translatedverse": "You (Alone) we worship, and You (Alone) we ask for help (for each and every thing).",
      "audio": "-",
      "prize": "10",
      "complete": "0"
    },
    {
      "id": 6,
      "surahIndex": "1",
      "ayahIndex": "6",
      "tokensCount": "3",
      "verse": "ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ",
      "aya": "أحد الصراط المستقيم",
      "translatedverse": "Guide us to the Straight Way",
      "audio": "-",
      "prize": "10",
      "complete": "0"
    },
    {
      "id": 7,
      "surahIndex": "1",
      "ayahIndex": "7",
      "tokensCount": "9",
      "verse": "صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَاٱلضَّآلِّينَ",
      "aya": "صراط الذين أنعمت عليهم غير المغضوب عليهم ولاالضالين",
      "translatedverse": "The Way of those on whom You have bestowed Your Grace, not (the way) of those who earned Your Anger (i.e. those whose intentions are perverted: they know the Truth, yet do not follow it), nor of those who went astray (i.e. those who have lost the (true) knowledge, so they wander in error, and are not guided to the Truth)",
      "audio": "-",
      "prize": "10",
      "complete": "0"
    }
  ]};
  bool play = false;

  // Future<void> getAyat()async{
  //   HttpClient httpClient = new HttpClient();
  //   HttpClientRequest request = await httpClient.getUrl(Uri.parse("https://api.moshafkids.eqratech.com/quran/getAyat.php?surah=1&user=1"));
  //   request.headers.set('content-type', 'application/json');
  //   HttpClientResponse response = await request.close();
  //   String reply = await response.transform(utf8.decoder).join();
  //   print(reply);
  //   httpClient.close();
  //   Map<String, dynamic> mapResponse = json.decode(reply);
  //   return mapResponse;
  // }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mPlayer.openAudioSession();
    // String st1 = "بِسْمِِ";
    // RegExp r = RegExp("بِ");
    // print("Has Match ? : ${r.hasMatch(st1)}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("images/arabic.png"),
        //     fit: BoxFit.fill
        //   )
        // ),
        child: Column(
          children: [
            Container(height: MediaQuery.of(context).padding.top),
            SizedBox(height: 10,),
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 55,
                    alignment: Alignment.center,
                    child: Text(widget.dept,style: TextStyle(color:Color(0xff707070),fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    width: double.infinity,
                    height: 55,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen(2)));
                            },
                            child: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: 35,))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                            flex: 1,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20)),
                              ),
                              elevation: 7,
                              child: Container(
                                // height: 280,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            ayat['records'][index]['verse'],
                                            style: TextStyle(fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.purple),)),
                                    ),
                                    SizedBox(height: 10,),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        // alignment:Alignment.bottomCenter,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              SizedBox(width: 15,),
                                              InkWell(
                                                onTap: ()async{
                                                  setState(() {
                                                    index=0;
                                                    play=false;
                                                  });
                                                  await _mPlayer.stopPlayer();
                                                },
                                                  child: Image.asset("images/back.png")),
                                              SizedBox(width: 10,),
                                              InkWell(
                                                onTap: () async {
                                                    if(index!=0) {
                                                      await _mPlayer.stopPlayer();
                                                      setState(() {
                                                        index--;
                                                        play=false;
                                                      });
                                                    }
                                                },
                                                  child: Image.asset("images/back.png")),
                                              SizedBox(width: 10,),
                                              play?InkWell(
                                                onTap: () async {
                                                  await _mPlayer.pausePlayer();
                                                  setState(() {
                                                    play=false;
                                                  });
                                                },
                                                  child: Image.asset("images/play.png")
                                              ):InkWell(
                                                  onTap: () async {
                                                    await _mPlayer.startPlayer(
                                                      fromDataBuffer: (await rootBundle.load('assets/${index+1}.mp3'))
                                                          .buffer
                                                          .asUint8List(),
                                                      codec: Codec.mp3,
                                                      whenFinished: (){
                                                        setState(() {
                                                          play = false;
                                                        });
                                                      }
                                                    );
                                                    setState(() {
                                                      play=true;
                                                    });
                                                    // Timer(_duration,(){
                                                    //   if(play==true) {
                                                    //     setState(() {
                                                    //       play = false;
                                                    //     });
                                                    //   }
                                                    // });
                                                  },
                                                  child:SvgPicture.asset("images/pause.svg")
                                              ),
                                              SizedBox(width: 10,),
                                              InkWell(
                                                onTap: () async {
                                                    if(index!=6) {
                                                      await _mPlayer.stopPlayer();
                                                      setState(() {
                                                        index++;
                                                        play=false;
                                                      });
                                                    }
                                                },
                                                  child: Image.asset("images/forward.png")),
                                              SizedBox(width: 10,),
                                              InkWell(
                                                onTap: () async {
                                                  await _mPlayer.stopPlayer();
                                                  await _mPlayer.startPlayer(
                                                      fromDataBuffer: (await rootBundle.load('assets/${index+1}.mp3'))
                                                          .buffer
                                                          .asUint8List(),
                                                      codec: Codec.mp3,
                                                      whenFinished: (){
                                                        setState(() {
                                                          play = false;
                                                        });
                                                      }
                                                  );
                                                  setState(() {
                                                    play=true;
                                                  });
                                                },
                                                  child: Image.asset("images/replay.png")),
                                            ],
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ReadingScreen(widget.dept,deptId,index,ayat['records'][index]['aya'],ayat['records'][index]['verse'])));
                          },
                          child: Container(
                            height: 55,
                            margin: EdgeInsets.symmetric(horizontal: 65),
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
                            child: Text(tr("readNow"),style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [BottomNavigationBarItem(icon: Icon(Icons.settings),label: "الإعدادات",activeIcon: Icon(Icons.settings,color: Colors.purple,)),
          BottomNavigationBarItem(icon: Icon(Icons.error),label: "عن التطبيق",activeIcon: Icon(Icons.error,color: Colors.purple,)),
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "الرئيسية",activeIcon: Icon(Icons.home,color: Colors.purple,))],
        currentIndex: 2,
        iconSize: 28,
        onTap: (index){
          setState(() {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen(index)));
          });
        },
      ),
    );
  }
}
