import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/time.dart';
import 'package:flutter/material.dart';
import 'package:third_try/game/stage/mania-stage-hint.dart';

import 'mania-key.dart';

class ManiaStageLight extends SpriteComponent{
  double _offset;
  double ratio;
  double _judgLineHeight;
  Size screenSize;
  bool isKeyPress;
  ManiaStageLight(double offset,double judgLineHeight){
    this._offset = offset;
    this._judgLineHeight = judgLineHeight;
    sprite = Sprite("mania-stage-light.png");
    width = 113;
    height = 414;
    ratio = width/height;
    isKeyPress = false;
  }

  @override
  void resize(Size size) {
    super.resize(size);
    screenSize = size;
    width = ManiaKey(_offset).width;
    height = this.width / ratio;
    y = size.height - this.height -  _judgLineHeight;
    x = size.width*_offset;
  }

  @override
  void render(Canvas canvas) {
    if(isKeyPress == true) {
      super.render(canvas);
    }else {

    }
  }

  void keyPressed(){
    isKeyPress = true;
  }
  void keyReleased(){
    isKeyPress = false;
  }
}