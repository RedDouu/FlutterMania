import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:third_try/screens/select-song.dart';

class PauseMenu extends StatelessWidget {

  final Function onResumePressed;

  const PauseMenu({
    Key key,
    @required this.onResumePressed
  }):assert(onResumePressed != null),
        super(key:key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.white.withOpacity(0.3),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 100.0,
            vertical: 50.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pause',
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
              IconButton(
                  icon: Icon(Icons.play_arrow, color: Colors.white, size: 30.0),
                  onPressed: () {
                    onResumePressed.call();
                  }),
              IconButton(
                  icon: Icon(Icons.logout, color: Colors.redAccent, size: 30.0),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SelectSong())
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
