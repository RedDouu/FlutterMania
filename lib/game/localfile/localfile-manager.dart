import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:third_try/game/localfile/chartfile.dart';
import 'package:path/path.dart' as p;

class LocalFileManager {

  Future<String> get _localPath async {
    final dir = await getExternalStorageDirectory();
    //print(dir.path);
    return dir.path;
  }

  Future<Directory> get _songsDirectory async {
    final path = await _localPath;
    return Directory("$path/songs");
  }

  Future<Directory> createSongsFolder() async {
    final dir = await _songsDirectory;
    return Directory(dir.path).create(recursive: true);
  }

  Future<List<ChartFile>> readSongsFolders() async {

    List<ChartFile> _chartFileArr = [];

    final dir = await _songsDirectory;

    _chartFileArr = await readChart(dir);

    return _chartFileArr;
  }




  Future<List<ChartFile>> readChart(Directory dir) async {
    List<ChartFile> _chartFileArr = [];
    //print(dir.path);
    await for (var entity in dir.list(recursive: true, followLinks: true)) {
      //print("file detected: ${entity.path}");
      if (p.extension(entity.path) == '.osu' && !(entity is Directory)) {
        bool isMania = false;
        bool is4k = false;
        bool isReadingTimingPoints = false;
        bool isReadingHitObject = false;
        bool isReadingEvents = false;
        ChartFile _chartFile = new ChartFile();
        //print("osu file detected");
        File file = File(entity.path);
        List<String> lines = file.readAsLinesSync();
        List<HitObject> _hitObjects = [];

        for (var line in lines) {
          if(line.contains("AudioFilename: ")){
            var arr = line.split(':');
            _chartFile.audioFilePath = "${entity.parent.path}/${arr[arr.length-1].trimLeft()}";
          }
          if(line.contains("PreviewTime: ")){
            var arr = line.split(':');
            _chartFile.previewTime = double.parse(arr[arr.length - 1]);
          }
          if (line.contains("Title:")) {
            var arr = line.split(':');
            _chartFile.title = arr[arr.length - 1];
            //print("got title:${_chartFile.title}");
          }
          if (line.contains("Artist:")) {
            var arr = line.split(':');
            _chartFile.artist = arr[arr.length - 1];
            //print("got artist:${chartFile.artist}");
          }
          if (line.contains("Creator:")) {
            var arr = line.split(':');
            _chartFile.creator = arr[arr.length - 1];
            //print("got artist:${chartFile.artist}");
          }
          if (line.contains("Version:")) {
            var arr = line.split(':');
            _chartFile.version = arr[arr.length - 1];
            //print("got version:${chartFile.version}");
          }
          if (line.contains("BeatmapID:")) {
            var arr = line.split(':');
            _chartFile.chartID = arr[arr.length - 1];
            //print("got version:${chartFile.version}");
          }
          if (line.contains("BeatmapSetID:")) {
            var arr = line.split(':');
            _chartFile.chartSetID = arr[arr.length - 1];
            //print("got version:${chartFile.version}");
          }

          if (line.contains("Mode: 3")) {
            isMania = true;
          }
          if(line.contains("Mode: 1")||line.contains("Mode: 2")||line.contains("Mode: 4")){
            isMania = false;
          }

          for(int i=0;i<100;i++){
            if (line.contains("CircleSize:$i")){
              is4k = false;
            }
          }
          if (line.contains("CircleSize:4")) {
            is4k = true;
          }

          if (isMania == true && is4k == true) {
            //print("4kMania chart detected");
            if (line.contains("[TimingPoints]")) {
              isReadingTimingPoints = true;
            }
            if (line.contains("[HitObjects]")) {
              isReadingHitObject = true;
            }
            if (line.contains("[Events]")) {
              isReadingEvents = true;
            }
            if (line.isEmpty || line.contains("osu file format")) {
              isReadingTimingPoints = false;
              isReadingHitObject = false;
              isReadingEvents = false;
            }
            if (isReadingTimingPoints &&
                line.contains("[TimingPoints]") == false) {
              var arr = line.split(",");
              //print(arr[0]);//baseline
              //print(arr[1]);//bpm
              _chartFile.baseLine = double.parse(arr[0]);
              _chartFile.bpm = 60000 / double.parse(arr[1]);
              isReadingTimingPoints = false;
            }
            if (isReadingHitObject &&
                line.contains("[HitObjects]") == false) {
              var arr = line.split(",");
              //print(arr);
              //TODO 在未来的某一天会回来读取按键音
              var cache5 = arr[5].split(':');
              var position = double.parse(arr[2]);
              var endPosition = double.parse(cache5[0]);
              var roll;
              switch (arr[0]) {
                case "64":
                  {
                    roll = "A";
                    break;
                  }
                case "192":
                  {
                    roll = "B";
                    break;
                  }
                case "320":
                  {
                    roll = "C";
                    break;
                  }
                case "448":
                  {
                    roll = "D";
                    break;
                  }
              }
              //print("$position,$roll,$endPosition");
              HitObject hitObject =
              new HitObject(position: position, roll: roll,endPosition: endPosition);
              _hitObjects.add(hitObject);
            }
            if (isReadingEvents &&
                line.contains("[Events]") == false &&
                line.contains("//") == false &&
                line.contains("Video") == false &&
                line.contains("Sample") == false
            ) {
              var arr = line.split('"');
              //print(arr);
              //print("${entity.parent.path}/${arr[1].toString()}");
              if(arr[0] == "0,0,")
              _chartFile.backgroundImageFilePath = "${entity.parent.path}/${arr[1]}";
            }
          }
        }
        if(is4k && isMania) {
          _chartFile.hitObjects = _hitObjects;
          _chartFileArr.add(_chartFile);
          //print("chart file read and added to File array");
        }
      }
    }
    //print("for each");
    return _chartFileArr;
  }
}
