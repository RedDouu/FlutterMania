import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:third_try/game/background.dart';
import 'package:third_try/game/localfile/chartfile.dart';
import 'package:third_try/game/note.dart';
import 'package:third_try/game/stage/mania-key.dart';
import 'package:third_try/game/stage/mania-stage-background.dart';
import 'package:third_try/game/stage/mania-stage-config.dart';
import 'package:third_try/game/stage/mania-stage-hint.dart';
import 'package:third_try/game/stage/mania-stage-left.dart';
import 'package:third_try/game/stage/mania-stage-light.dart';
import 'package:third_try/game/stage/mania-stage-right.dart';
import 'package:third_try/widgets/hud.dart';
import 'package:third_try/widgets/pause-menu.dart';
import 'package:flame/time.dart';
import 'package:third_try/widgets/touch-to-start.dart';

class ManiaGame extends BaseGame with HasWidgetsOverlay {
  //TODO 就问你敢不敢做变速
  ManiaStageConfig _maniaStageConfig;
  double _judgLineHeight;
  double _visualCalibration; //ms
  ManiaKey _maniaKeyA, _maniaKeyB, _maniaKeyC, _maniaKeyD;
  Background _bg;
  ManiaStageLeft _maniaStageLeft;
  ManiaStageRight _maniaStageRight;
  ManiaStageHint _maniaStageHint;
  ManiaStageBackground _maniaStageBackground;
  ManiaStageLight _maniaStageLightA,
      _maniaStageLightB,
      _maniaStageLightC,
      _maniaStageLightD;
  double _maniaStageBackgroundOpacity;
  double _maniaStageOffset;
  //Chart _chart;
  double bpm;
  double sectionLength;
  double _basicScrollingSpeed;
  double _bgOpacity;

  final ChartFile chartFile;

  List<NoteA> noteAs = [];
  List<NoteB> noteBs = [];
  List<NoteC> noteCs = [];
  List<NoteD> noteDs = [];
  List<LongNoteA> noteLAs = [];
  List<LongNoteB> noteLBs = [];
  List<LongNoteC> noteLCs = [];
  List<LongNoteD> noteLDs = [];

  AudioPlayer audioPlayer = new AudioPlayer();
  double songDuration;
  double songPositionValue = 0;
  double noteRenderPosition;
  bool audioPlayed = false;

  Timer msTimer;
  TextComponent _msTimer;
  TextComponent _fpsCounter;

  Size screenSize;

  bool started = false;

  //判定相关;
  int criticalPerfectCount,perfectCount,goodCount,missCount;
  TextComponent judgCount;

