import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Background extends SpriteComponent{
  Size screenSize;
  double bgOpacity;
  ui.Image bgImage;
  String bgFilePath;

  Background(String bgFilePath,double bgOpacity){
    this.bgFilePath = bgFilePath;
    getBg(bgFilePath);
    sprite = Sprite('bg.png');
    width = 10;
    height = 10;
    this.bgOpacity = bgOpacity;

  }

  void getBg(String filePath) async{
    var fileImage = File(filePath);
    Uint8List imageUint8List = await fileImage.readAsBytes();
    final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(imageUint8List);
    final ui.ImageDescriptor descriptor = await ui.ImageDescriptor.encoded(buffer);
    final ui.Codec codec = await descriptor.instantiateCodec();
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    bgImage = frameInfo.image;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if(bgImage != null) {
      sprite = Sprite.fromImage(bgImage);
    }
  }

  @override
  void resize(Size size){
    screenSize = size;
  }

  @override
  void render(Canvas canvas) {
    sprite.renderCentered(
        canvas,
        Position(screenSize.width/2,screenSize.height/2),
        size:Position(screenSize.width, screenSize.height),
        overridePaint: Paint()..color = Colors.black.withOpacity(bgOpacity)
    );
  }
}