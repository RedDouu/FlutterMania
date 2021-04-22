import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/sprite.dart';
import 'package:third_try/game/game.dart';

class ManiaKey extends SpriteComponent{

  ManiaGame game;
  double offset;

  ManiaKey(double offset){
    sprite = Sprite('mania-key1.png');
    width = 50;
    height = 192;
    this.offset = offset;
  }

  @override
  void resize(Size size){
    y = size.height - this.height;
    x = size.width*offset;
  }

  void keyPressed(){
    sprite = Sprite("mania-key1d.png");
    
  }
  void keyReleased(){
    sprite = Sprite("mania-key1.png");
  }
}