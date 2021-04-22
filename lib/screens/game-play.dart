import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:third_try/game/game.dart';
import 'package:third_try/game/localfile/chartfile.dart';

class GamePlay extends StatelessWidget {
  final ChartFile chartFile;
  GamePlay({Key key, @required this.chartFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ManiaGame game = new ManiaGame(chartFile: chartFile);
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            game.widget,
            Positioned(
              left: 10,
              bottom: 50,
              child: GameButton(
                onTapDown: (_) {
                  game.maniaKeyPressed("A");
                },
                onTapUp: (_) {
                  game.maniaKeyReleased("A");
                },
              ),
            ),
            Positioned(
              left: 170,
              bottom: 50,
              child: GameButton(
                onTapDown: (_) {
                  game.maniaKeyPressed("B");
                },
                onTapUp: (_) {
                  game.maniaKeyReleased("B");
                },
              ),
            ),
            Positioned(
              right: 170,
              bottom: 50,
              child: GameButton(
                onTapDown: (_) {
                  game.maniaKeyPressed("C");
                },
                onTapUp: (_) {
                  game.maniaKeyReleased("C");
                },
              ),
            ),
            Positioned(
              right: 10,
              bottom: 50,
              child: GameButton(
                onTapDown: (_) {
                  game.maniaKeyPressed("D");
                },
                onTapUp: (_) {
                  game.maniaKeyReleased("D");
                },
              ),
            ),
          ],
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.,
  }
}

class GameButton extends StatelessWidget {
  final void Function(PointerUpEvent) onTapUp;
  final void Function(PointerDownEvent) onTapDown;

  GameButton({this.onTapDown, this.onTapUp});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: onTapUp,
      onPointerDown: onTapDown,
      child: SizedBox(
        width: 160,
        height: 140,
        child: Container(
          decoration: new BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
              border: new Border.all(width: 2, color: Colors.lightBlueAccent.withOpacity(0.2))),
        ),
      ),
    );
  }
}