  ManiaGame({@required this.chartFile}){

    screenSize = new Size(1,1);

    songDuration = chartFile.hitObjects.last.position;
    //TODO 谱面和音频延迟播放
    //TODO 利用AudioPlayers的OnPositionChanged事件获取时间
    //TODO 切出游戏的同时要暂停游戏
    //TODO 那个啥，小节线不整一下吗
    //TODO 所有的设置都要整合进StageConfig类中，方便以后写设置界面
    audioPlayer.release();

    //游戏基本设置
    //舞台相对于屏幕位置，数值0-1 从左到右
    _maniaStageOffset = 0.5; //0-1
    //判定线高度
    _judgLineHeight = 125;
    //舞台背景透明度
    _maniaStageBackgroundOpacity = 0.8; //0-1
    //基本下落速度
    _basicScrollingSpeed = 700;
    //视觉校准
    _visualCalibration = 50;//ms
    //谱面配置
    bpm = chartFile.bpm;
    sectionLength = 240 / bpm * _basicScrollingSpeed;
    //背景透明度
    _bgOpacity = 0.3;


    //游戏组件初始化
    _maniaStageConfig = ManiaStageConfig(_maniaStageOffset);
    _maniaKeyA = ManiaKey(_maniaStageConfig.horizonPositionOffset);
    _maniaKeyB = ManiaKey(_maniaStageConfig.horizonPositionOffset);
    _maniaKeyC = ManiaKey(_maniaStageConfig.horizonPositionOffset);
    _maniaKeyD = ManiaKey(_maniaStageConfig.horizonPositionOffset);
    _bg = Background(chartFile.backgroundImageFilePath,_bgOpacity);
    _maniaStageLeft = ManiaStageLeft(_maniaStageConfig.horizonPositionOffset);
    _maniaStageRight = ManiaStageRight(_maniaStageConfig.horizonPositionOffset);
    _maniaStageHint = ManiaStageHint(
        _maniaStageConfig.horizonPositionOffset, _judgLineHeight);
    _maniaStageBackground = ManiaStageBackground(
        _maniaStageConfig.horizonPositionOffset,
        true,
        _maniaStageBackgroundOpacity);
    _maniaStageLightA = ManiaStageLight(
        _maniaStageConfig.horizonPositionOffset, _judgLineHeight);
    _maniaStageLightB = ManiaStageLight(
        _maniaStageConfig.horizonPositionOffset, _judgLineHeight);
    _maniaStageLightC = ManiaStageLight(
        _maniaStageConfig.horizonPositionOffset, _judgLineHeight);
    _maniaStageLightD = ManiaStageLight(
        _maniaStageConfig.horizonPositionOffset, _judgLineHeight);
    /*
    _chart = Chart(_maniaStageConfig.horizonPositionOffset,
        _maniaKeyA.width * 4,
        _basicScrollingSpeed,
        _judgLineHeight,
        _visualCalibration,
        chartFile.baseLine,
        chartFile.bpm,
        chartFile.hitObjects.last.position
    );
     */


    //组件添加至游戏
    add(_bg);
    add(_maniaStageBackground);
    //add(_chart);

    //初始化谱面
    for(var value in chartFile.hitObjects){
      switch(value.roll) {
        case "A":
          {
            if(value.endPosition != 0){
              noteLAs.add(LongNoteA(_maniaStageConfig.horizonPositionOffset,
                  _maniaKeyA.width,
                  _basicScrollingSpeed,
                  _judgLineHeight,
                  _visualCalibration,
                  value.position,
                  value.endPosition));
            }else{
              noteAs.add(NoteA(_maniaStageConfig.horizonPositionOffset,
                  _maniaKeyA.width,
                  _basicScrollingSpeed,
                  _judgLineHeight,
                  _visualCalibration,
                  value.position));
            }
            break;
          }
        case "B":
          {
            if(value.endPosition != 0){
              noteLBs.add(LongNoteB(_maniaStageConfig.horizonPositionOffset,
                  _maniaKeyA.width,
                  _basicScrollingSpeed,
                  _judgLineHeight,
                  _visualCalibration,
                  value.position,
                  value.endPosition));
            }else{
              noteBs.add(NoteB(_maniaStageConfig.horizonPositionOffset,
                  _maniaKeyA.width,
                  _basicScrollingSpeed,
                  _judgLineHeight,
                  _visualCalibration,
                  value.position));
            }
            break;
          }
        case "C":
          {
            if(value.endPosition != 0){
              noteLCs.add(LongNoteC(_maniaStageConfig.horizonPositionOffset,
                  _maniaKeyA.width,
                  _basicScrollingSpeed,
                  _judgLineHeight,
                  _visualCalibration,
                  value.position,
                  value.endPosition));
            }else{
              noteCs.add(NoteC(_maniaStageConfig.horizonPositionOffset,
                  _maniaKeyA.width,
                  _basicScrollingSpeed,
                  _judgLineHeight,
                  _visualCalibration,
                  value.position));
            }
            break;
          }
        case "D":
          {
            if(value.endPosition != 0){
              noteLDs.add(LongNoteD(_maniaStageConfig.horizonPositionOffset,
                  _maniaKeyA.width,
                  _basicScrollingSpeed,
                  _judgLineHeight,
                  _visualCalibration,
                  value.position,
                  value.endPosition));
            }else{
              noteDs.add(NoteD(_maniaStageConfig.horizonPositionOffset,
                  _maniaKeyA.width,
                  _basicScrollingSpeed,
                  _judgLineHeight,
                  _visualCalibration,
                  value.position));
            }
            break;
          }
      }
    }
    audioPlayer.play(chartFile.audioFilePath);

    add(_maniaKeyA);
    add(_maniaKeyB);
    add(_maniaKeyC);
    add(_maniaKeyD);
    add(_maniaStageLeft);
    add(_maniaStageRight);
    add(_maniaStageLightA);
    add(_maniaStageLightB);
    add(_maniaStageLightC);
    add(_maniaStageLightD);
    add(_maniaStageHint);

    String songTitle = "${chartFile.title}\n${chartFile.version}";
    addWidgetOverlay(
        "Hud",
        HUD(
          onPausePressed: pauseGame,
          songPosition: songPositionValue,
          songTitle: songTitle,
        ));


    add(TextComponent(songTitle,config: TextConfig(color: Colors.white))..setByPosition(Position(0,110)));
    _fpsCounter = new TextComponent(fps().toString(),config: TextConfig(color: Colors.white))..setByPosition(Position(0,180));
    add(_fpsCounter);

    //毫秒计时器失败
    msTimer = Timer(99999);
    msTimer.start();
    _msTimer = TextComponent((msTimer.current*1000).toStringAsFixed(1),config: TextConfig(color: Colors.white))..setByPosition(Position(0, 210));
    add(_msTimer);

    //点击启动游戏
    addWidgetOverlay("TouchToStart", TouchToStart(onStartTapped: touchToStart));

    //判定数初始化
    criticalPerfectCount = 0;
    perfectCount = 0;
    goodCount = 0;
    missCount = 0;

    //判定结果展示
    judgCount = TextComponent(
        "_PERFECT ${criticalPerfectCount.toString()}\n"
            "PERFECT ${perfectCount.toString()}\n"
            "GOOD ${goodCount.toString()}\n"
            "MISS ${missCount.toString()}\n"
        ,config: TextConfig(color: Colors.white))..setByPosition(Position(500, 10));
    add(judgCount);

  }

