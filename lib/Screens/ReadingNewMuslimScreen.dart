import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:file/local.dart';
import 'package:dio/dio.dart';
import 'package:fatha/Screens/ListningNewMuslimScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_sound/public/tau.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../LeftToRight.dart';
import 'HomeScreen.dart';
class ReadingNewMuslimScreen extends StatefulWidget {
  String dept,aya,verse,translatedverse;
  int index;
  LocalFileSystem localFileSystem = LocalFileSystem();

  ReadingNewMuslimScreen(this.dept,this.index,this.aya,this.verse,this.translatedverse);

  @override
  _ReadingNewMuslimScreenState createState() => _ReadingNewMuslimScreenState();
}

class _ReadingNewMuslimScreenState extends State<ReadingNewMuslimScreen> {
  bool _isRecording = false;
  Random random = new Random();
  List<Widget> wid;

  double x = 0 , y = 0;
  List<bool> matches = [];
  List<int> rightCounter = [];
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  File outputFile;
  int wordIndex=0;
  String translatedverse;
  List<String> verseWords = [];
  List<String> ayaWords = [];
  List<String> transVarse=[];
  String right="1";
  bool wordRight = true;
  bool proccesing = false;

  @override
  void initState() {
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    setState(() {
      verseWords=widget.verse.split(" ");
      ayaWords=widget.aya.split(" ");
      if(widget.index==0){
        translatedverse="In the Name of-Allāh-the Most Gracious-the Most Merciful";
      }else if(widget.index==1){
        translatedverse="Praise-be to God-Lord-of the Two Worlds";
      }else if(widget.index==2){
        translatedverse="Most Merciful-Most Compassionate";
      }else if(widget.index==3){
        translatedverse="King of-the Day-of Jurisprudence";
      }else if(widget.index==4){
        translatedverse="Beware of-worship-and Thine-aid we seek";
      }else if(widget.index==5){
        translatedverse="Guide us to-the Straight Way-the Straight Way";
      }else if(widget.index==6){
        translatedverse="The condition-of those-you have blessed-you have blessed-not against whom He is angry-not against whom He is angry-and not for the lost-";
      }
      transVarse=translatedverse.split("-");
    });
    // _mRecorder.openAudioSession().then((value) {
    //   setState(() {
    //     _mPlayerIsInited = true;
    //   });
    // });
    // openTheRecorder().then((value) {
    //   setState(() {
    //     _mRecorderIsInited = true;
    //   });
    // });
    _mPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
    _init();
    super.initState();
  }

  void play(file) async {
    // assert(_mPlayerIsInited &&
    //     _mplaybackReady &&
    //     _mRecorder.isStopped &&
    //     _mPlayer.isStopped);
    try {
      await _mPlayer.startPlayer(
          fromURI: _current.path,
          // codec: Codec.aacADTS,
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

  // Future<void> stopPlayer() async {
  //   await _mPlayer.stopPlayer();
  // }


  //
  // Future<void> openTheRecorder() async {
  //   var status = await Permission.microphone.request();
  //   if (status != PermissionStatus.granted) {
  //     throw RecordingPermissionException('Microphone permission not granted');
  //   }
  //
  //   var tempDir = await getApplicationDocumentsDirectory();
  //   _mPath = '${tempDir.path}/flutter_sound_example.wav';
  //   outputFile = File(_mPath);
  //   if (outputFile.existsSync()) {
  //     await outputFile.delete();
  //   }
  //   await _mRecorder.openAudioSession();
  //   _mRecorderIsInited = true;
  // }


  // Future<void> record() async {
  //   print("gggggggggggggggggggggg");
  //   assert(_mRecorderIsInited);
  //   await _mRecorder.startRecorder(
  //     toFile: _mPath,
  //     codec: Codec.pcm16WAV,
  //   );
  //   setState(() {});
  // }
  //
  // Future<void> stopRecorder(outputFile) async {
  //   print("fffffffffffffffffff");
  //   await _mRecorder.stopRecorder();
  //   _mplaybackReady = true;
  //   play(outputFile.path);
  //   PostRecordAudio(outputFile);
  // }
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
                      play(_current.path);
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(alignment:Alignment.center,child: Text(verseWords[wordIndex],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.purple),)),
                                    SizedBox(height: 10,),
                                    Text(transVarse[wordIndex],textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 13),)
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
                              child:GestureDetector(
                                  onLongPressEnd: (v){
                                    // stopRecorder(outputFile);
                                    setState(() {
                                      _isRecording = false;
                                      proccesing = true;
                                      _stop();
                                    });
                                  },
                                  onLongPress: ()async{
                                    if(!proccesing) {
                                      if (_isRecording) {
                                        // stopRecorder(outputFile);
                                        _stop();
                                        setState(() {
                                          _isRecording = false;
                                          proccesing = true;
                                        });
                                      } else {
                                        // record();
                                        _start();
                                        setState(() {
                                          _isRecording = true;
                                        });
                                      }
                                    }
                                  },
                                  onTap: () async {
                                    // await Permission.microphone.request().isGranted;
                                    // if (_isRecording) {
                                    //   _stop();
                                    // } else {
                                    //   _start();
                                    // }

                                  },
                                  child: Image.asset("images/mice.png",height: 110,width: 110,)
                              )
                          ),
                          _isRecording?Text(tr("recording")):proccesing?Center(child: CircularProgressIndicator(),):SizedBox(),
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
                        Text(tr("rightReading"),textAlign: TextAlign.center,style: GoogleFonts.elMessiri(textStyle:TextStyle(fontSize: 24,color: Color(0xff707070)),)),
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
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ListningNewMuslimScreen(widget.dept,widget.index+1)));
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
                              child: Text(tr("nextVerse"),style: GoogleFonts.elMessiri(textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
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
                              margin: EdgeInsets.symmetric(horizontal: 25),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(34)),
                                color: Color(0xffFED051),
                              ),
                              child: Text(tr("backHome"),style: GoogleFonts.elMessiri(textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
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
                            child: Text(tr("reReading"),style: GoogleFonts.elMessiri(textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 23),)),
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
                              child: Text(tr("nextWord"),style: GoogleFonts.elMessiri(textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
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

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        // showPermissonPopUp(context);
        await Permission.microphone.request();
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }
  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
    if (widget.localFileSystem.file(_current.path).lengthSync() > 20000)
    {
      PostRecordAudio(_current.path);
    }
    else
    {
      Fluttertoast.showToast(
          msg: tr("problem"),
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
      setState(() {
        proccesing=false;
      });
    }
  }


  Future<void> PostRecordAudio(String imageFile) async{
    print(imageFile);
    Dio dio = Dio();
    FormData formData;
    String fileName = imageFile
        .split('/')
        .last;
    formData = FormData.fromMap({
      "audio":
      await MultipartFile.fromFile(imageFile, filename: fileName),
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
        }else {
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
}
