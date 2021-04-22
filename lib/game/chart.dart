import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/material.dart';

class Chart extends PositionComponent{
  double bpm;
  double scrollingSpeed;
  double basicScrollingSpeed;
  double _offset;
  double _sectionLength;
  double _judgLineHeight;
  double _renderbaseline;
  double _visualCalibration;

  Chart(double offset,double width,double scrollingSpeed,double judgLineHeight,double visualCalibration,double baseline,double bpm,double chartLength){
    //baseline 第一条小节线的谱面位置(ms)
    this.width = width;
    this.bpm = bpm;
    _offset = offset;
    basicScrollingSpeed = scrollingSpeed;
    height = (baseline/1000)*basicScrollingSpeed;
    _sectionLength = 240/bpm*basicScrollingSpeed;
    _judgLineHeight = judgLineHeight;
    _renderbaseline = (baseline/1000)*basicScrollingSpeed;
    _visualCalibration = (visualCalibration/1000)*basicScrollingSpeed;
  }


  @override
  void render(Canvas c) {
    Offset offset = toPosition().toOffset();
    for(double i=_renderbaseline;i<this.height;i+=_sectionLength){
      c.drawLine(offset.translate(0, height-i), offset.translate(width, height-i), Paint()..color = Colors.white);
    }
    //c.drawLine(offset.translate(0, 0), offset.translate(width, 0), Paint()..color = Colors.white);
    //c.drawLine(offset.translate(0, -10), offset.translate(width, -10), Paint()..color = Colors.white);
  }

  @override
  void resize(Size size) {
    super.resize(size);
    x = size.width*_offset - width/2;
    y = size.height - _visualCalibration - this.height -  _judgLineHeight;
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += basicScrollingSpeed * dt;
  }

}