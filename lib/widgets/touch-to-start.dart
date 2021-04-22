import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TouchToStart extends StatelessWidget {

  final Function onStartTapped;

  TouchToStart({@required this.onStartTapped}) :assert(onStartTapped != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onStartTapped.call();
      },
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
        ),
        child: Center(
          child: Text(
            "T O U C H",
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


