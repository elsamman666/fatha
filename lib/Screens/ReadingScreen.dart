import 'dart:async';
import 'dart:io';
import 'package:fatha/initSpeech.dart';
import 'package:file/local.dart';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_deepspeech/flutter_deepspeech.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path/path.dart' as Path;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import '../lang.dart';
import 'HomeScreen.dart';
import 'ListningScreen.dart';

class ReadingScreen extends StatefulWidget {
  String dept,aya,verse;
  int index,deptId;
  LocalFileSystem localFileSystem = LocalFileSystem();



  ReadingScreen(this.dept,this.deptId,this.index,this.aya,this.verse);
  // final LocalFileSystem localFileSystem=LocalFileSystem();


  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  // Recording _recording = new Recording();
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool _isRecording = false;
  Random random = new Random();
  List<bool> matches = [];
  List<int> rightCounter = [];
  double x = 0 , y = 0;
  List<String> verseWords = [];
  List<String> ayaWords = [];
  int wordIndex=0;
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  String _mPath;
  File outputFile;

  String right="1";

  bool proccesing = false;
  bool wordRight = true;
  String recognizedText = '';
  bool initialized = false;
  bool recognizing = false;

  Database db;

  List<Map<String, dynamic>> databaseResult;
  List<String> ayatAsWords;
  String finalResult = " ";
  String orginal = "";

  StreamSubscription partialResultsSubscription;



  @override
  void initState() {
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    initdatabse();
    setState(() {
      verseWords=widget.verse.split(" ");
      ayaWords=widget.aya.split(" ");
    });
    _mPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
    _init();
    initDeepSpeech().then((value) {
      setState(() {
        initialized = true;
      });
      partialResultsSubscription =
          FlutterDeepSpeech.partialResults.listen((event) {
            setState(() {
              recognizedText = event;
            });
          });
    });
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    partialResultsSubscription?.cancel();
  }

