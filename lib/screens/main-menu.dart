import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:third_try/game/localfile/localfile-manager.dart';
import 'package:third_try/screens/select-song.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment(0, 0),
              child: Text(
                'Welcome to flee',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48,color: Colors.white,fontFamily: 'MonNewZelek'),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.5),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SelectSong())
                  );
                },
                child: Text(
                  "START",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24,fontFamily: 'MonNewZelek'),
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  side: MaterialStateProperty.all(
                    BorderSide.lerp(
                        BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.lightBlueAccent,
                          width: 2,
                        ),
                        BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.lightBlueAccent,
                          width: 2,
                        ),
                        50),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.8),
              child: OutlinedButton(
                onLongPress: () {
                  final LocalFileManager _localFileManager = new LocalFileManager();
                  _localFileManager.createSongsFolder();
                  return AlertDialog(
                    title: Text('Alert'),
                    content: Text('Reset Complete'),
                  );
                },
                child: Text(
                  "RESET local folder",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24,fontFamily: 'MonNewZelek'),
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  side: MaterialStateProperty.all(
                    BorderSide.lerp(
                        BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.red,
                          width: 2,
                        ),
                        BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.red,
                          width: 2,
                        ),
                        50),
                  ),
                ), onPressed: () {
                  //TODO 弹框没整好
                  return AlertDialog(
                    title: Text('Alert'),
                    content: SizedBox(
                      child:Container(
                        child:Text('Long press to reset\nThis action may REMOVE your Existing songs'),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    );
              },
              ),
            )
          ],
        ),
      ),
    );
  }
}
