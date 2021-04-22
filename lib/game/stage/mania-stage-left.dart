import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:third_try/game/stage/mania-key.dart';

class ManiaStageLeft extends SpriteComponent{

  double offset;

  ManiaStageLeft(double offset){
    sprite = Sprite('mania-stage-left.png');
    width = 203;
    height = 770;
    this.offset = offset;
  }

  @override
  void resize(Size size) {
    super.resize(size);
    x = size.width*offset - ManiaKey(offset).width*2 - this.width;
    y = size.height - this.height;
  }


}
