import 'dart:ui' as ui;

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'game.dart';

class Note extends SpriteComponent with HasGameRef<ManiaGame>{
  double ratio; // w/h
  double _offset;
  double _keyWidth;
  double bpm;
  double sectionLength;
  double basicScrollingSpeed;
  double _renderPosition;
  double _judgLineHeight;
  double _visualCalibration;
  Size screenSize;
  bool isAdded;
  bool isTapped;
  bool isMissed;

  double position;
  double endPosition;

  double _criticalPerfect,_perfect,_good,_miss;
  double _judgLine;

  TextConfig debugTextConfig = TextConfig(fontSize: 12, color: Colors.black);

  Note(double offset, double keyWidth, double scrollingSpeed,
      double judgLineHeight, double visualCalibration, double position) {
    width = 256;
    height = 96;
    ratio = width / height;
    _offset = offset;
    _keyWidth = keyWidth;
    bpm = 132;
    basicScrollingSpeed = scrollingSpeed;
    _renderPosition = (position / 1000) * basicScrollingSpeed;
    sectionLength = 240 / bpm * basicScrollingSpeed;
    _judgLineHeight = judgLineHeight;
    _visualCalibration = (visualCalibration / 1000) * basicScrollingSpeed;
    isAdded = false;
    isTapped = false;
    isMissed = false;
    this.position = position;

    //判定相关
    _criticalPerfect = 0.02*basicScrollingSpeed;
    _perfect = 0.05*basicScrollingSpeed;
    _good = 0.1*basicScrollingSpeed;
    _miss = 0.15*basicScrollingSpeed;

  }

  //默认判定 小P20ms 大p50ms good100ms miss150ms
  void noteJudgment() {
    if(y+height > _judgLine - _criticalPerfect && y+height <_judgLine + _criticalPerfect){
      gameRef.criticalPerfectCount ++;
      isTapped = true;
      this.destroy();
    } else if(y+height > _judgLine - _perfect && y+height <_judgLine + _perfect){
      gameRef.perfectCount ++;
      isTapped = true;
      this.destroy();
    } else if(y+height > _judgLine - _good && y+height <_judgLine + _good) {
      gameRef.goodCount ++;
      isTapped = true;
      this.destroy();
    } else if(y+height >_judgLine - _miss && y+height < _judgLine + _miss) {
      gameRef.missCount ++;
      isTapped = true;
      isMissed = true;
      this.destroy();
    }
  }
  //TODO 实装LN判定
  void longNoteJudgment() {
    if(y+height > _judgLine - _criticalPerfect && y+height <_judgLine + _criticalPerfect){
      gameRef.criticalPerfectCount ++;
      isTapped = true;
      this.destroy();
    } else if(y+height > _judgLine - _perfect && y+height <_judgLine + _perfect){
      gameRef.perfectCount ++;
      isTapped = true;
      this.destroy();
    } else if(y+height > _judgLine - _good && y+height <_judgLine + _good) {
      gameRef.goodCount ++;
      isTapped = true;
      this.destroy();
    } else if(y+height >_judgLine - _miss && y+height < _judgLine + _miss) {
      gameRef.missCount ++;
      isTapped = true;
      isMissed = true;
      this.destroy();
    }
  }

  Map<String, dynamic> _map() {
    return {
      "position": position,
      "endPosition": endPosition,
      "isTapped": isTapped,
      "isMissed": isMissed,
    };
  }
  dynamic get(String propertyName) {
    var _mapRep = _map();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
  @override
  void resize(Size size) {
    super.resize(size);
    screenSize = size;
    width = _keyWidth;
    height = width / ratio;
    y = -100 - height - _visualCalibration;
    _judgLine = size.height-_judgLineHeight;
  }
  @override
  void update(double dt) {
    super.update(dt);
    y += basicScrollingSpeed * dt;
    if (y > screenSize.height - 50) {
      this.isMissed = true;
      gameRef.missCount ++;
      this.destroy();
    }
  }
  @override
  void render(ui.Canvas canvas) {
    if (y + height > -50 && y < screenSize.height) {
      super.render(canvas);
      debugTextConfig.render(canvas, position.toString(), Position(0, 0));
    }
  }
  @override
  bool destroy() {
    if (isTapped == true || isMissed == true) {
      return true;
    }
    else
      return false;
  }
}

class NoteA extends Note{
  NoteA(double offset, double keyWidth, double scrollingSpeed, double judgLineHeight, double visualCalibration, double position) : super(offset, keyWidth, scrollingSpeed, judgLineHeight, visualCalibration, position){
    sprite = Sprite('mania-note1.png');
  }

  @override
  void resize(ui.Size size) {
    // TODO: implement resize
    super.resize(size);
    x = size.width*_offset - width*2;
  }
}
class NoteB extends Note{
  NoteB(double offset, double keyWidth, double scrollingSpeed, double judgLineHeight, double visualCalibration, double position) : super(offset, keyWidth, scrollingSpeed, judgLineHeight, visualCalibration, position){
    sprite = Sprite('mania-note2.png');
  }

  @override
  void resize(ui.Size size) {
    // TODO: implement resize
    super.resize(size);
    x = size.width*_offset - width;
  }
}
class NoteC extends Note{
  NoteC(double offset, double keyWidth, double scrollingSpeed, double judgLineHeight, double visualCalibration, double position) : super(offset, keyWidth, scrollingSpeed, judgLineHeight, visualCalibration, position){
    sprite = Sprite('mania-note2.png');
  }