  @override
  void resize(Size size) {
    super.resize(size);
    screenSize = size;
    _maniaKeyA.x -= _maniaKeyA.width * 2;
    _maniaKeyB.x -= _maniaKeyB.width;
    _maniaKeyD.x += _maniaKeyD.width;
    _maniaStageLightA.x -= _maniaKeyA.width * 2;
    _maniaStageLightB.x -= _maniaKeyA.width;
    _maniaStageLightD.x += _maniaKeyA.width;
    noteRenderPosition = (size.height - _judgLineHeight)/_basicScrollingSpeed;
  }

  void noteAdder(Note value){
    if(value.isAdded == false && value.position/1000 <= msTimer.current+(screenSize.height-_judgLineHeight+100)/_basicScrollingSpeed){
      add(value);
      value.isAdded = true;
    }
  }

  var addNoteCounter = 1;
  @override
  void update(double t) {
    super.update(t);
    if(started == false){
      pauseEngine();
      audioPlayer.pause();
      started = true;
    }
    msTimer.update(t);
    _msTimer.text = (msTimer.current*1000).toStringAsFixed(1);
    //TODO 动态加载谱面
    //TODO 优化遍历过程

    for(var value in noteAs){
      noteAdder(value);
    }
    for(var value in noteBs){
      noteAdder(value);
    }
    for(var value in noteCs){
      noteAdder(value);
    }
    for(var value in noteDs){
      noteAdder(value);
    }
    for(var value in noteLAs){
      noteAdder(value);
    }
    for(var value in noteLBs){
      noteAdder(value);
    }
    for(var value in noteLCs){
      noteAdder(value);
    }
    for(var value in noteLDs){
      noteAdder(value);
    }

    if(recordFps()){
      _fpsCounter.text = fps().toStringAsFixed(1);
    }
    songPositionValue = (t/songDuration);

    judgCount.text = "_PERFECT ${criticalPerfectCount.toString()}\n"
        "PERFECT ${perfectCount.toString()}\n"
        "GOOD ${goodCount.toString()}\n"
        "MISS ${missCount.toString()}\n";
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  void maniaKeyPressed(String maniaKey) {
    switch (maniaKey) {
      case "A":
        _maniaKeyA.keyPressed();
        _maniaStageLightA.keyPressed();
        for(var value in noteAs){
          if(value.isAdded == true && value.isTapped == false && value.isMissed == false){
            value.noteJudgment();
          }
        }
        break;
      case "B":
        _maniaKeyB.keyPressed();
        _maniaStageLightB.keyPressed();
        for(var value in noteBs){
          if(value.isAdded == true && value.isTapped == false && value.isMissed == false){
            value.noteJudgment();
          }
        }
        break;
      case "C":
        _maniaKeyC.keyPressed();
        _maniaStageLightC.keyPressed();
        for(var value in noteCs){
          if(value.isAdded == true && value.isTapped == false && value.isMissed == false){
            value.noteJudgment();
          }
        }
        break;
      case "D":
        for(var value in noteDs){
          if(value.isAdded == true && value.isTapped == false && value.isMissed == false){
            value.noteJudgment();
          }
        }
        _maniaKeyD.keyPressed();
        _maniaStageLightD.keyPressed();
        break;
    }
  }

  void maniaKeyReleased(String maniaKey) {
    switch (maniaKey) {
      case "A":
        _maniaKeyA.keyReleased();
        _maniaStageLightA.keyReleased();
        break;
      case "B":
        _maniaKeyB.keyReleased();
        _maniaStageLightB.keyReleased();
        break;
      case "C":
        _maniaKeyC.keyReleased();
        _maniaStageLightC.keyReleased();
        break;
      case "D":
        _maniaKeyD.keyReleased();
        _maniaStageLightD.keyReleased();
        break;
    }
  }


  void pauseGame() {
    addWidgetOverlay(
        'PauseMenu',
        PauseMenu(
          onResumePressed: resumeGame,
        ));
    pauseEngine();
    audioPlayer.pause();
  }

  void resumeGame() {
    removeWidgetOverlay("PauseMenu");
    resumeEngine();
    audioPlayer.resume();
  }

  void touchToStart(){
    removeWidgetOverlay("TouchToStart");
    resumeEngine();
    audioPlayer.resume();
  }
  @override
  bool recordFps() => true;
}
