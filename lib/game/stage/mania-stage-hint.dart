import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:third_try/game/stage/mania-key.dart';

class ManiaStageHint extends SpriteComponent {

  double offset;
  double judgLineHeight;

  ManiaStageHint(double offset,double judgLineHeight){
    sprite = Sprite('mania-stage-hint.png');
    width = 210;
    height = 25;
    this.offset = offset;
    this.judgLineHeight = judgLineHeight;
  }

  @override
  void resize(Size size) {
    super.resize(size);
    width = ManiaKey(offset).width*4;
    y = size.height - this.height/2 - judgLineHeight;
    x = size.width*offset - ManiaKey(offset).width*2;
  }
}