  @override
  void resize(ui.Size size) {
    // TODO: implement resize
    super.resize(size);
    x = size.width*_offset;
  }
}
class NoteD extends Note{
  NoteD(double offset, double keyWidth, double scrollingSpeed, double judgLineHeight, double visualCalibration, double position) : super(offset, keyWidth, scrollingSpeed, judgLineHeight, visualCalibration, position){
    sprite = Sprite('mania-note1.png');
  }

  @override
  void resize(ui.Size size) {
    // TODO: implement resize
    super.resize(size);
    x = size.width*_offset + width;
  }
}

class LongNoteA extends Note{

  Sprite _longNoteHeadSprite;
  double _scale,_longNoteHeadHeight,_renderEndPosition;
  Size screenSize;
  LongNoteA(double offset, double keyWidth, double scrollingSpeed, double judgLineHeight, double visualCalibration, double position,double endPosition) : super(offset, keyWidth, scrollingSpeed, judgLineHeight, visualCalibration, position){
    sprite = Sprite('mania-note1L.png');
    _renderEndPosition = (endPosition/1000)*basicScrollingSpeed;
    _scale = keyWidth/width;
    _longNoteHeadHeight = height*_scale;
    _longNoteHeadSprite = Sprite('mania-note1h.png');
    this.endPosition = endPosition;
  }
  @override
  void resize(Size size) {
    super.resize(size);
    height = _renderEndPosition-_renderPosition;
    x = size.width*_offset - width*2;
    y = -100 - _longNoteHeadHeight - height  - _visualCalibration;

  }

  @override
  void render(ui.Canvas canvas) {
    if(y+height>-50 && y < screenSize.height) {
      super.render(canvas);
      _longNoteHeadSprite.renderScaled(
          canvas, Position(0, height), scale: _scale);
      //_longNoteHeadSprite.renderScaled(canvas,Position(0,0),scale: _scale);
    }
  }


}
class LongNoteB extends Note{

  Sprite _longNoteHeadSprite;
  double _scale,_longNoteHeadHeight,_renderEndPosition;
  Size screenSize;
  LongNoteB(double offset, double keyWidth, double scrollingSpeed, double judgLineHeight, double visualCalibration, double position,double endPosition) : super(offset, keyWidth, scrollingSpeed, judgLineHeight, visualCalibration, position){
    sprite = Sprite('mania-note2L.png');
    _renderEndPosition = (endPosition/1000)*basicScrollingSpeed;
    _scale = keyWidth/width;
    _longNoteHeadHeight = height*_scale;
    _longNoteHeadSprite = Sprite('mania-note2h.png');
    this.endPosition = endPosition;
  }
  @override
  void resize(Size size) {
    super.resize(size);
    height = _renderEndPosition-_renderPosition;
    x = size.width*_offset - width;
    y = -100 - _longNoteHeadHeight - height  - _visualCalibration;
  }

  @override
  void render(ui.Canvas canvas) {
    super.render(canvas);
    if(y+height>-50 && y < screenSize.height) {
      _longNoteHeadSprite.renderScaled(
          canvas, Position(0, height), scale: _scale);
      //_longNoteHeadSprite.renderScaled(canvas,Position(0,0),scale: _scale);
    }
  }
}
class LongNoteC extends Note{

  Sprite _longNoteHeadSprite;
  double _scale,_longNoteHeadHeight,_renderEndPosition;
  Size screenSize;
  LongNoteC(double offset, double keyWidth, double scrollingSpeed, double judgLineHeight, double visualCalibration, double position,double endPosition) : super(offset, keyWidth, scrollingSpeed, judgLineHeight, visualCalibration, position){
    sprite = Sprite('mania-note2L.png');
    _renderEndPosition = (endPosition/1000)*basicScrollingSpeed;
    _scale = keyWidth/width;
    _longNoteHeadHeight = height*_scale;
    _longNoteHeadSprite = Sprite('mania-note2h.png');
    this.endPosition = endPosition;
  }
  @override
  void resize(Size size) {
    super.resize(size);
    height = _renderEndPosition-_renderPosition;
    x = size.width*_offset;
    y = -100 - _longNoteHeadHeight - height - _visualCalibration;
  }

  @override
  void render(ui.Canvas canvas) {
    if(y+height>-50 && y < screenSize.height) {
      super.render(canvas);
      _longNoteHeadSprite.renderScaled(
          canvas, Position(0, height), scale: _scale);
      //_longNoteHeadSprite.renderScaled(canvas,Position(0,0),scale: _scale);
    }
  }
}
class LongNoteD extends Note{

  Sprite _longNoteHeadSprite;
  double _scale,_longNoteHeadHeight,_renderEndPosition;
  Size screenSize;
  LongNoteD(double offset, double keyWidth, double scrollingSpeed, double judgLineHeight, double visualCalibration, double position,double endPosition) : super(offset, keyWidth, scrollingSpeed, judgLineHeight, visualCalibration, position){
    sprite = Sprite('mania-note1L.png');
    _renderEndPosition = (endPosition/1000)*basicScrollingSpeed;
    _scale = keyWidth/width;
    _longNoteHeadHeight = height*_scale;
    _longNoteHeadSprite = Sprite('mania-note1h.png');
    this.endPosition = endPosition;
  }
  @override
  void resize(Size size) {
    super.resize(size);
    height = _renderEndPosition-_renderPosition;
    x = size.width*_offset + width;
    y = -100 - _longNoteHeadHeight - height - _visualCalibration;
  }

  @override
  void render(ui.Canvas canvas) {
    if(y+height>-50 && y < screenSize.height) {
      super.render(canvas);
      _longNoteHeadSprite.renderScaled(
          canvas, Position(0, height), scale: _scale);
      //_longNoteHeadSprite.renderScaled(canvas,Position(0,0),scale: _scale);
    }

  }
}
