import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../LeftToRight.dart';
import 'HomeScreen.dart';
import 'ListningScreen.dart';

class ReadingScreen extends StatefulWidget {
  String dept,aya,verse;
  int index,deptId;

  ReadingScreen(this.dept,this.deptId,this.index,this.aya,this.verse);
  // final LocalFileSystem localFileSystem=LocalFileSystem();


  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  // Recording _recording = new Recording();
  bool _isRecording = false;
  Random random = new Random();
  List<bool> matches = [];
  List<int> rightCounter = [];
  double x = 0 , y = 0;
  List<String> verseWords = [];
  List<String> ayaWords = [];
  int wordIndex=0;
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  String _mPath;
  File outputFile;

  String right="1";

  bool proccesing = false;
  bool wordRight = true;

  @override
  void initState() {
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    setState(() {
      verseWords=widget.verse.split(" ");
      ayaWords=widget.aya.split(" ");
    });
    _mRecorder.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    _mPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
    super.initState();
  }

  void play(file) async {
    // assert(_mPlayerIsInited &&
    //     _mplaybackReady &&
    //     _mRecorder.isStopped &&
    //     _mPlayer.isStopped);
    try {
      await _mPlayer.startPlayer(
          fromURI: file,
//           codec: Codec.pcm16WAV,
          whenFinished: () {
            setState(() {});
          });
    }catch(e){
      Fluttertoast.showToast(
          msg: tr("problem"),
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
    }
    setState(() {});
  }
  
  Future<void> stopPlayer() async {
    await _mPlayer.stopPlayer();
  }

  Future<void> openTheRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    var status2 = await Permission.storage.request();
    if (status2 != PermissionStatus.granted) {
      throw RecordingPermissionException('Storage permission not granted');
    }
    Directory tempDir = await getTemporaryDirectory();
    _mPath = '${tempDir.path}/flutter_sound_example.mp3';
    if (File(_mPath).existsSync()) {
      await outputFile.delete();
    }
    outputFile = File(_mPath);
    outputFile.openWrite();
    await _mRecorder.openAudioSession();
    _mRecorderIsInited = true;
  }


  Future<void> record() async {
    print("gggggggggggggggggggggg");
    assert(_mRecorderIsInited);
    await _mRecorder.startRecorder(
      toFile: _mPath,
      codec: Codec.mp3,
    );
    setState(() {});
  }

