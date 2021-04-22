import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';
import 'package:third_try/game/localfile/localfile-manager.dart';
import 'package:third_try/game/localfile/chartfile.dart';

class LocalFileTest extends BaseGame {


  LocalFileTest() {
    add(TextComponent("LocalFileTest", config: TextConfig(color: Colors.white))
      ..setByPosition(Position(0, 0)));
    add(TextComponent("Here", config: TextConfig(color: Colors.white))
      ..setByPosition(Position(0, 30)));
    getChartFolders();
  }

  void getChartFolders() async {
    LocalFileManager _localFileManager = new LocalFileManager();
    List<ChartFile> _chartFileArr = await _localFileManager.readSongsFolders();
    double count = 60;
    if(_chartFileArr.isNotEmpty) {
      //音频读取
      /*
      AudioPlayer audioPlayer = new AudioPlayer();
      audioPlayer.setUrl(_chartFileArr[0].audioFilePath);
      audioPlayer.play(_chartFileArr[0].audioFilePath);
       */

      //图片读取
      /*
      var fileImage = File(_chartFileArr[0].backgroundImageFilePath);
      Uint8List imageUint8List = await fileImage.readAsBytes();
      final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(imageUint8List);
      final ui.ImageDescriptor descriptor = await ui.ImageDescriptor.encoded(buffer);
      final ui.Codec codec = await descriptor.instantiateCodec();
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      add(SpriteComponent()..sprite = Sprite.fromImage(frameInfo.image)..width = 900 ..height = 506.25);
       */
      //谱面信息读取
      /*
      for (var _chartFile in _chartFileArr) {
        add(TextComponent(
            "${_chartFile.artist} - ${_chartFile.title}   ${_chartFile
                .version}   ${_chartFile.hitObjects.length.toString()}",
            config: TextConfig(color: Colors.white)
        )
          ..setByPosition(Position(0, count)));
        add(TextComponent(
            "${_chartFile.audioFilePath}",
            config: TextConfig(color: Colors.white)
        )
          ..setByPosition(Position(-800, count+30)));
        count += 60;
      }
       */
    }else{
      print("can't read songs folder");
    }
  }
}
