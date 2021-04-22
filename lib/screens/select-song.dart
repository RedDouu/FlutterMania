import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:third_try/game/localfile/chartfile.dart';
import 'package:third_try/game/localfile/localfile-manager.dart';
import 'package:third_try/screens/game-play.dart';
import 'package:third_try/screens/main-menu.dart';

class SelectSong extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SelectSongState();
}

class SelectSongState extends State {

  Future<List<ChartFile>> getCharts() async {
    final LocalFileManager _localFileManager = new LocalFileManager();
    final List<ChartFile> _chartFileArr =
        await _localFileManager.readSongsFolders();
    if (_chartFileArr.isNotEmpty) {
    } else {
      print("can't read songs folder");
    }
    return _chartFileArr;
  }
  AudioPlayer audioPlayer = new AudioPlayer();
  String audioPlayCache;

  ChartSelectedNotifier _selectedChartFile =
      ChartSelectedNotifier(ChartFile(title: ''));

  @override
  Widget build(BuildContext context) {
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    return Scaffold(
      //TODO 过渡动画多来点！
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          //TODO 使用thumb nail展示选取界面的BGA,暂时好像不需要，总之能提高选歌界面的性能吧
          //TODO 记录上次选曲的所在位置，每次进入到选取界面总能回到该位置
          color: Colors.black,
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
                top: 0,
                child: ValueListenableBuilder(
                  valueListenable: _selectedChartFile,
                  builder: (context,ChartFile value,child){
                    if(value != null)
                      if(value.previewTime != null){
                        if(audioPlayCache != value.audioFilePath)
                      audioPlayer.play(value.audioFilePath, position: Duration(
                          milliseconds: value.previewTime.toInt()));
                          audioPlayCache = value.audioFilePath;
                    }return Container(width: 0,height: 0,);
                  },
                ),
            ),//歌曲预览
            Positioned(
              left: 0,
              right: 0,
              child: ValueListenableBuilder(
                  valueListenable: _selectedChartFile,
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        if (value != null)
                          if (value.backgroundImageFilePath != null)
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: new FileImage(
                                      File(value.backgroundImageFilePath)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: new BackdropFilter(
                                filter: new ImageFilter.blur(
                                    sigmaX: 10, sigmaY: 10),
                                child: new Container(
                                  decoration: new BoxDecoration(
                                      color: Colors.white.withOpacity(0)),
                                ),
                              ),
                            ),
                      ],
                    );
                  }),
            ),//选歌界面背景
            Positioned(
              child: IconButton(
                icon: Icon(Icons.arrow_back_sharp),
                iconSize: 30,
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainMenu())
                  );
                },
                color: Colors.white,
              ),
            ),
            Positioned(
              left: 15,
              top: 35,
              child: Stack(
                children: [
                  Text(
                    'Select Chart',
                    style: TextStyle(
                      fontFamily: 'MonNewZelek',
                      fontSize: 20,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 5
                        ..color = Colors.blue[200],
                    ),
                  ),
                  Text(
                    'Select Chart',
                    style: TextStyle(
                      fontFamily: 'MonNewZelek',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ), //选歌那几个字
            Positioned(
                left: 10,
                top: 60,
                child: FutureBuilder(
                  future: getCharts(),
                  builder: _songSelectBuildFuture,
                )), //歌曲列表
            Positioned(
              right: MediaQuery.of(context).size.width * 0.3 - 125,
              top: 35,
              child: Stack(
                children: [
                  Text(
                    'Chart Info',
                    style: TextStyle(
                      fontFamily: 'MonNewZelek',
                      fontSize: 20,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 5
                        ..color = Colors.blue[200],
                    ),
                  ),
                  Text(
                    'Chart Info',
                    style: TextStyle(
                      fontFamily: 'MonNewZelek',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ), //歌曲信息那几个字
            Positioned(
              right: 10,
              top: 60,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.62,
                          child: ValueListenableBuilder(
                              valueListenable: _selectedChartFile,
                              builder: (context, value, child) {
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //TODO 解决placeHolder
                                    if (value != null)
                                      if (value.backgroundImageFilePath != null)
                                        Image.file(
                                          File(value.backgroundImageFilePath),
                                          fit: BoxFit.fill,
                                        ),
                                    Text('${value.title}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text('Artist: ${value.artist}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    Text('Creator: ${value.creator}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    Text('Version:${value.version}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    if (value.hitObjects != null)
                                      Text('Objects:${value.hitObjects.length}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                  ],
                                );
                              }),
                        ),
                      ),
                      ValueListenableBuilder(
                          valueListenable: _selectedChartFile,
                          builder: (context, ChartFile value, child) {
                            return Column(children: [
                              if (value != null && value.hitObjects!=null)
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GamePlay(chartFile: value,))
                                    );
                                    audioPlayer.stop();
                                  },
                                  child: Text(
                                    "START",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 24,
                                        fontFamily: 'MonNewZelek'),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue[900].withOpacity(0.5)),
                                    minimumSize: MaterialStateProperty.all(Size(
                                        MediaQuery.of(context).size.width * 0.3,
                                        50)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    side: MaterialStateProperty.all(
                                      BorderSide.lerp(
                                          BorderSide(
                                            style: BorderStyle.solid,
                                            color: Colors.lightBlueAccent,
                                            width: 2,
                                          ),
                                          BorderSide(
                                            style: BorderStyle.solid,
                                            color: Colors.lightBlueAccent,
                                            width: 2,
                                          ),
                                          50),
                                    ),
                                  ),
                                ),
                            ]);
                          }),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _songSelectBuildFuture(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasData) {
        List<ChartFile> _chartFileArr = snapshot.data;
        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Scrollbar(
              child: ListView(
                children: [
                  for (var value in _chartFileArr)
                    GestureDetector(
                      onTap: () {
                        _selectedChartFile.changeSelectedChart(value);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 5, left: 2, right: 2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                              color: Colors.lightBlueAccent, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          leading: ExcludeSemantics(
                            child: Image.file(
                              File(value.backgroundImageFilePath),
                              fit: BoxFit.fill,
                            ),
                          ),
                          title: Text(
                            '${value.artist} - ${value.title}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            '${value.creator} - ${value.version}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }
      return Text(
        'local chart file reading ERROR\nMaybe there is no charts?\nOr some of charts are unreadable',
        style: TextStyle(color: Colors.white),
      );
    }
    return Text('Reading local File', style: TextStyle(color: Colors.white));
  }
}

class ChartSelectedNotifier extends ValueNotifier<ChartFile> {
  ChartSelectedNotifier(ChartFile value) : super(value);

  void changeSelectedChart(ChartFile _chartFile) {
    value = _chartFile;
    notifyListeners();
  }
}