  Future<void> stopRecorder(outputFile) async {
    print("fffffffffffffffffff");
    await _mRecorder.stopRecorder();
    _mplaybackReady = true;
    print(_mPath);
    print(outputFile.path);
    play(outputFile.path);
    PostRecordAudio(outputFile);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen(2)));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        // ),
        body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("images/arabic.png"),
          //     fit: BoxFit.fill
          //   )
          // ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
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
                  InkWell(
                    onTap: (){
                        play(_mPath);
                    },
                      child: Icon(Icons.play_circle_outline,size: 35,),),
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
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              elevation: 7,
                              child: Container(
                                height: 280,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(alignment:Alignment.center,child: Text(widget.deptId==0?verseWords[wordIndex]:widget.verse,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.purple),)),
                                    ),
                                    SizedBox(height: 10,),
                                    // Expanded(
                                    //   flex: 1,
                                    //   child: Container(
                                    //     // alignment:Alignment.bottomCenter,
                                    //       child: Row(
                                    //         mainAxisAlignment: MainAxisAlignment.center,
                                    //         children: [
                                    //           SizedBox(width: 15,),
                                    //           Image.asset("images/back.png"),
                                    //           SizedBox(width: 10,),
                                    //           Image.asset("images/play.png"),
                                    //           SizedBox(width: 10,),
                                    //           Image.asset("images/forward.png"),
                                    //           SizedBox(width: 10,),
                                    //           Image.asset("images/replay.png"),
                                    //         ],
                                    //       )
                                    //   ),
                                    // ),
                                    // Expanded(
                                    //   flex: 1,
                                    //   child: Container(alignment:Alignment.topRight,child: Text("الْحَمَ",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.purple),)),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child:InkWell(
                              onTap: () async {
                                // await Permission.microphone.request().isGranted;
                                  // if (_isRecording) {
                                  //   _stop();
                                  // } else {
                                  //   _start();
                                  // }
                                if(!proccesing) {
                                  if (_isRecording) {
                                    stopRecorder(outputFile);
                                    setState(() {
                                      _isRecording = false;
                                      proccesing = true;
                                    });
                                  } else {
                                    record();
                                    setState(() {
                                      _isRecording = true;
                                    });
                                  }
                                }
                              },
                                child: Image.asset("images/mice.png",height: 110,width: 110,)
                            )
                          ),
                          _isRecording?Text(tr("recording")):proccesing?Text(tr("processing")):SizedBox(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaY: x,
                  sigmaX: y,
                ),
                child: y==5?Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white.withOpacity(0),
                ):SizedBox(),
              ),
              right=="1"&&x==5&&widget.index!=6?Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  elevation: 10,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        SizedBox(height: 45,),
                        Text(tr("good"),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,style: GoogleFonts.elMessiri(textStyle:TextStyle(fontSize: 34,color: Color(0xff707070),fontWeight: FontWeight.bold),)),
                        SizedBox(height: 25,),
                        Text(tr("rightReading"),textAlign: TextAlign.center,style: GoogleFonts.elMessiri(textStyle:TextStyle(fontSize: 25,color: Color(0xff707070)),)),
                        SizedBox(height: 30,),
                        Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                x=0;
                                y=0;
                              });
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ListningScreen(widget.dept,widget.index+1,widget.deptId)));
                            },
                            child: Container(
                              height: 55,
                              margin: EdgeInsets.symmetric(horizontal: 25),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(34)),
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
                              child: Text("الاية التالية",style: GoogleFonts.elMessiri(textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 23),)),
                            ),
                          ),
                        ),
                        SizedBox(height: 45,),
                      ],
                    ),
                  ),
                ),
              ):right=="0"&&x==5?Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  elevation: 10,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        SizedBox(height: 45,),
                        Text(tr("wrong"),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,style: GoogleFonts.elMessiri(textStyle:TextStyle(fontSize: 34,color: Color(0xff707070),fontWeight: FontWeight.bold),)),
                        SizedBox(height: 30,),
                        Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                x=0;
                                y=0;
                                wordIndex=0;
                                matches.clear();
                                rightCounter.clear();
                              });
                            },
                            child: Container(
                              height: 55,
                              margin: EdgeInsets.symmetric(horizontal: 25),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(34)),
                                color: Color(0xffFF5F5F),
                              ),
                              child: Text(tr("reReading"),style: GoogleFonts.elMessiri(textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                            ),
                          ),
                        ),
                        SizedBox(height: 45,),
                      ],
                    ),
                  ),
                ),
              ):right=="1"&&widget.index==6&&x==5?Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  elevation: 10,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        SizedBox(height: 45,),
                        Text(tr("finish"),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,style: GoogleFonts.elMessiri(textStyle:TextStyle(fontSize: 34,color: Color(0xff707070),fontWeight: FontWeight.bold),)),
                        SizedBox(height: 30,),
                        Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                x=0;
                                y=0;
                              });
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen(2)));
                            },
                            child: Container(
                              height: 55,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(34)),
                                color: Color(0xffFED051),
                              ),
                              child: Text(tr("backHome"),style: GoogleFonts.elMessiri(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                            ),
                          ),
                        ),
                        SizedBox(height: 45,),
                      ],
                    ),
                  ),
                ),
              ):!wordRight && x==5?Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  elevation: 10,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        SizedBox(height: 45,),
                        Text(tr("wrongWord"),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,style: GoogleFonts.elMessiri(textStyle:TextStyle(fontSize: 34,color: Color(0xff707070),fontWeight: FontWeight.bold),)),
                        SizedBox(height: 20,),
                        InkWell(
                          onTap: (){
                            setState(() {
                              x=0;
                              y=0;
                            });
                          },
                          child: Container(
                            height: 55,
                            margin: EdgeInsets.symmetric(horizontal: 25),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(34)),
                              color: Color(0xffFF5F5F),
                            ),
                            child: Text(tr("reReading"),style: GoogleFonts.elMessiri(textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                wordIndex++;
                                x=0;
                                y=0;
                              });
                            },
                            child: Container(
                              height: 55,
                              margin: EdgeInsets.symmetric(horizontal: 25),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(34)),
                                color: Color(0xffFED051),
                              ),
                              child: Text(tr("nextWord"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "ElMessiri",fontSize: 23),),
                            ),
                          ),
                        ),
                        SizedBox(height: 45,),
                      ],
                    ),
                  ),
                ),
              ):SizedBox(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [BottomNavigationBarItem(icon: Icon(Icons.settings),label: tr("setting"),activeIcon: Icon(Icons.settings,color: Colors.purple,)),
            BottomNavigationBarItem(icon: Icon(Icons.error),label: tr("about"),activeIcon: Icon(Icons.error,color: Colors.purple,)),
            BottomNavigationBarItem(icon: Icon(Icons.home),label: tr("home"),activeIcon: Icon(Icons.home,color: Colors.purple,))],
          currentIndex: 2,
          iconSize: 28,
          onTap: (index){
            setState(() {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen(index)));
            });
          },
        ),
      ),
    );
  }
  // _start() async {
  //   try {
  //           var appDocDirectory =
  //           await getApplicationDocumentsDirectory();
  //           String path = appDocDirectory.path + '/' + "record${random.nextInt(999999)}";
  //
  //         print("Start recording: $path");
  //         await AudioRecorder.start(
  //             path: path, audioOutputFormat: AudioOutputFormat.WAV);
  //
  //       bool isRecording = await AudioRecorder.isRecording;
  //       setState(() {
  //         _recording = new Recording(duration: new Duration(), path: "");
  //         _isRecording = isRecording;
  //       });
  //
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // _stop() async {
  //   var recording = await AudioRecorder.stop();
  //   print("Stop recording: ${recording.path}");
  //   bool isRecording = await AudioRecorder.isRecording;
  //   // File file = widget.localFileSystem.file(recording.path);
  //   File file = File(recording.path);
  //   await audioPlayer.play(file.path, isLocal: true);
  //   print("  File length: ${await file.length()}");
  //   setState(() {
  //     _recording = recording;
  //     _isRecording = isRecording;
  //   });
  //   PostRecordAudio(file);
  // }

  Future<void> PostRecordAudio(File imageFile) async{
    print("kkkkkkkkkkk");
    print(imageFile.path);
    Dio dio = Dio();
    FormData formData;
      String fileName = imageFile.path
          .split('/')
          .last;
      formData = FormData.fromMap({
        "audio":
        await MultipartFile.fromFile(imageFile.path, filename: fileName),
        });

    var data;

    await dio.post("http://deep.eqratech.com:3001/api/v1/getVoice",
        data: formData,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          },
        ))
        .then((response) {
      data = response.data;
      print(data);
    });

    // _showDialog();
    if(data['data']!=null) {
      String st1 = data['data'];
      if(widget.deptId==1) {
        List<String> dataList = st1.split(" ");
        List<String> ayaList = widget.aya.split(" ");
        int length;
        List<bool> matches = [];
        List<int> rightCounter = [];
        if (ayaList.length > dataList.length) {
          length = dataList.length;
        } else {
          length = ayaList.length;
        }
        for (int i = 0; i < length; i++) {
          // RegExp r = RegExp(ayaList[i]);
          // matches.add(r.hasMatch(st1[i]));
          if (dataList[i].contains(ayaList[i])) {
            rightCounter.add(i);
          }
          matches.add(dataList[i].contains(ayaList[i]));
        }
        print(matches);
        if (rightCounter.length >= length / 2) {
          setState(() {
            right = "1";
            x=5;
            y=5;
          });
        } else {
          setState(() {
            right = "0";
            x=5;
            y=5;
          });
        }
      }else{
        if(st1.contains(ayaWords[wordIndex])){
          rightCounter.add(wordIndex);
        }

        print(matches);
        if(wordIndex==ayaWords.length-1) {
          if (rightCounter.length >= ayaWords.length / 2) {
            setState(() {
              right = "1";
              x=5;
              y=5;
            });
          } else {
            setState(() {
              right = "0";
              x=5;
              y=5;
            });
          }
        }else{
          if(st1.contains(ayaWords[wordIndex])){
            setState(() {
              wordRight = true;
              x=0;
              y=0;
              matches.add(st1.contains(ayaWords[wordIndex]));
              wordIndex++;
            });
          }else{
            setState(() {
              wordRight = false;
              right="2";
              x=5;
              y=5;
            });
          }
        }
      }
    }else{
      print("أعد قراءة الاية");
      setState(() {
        right = "0";
      });
      Fluttertoast.showToast(
          msg: tr("problem"),
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
    }
    setState(() {
      proccesing = false;
    });
    // print("Has Match ? : ${r.hasMatch(st1)}");
  }

  // Future<void> _showDialog(){
  //   return showDialog(context: context, builder: (BuildContext) {
  //     return AlertDialog(
  //       backgroundColor: Color(0xffF5F5F5),
  //       title: Column(
  //         children: [
  //           SizedBox(height: 25,),
  //           Text("احسنت !",
  //             textDirection: TextDirection.rtl,
  //             textAlign: TextAlign.center,style: TextStyle(fontFamily: "ElMessiri",fontSize: 39,color: Color(0xff707070)),),
  //         ],
  //       ),
  //       content: SingleChildScrollView(
  //         child: ListBody(
  //           children: <Widget>[
  //             Text("قراءة صحيحة",textAlign: TextAlign.center,style: TextStyle(fontFamily: "ElMessiri",fontSize: 29,color: Color(0xff707070)),),
  //         SizedBox(height: 30,),
  //         Container(
  //           alignment: Alignment.center,
  //           child: InkWell(
  //             onTap: (){
  //               setState(() {
  //                 x=0;
  //                 y=0;
  //               });
  //               Navigator.pop(context);
  //               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ListningScreen(widget.dept,widget.index+1)));
  //             },
  //             child: Container(
  //               height: 55,
  //               margin: EdgeInsets.symmetric(horizontal: 20),
  //               alignment: Alignment.center,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.all(Radius.circular(34)),
  //                 gradient: LinearGradient(
  //                   // stops: [
  //                   //   0.7,
  //                   //   0.3,
  //                   // ],
  //                   begin: Alignment.centerLeft,
  //                   end: Alignment.centerRight,
  //                   colors: [Color(0xffAF1FAA),Color(0xff9318D1)],
  //                 ),
  //               ),
  //               child: Text("الاية التالية",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "ElMessiri",fontSize: 23),),
  //             ),
  //           ),
  //           ),
  //             SizedBox(height: 30,),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }


  @override
  void dispose() {
    stopPlayer();
    _mPlayer.closeAudioSession();
    _mPlayer = null;

    _mRecorder.closeAudioSession();
    _mRecorder = null;
    if (_mPath != null) {
      var outputFile = File(_mPath);
      if (outputFile.existsSync()) {
        outputFile.delete();
      }
    }
    super.dispose();
  }
}
