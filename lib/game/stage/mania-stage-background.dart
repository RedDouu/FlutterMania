import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:third_try/game/stage/mania-key.dart';


class ManiaStageBackground extends PositionComponent{
  Size _screenSize;
  double _offset;
  Rect _background;
  bool _hasLine;
  double _opacity;


  ManiaStageBackground(double offset,bool hasLine,double opacity){
    _offset = offset;
    _hasLine = hasLine;
    _opacity = opacity;
  }

  @override
  void resize(Size size) {
    super.resize(size);
    _screenSize = size;
    _background = Rect.fromLTWH(
        size.width*_offset - ManiaKey(_offset).width*2,
        0,
        ManiaKey(_offset).width*4, size.height
    );
  }

  @override
  void render(Canvas c) {
    c.drawRect(_background, Paint()..color = Colors.black.withOpacity(_opacity));
    if(_hasLine){
      c.drawLine(
          Offset(_screenSize.width*_offset - ManiaKey(_offset).width*2,0),
          Offset(_screenSize.width*_offset - ManiaKey(_offset).width*2,_screenSize.height),
          Paint()..color = Colors.white
      );
      c.drawLine(
          Offset(_screenSize.width*_offset - ManiaKey(_offset).width,0),
          Offset(_screenSize.width*_offset - ManiaKey(_offset).width,_screenSize.height),
          Paint()..color = Colors.white
      );
      c.drawLine(
          Offset(_screenSize.width*_offset,0),
          Offset(_screenSize.width*_offset,_screenSize.height),
          Paint()..color = Colors.white
      );
      c.drawLine(
          Offset(_screenSize.width*_offset + ManiaKey(_offset).width,0),
          Offset(_screenSize.width*_offset + ManiaKey(_offset).width,_screenSize.height),
          Paint()..color = Colors.white
      );
      c.drawLine(
          Offset(_screenSize.width*_offset + ManiaKey(_offset).width*2,0),
          Offset(_screenSize.width*_offset + ManiaKey(_offset).width*2,_screenSize.height),
          Paint()..color = Colors.white
      );
    }
  }
  
}