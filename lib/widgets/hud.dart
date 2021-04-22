import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HUD extends StatelessWidget {
  final Function onPausePressed;
  final double songPosition;
  final String songTitle;

  const HUD({
    Key key,
    this.onPausePressed,
    this.songPosition,
    this.songTitle,
  })  : assert(onPausePressed != null),
        assert(songPosition != null),
        assert(songTitle != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 20,
          top: 5,
          child: Container(
            width: 150,
            height: 40,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    onPressed: () {
                      onPausePressed.call();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    onPressed: () {
                      onPausePressed.call();
                    },
                  ),
                ]),
          ),
        ),
        Positioned(
          left: 20,
          top: 80,
          child: SizedBox(
            height: 10,
            width: 150,
            child: LinearProgressIndicator(
              value: songPosition,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