  Future<void> buttonHandler() async {
    // if (!recognizing){
      await FlutterDeepSpeech.start();
      setState(() {
        recognizedText = "";
      });
    // } else {

    // }
    // setState(() {
      // recognizing = !recognizing;
    // });
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
          msg: problem,
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child:GestureDetector(
                              onLongPressEnd: (v) async {
                                // stopRecorder(outputFile);
                                final finalResult = await FlutterDeepSpeech.finish();
                                print("Final result: $finalResult");
                                setState(() {
                                  recognizedText = finalResult;
                                });
                                setState(() {
                                  _isRecording = false;
                                  // proccesing = true;
                                  _search(recognizedText);
                                });
                              },
                              onLongPress: ()async{
                                if(!proccesing) {
                                  if (_isRecording) {
                                    // stopRecorder(outputFile);
                                    _stop();
                                    setState(() {
                                      _isRecording = false;
                                      // proccesing = true;
                                    });
                                  } else {
                                    // record();
                                    _start();
                                    buttonHandler();
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
                          _isRecording?Text(recording):proccesing?Center(child: CircularProgressIndicator(),):SizedBox(),
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
              right=="1"&&x==5&&widget.index!=7?Padding(
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
                        Text(good,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,style: GoogleFonts.elMessiri(textStyle:TextStyle(fontSize: 34,color: Color(0xff707070),fontWeight: FontWeight.bold),)),
                        SizedBox(height: 25,),
                        Text(rightReading,textAlign: TextAlign.center,style: GoogleFonts.elMessiri(textStyle:TextStyle(fontSize: 25,color: Color(0xff707070)),)),
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
                        Text(wrong,
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
                              child: Text(reReading,style: GoogleFonts.elMessiri(textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                            ),
                          ),
                        ),
                        SizedBox(height: 45,),
                      ],
                    ),
                  ),
                ),
              ):right=="1"&&widget.index==7&&x==5?Padding(
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
                        Text(finish,
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
                              child: Text(backHome,style: GoogleFonts.elMessiri(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
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
                        Text(wrongWord,
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
                            child: Text(reReading,style: GoogleFonts.elMessiri(textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
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
                              child: Text(nextWord,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "ElMessiri",fontSize: 23),),
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
          items: [BottomNavigationBarItem(icon: Icon(Icons.settings),label: setting,activeIcon: Icon(Icons.settings,color: Colors.purple,)),
            BottomNavigationBarItem(icon: Icon(Icons.error),label: about,activeIcon: Icon(Icons.error,color: Colors.purple,)),
            BottomNavigationBarItem(icon: Icon(Icons.home),label: home,activeIcon: Icon(Icons.home,color: Colors.purple,))],
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
          msg: problem,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2
      );
      setState(() {
        proccesing=false;
      });
    }

  }



  initdatabse() async {
    var databasesPath = await getDatabasesPath();
    var path = Path.join(databasesPath, "dic.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(Path.dirname(path)).create(recursive: true);
      } catch (_) {
        print("EErrors");
      }
      print("finish copy database");

      // Copy from asset
      ByteData data = await rootBundle.load(Path.join("assets", "dic.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    initialized = true;

// open the database
    db = await openDatabase(path, readOnly: true);
  }


  _search(String ayah) async {
    finalResult = "";
    print("ppppppppppppppppppppppppppp$ayah");
    Fluttertoast.showToast(
        msg: ayah,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2
    );

    ayatAsWords = null;

    if (!initialized) await initdatabse();

    ayatAsWords = ayah.split(' ');

    for (var i = 0; i < ayatAsWords.length; i++) {
      // print (arr[i]);
      String tempword = ayatAsWords[i];
      String query =
      '''   SELECT * FROM dictionary WHERE arabicPronounc = '$tempword';    ''';
      databaseResult = await this.db.rawQuery(query);
      if (databaseResult.length >= 1) {
        Map<String, dynamic> singleresult = databaseResult.first;
        finalResult = finalResult + " " + singleresult['arabicToken'];
      } else {
        print("unknown word: $tempword");
      }
    }
    _stop();
  }


  Future<void> PostRecordAudio(String imageFile) async{
    // print(imageFile);
    // Dio dio = Dio();
    // FormData formData;
    //   String fileName = imageFile
    //       .split('/')
    //       .last;
    //   formData = FormData.fromMap({
    //     "audio":
    //     await MultipartFile.fromFile(imageFile, filename: fileName),
    //     });
    //
    // var data;
    //
    // await dio.post("http://deep.eqratech.com:3001/api/v1/getVoice",
    //     data: formData,
    //     options: Options(
    //       followRedirects: false,
    //       validateStatus: (status) {
    //         return status < 500;
    //       },
    //     ))
    //     .then((response) {
    //   data = response.data;
    //   print(data['data']);
    //
    // });

    // _showDialog();
    if(finalResult!="") {
      Fluttertoast.showToast(
          msg: finalResult,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3
      );
      String st1 = finalResult;

      if(widget.deptId==1) {
        List<String> dataList = st1.split(" ");
        dataList.removeAt(0);
        List<String> ayaList = widget.aya.split(" ");
        List<bool> matches = [];
        List<int> rightCounter = [];
        print("rrrrrrrrrrrrrrrrrrrrrr$st1");
        print(dataList);
        print(ayaList);
        for (int i = 0; i < ayaList.length; i++) {
          // RegExp r = RegExp(ayaList[i]);
          // matches.add(r.hasMatch(st1[i]));
          if(dataList.length-1>=i) {
            if (dataList[i].contains(ayaList[i])) {
              // Fluttertoast.showToast(
              //     msg: tr("rightReading"),
              //     gravity: ToastGravity.BOTTOM,
              //     toastLength: Toast.LENGTH_LONG,
              //     timeInSecForIosWeb: 3
              // );
              rightCounter.add(i);
            }
            matches.add(dataList[i].contains(ayaList[i]));
            print(dataList[i]);
            print(ayaList[i]);
            print(ayaList[i].contains(dataList[i]));

          }else{
            matches.add(false);
          }
        }
        print(matches);
        if (rightCounter.length >= ayaList.length / 2) {
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
          Fluttertoast.showToast(
              msg: rightReading,
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3
          );
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
          msg: problem,
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

}
