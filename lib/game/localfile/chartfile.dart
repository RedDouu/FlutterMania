import 'package:third_try/game/chart.dart';

class ChartFile {
  //CircleSize for keyCount
  //Mode:3 for mania chart

  //General
  String audioFilePath;
  String backgroundImageFilePath;
  double previewTime;
  //MetaData
  String title,titleUnicode,artist,artistUnicode;
  String creator,version;
  String chartID,chartSetID;
  //Background
  double baseLine;//first TimingPoint
  double bpm;

  List<HitObject> hitObjects;

  ChartFile({this.title,this.artist,this.version});

  Map<String,dynamic> _map() {
    return {
      'title':title,
      'artist':artist,
      'creator':creator,
      'version':version,
      'chartID':chartID,
      'chartSetID':chartSetID,
      'baseLine':baseLine,
      'backgroundImageFilePath':backgroundImageFilePath,
      'audioFilePath':audioFilePath,
      'bpm':bpm,
      'hitObject':hitObjects
    };
  }
  dynamic get(String propertyName) {
    var _mapRep = _map();
    if(_mapRep.containsKey(propertyName)){
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}

class ChartFolder{
  List<ChartFile> chartFiles;
  ChartFolder({this.chartFiles}){
    this.chartFiles = chartFiles;
  }
}

class HitObject{
  double position,endPosition;
  String roll;
  HitObject({this.position,this.endPosition,this.roll});
  Map<String,dynamic> _map(){
    return {
      "position":position,
      "endPosition":endPosition,
      "roll":roll,
    };
  }
  dynamic get(String propertyName){
    var _mapRep = _map();
    if(_mapRep.containsKey(propertyName)){
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}