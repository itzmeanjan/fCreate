import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'dart:math' show min, Random;
import 'dart:async' show Timer;

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'fCreate', theme: ThemeData.light(), home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> implements White {
  var _tm;
  int _b = 8;
  double _h = 1;
  double _g = 0;
  bool _e = true;
  int _wh = -1;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  setW(int c) {
    if (!_tm.isActive)
      setState(() {
        _wh = c;
      });
    else
      _wh = c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('fCreate'),
          elevation: 16,
          backgroundColor: Colors.cyanAccent),
      body: Stack(children: <Widget>[
        Opacity(
            opacity: _g,
            child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.cyanAccent, Colors.tealAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                  padding: EdgeInsets.all(16),
                  child: CustomPaint(
                      painter: Painter(_b, this), size: Size.infinite),
                ),
                onTap: () {
                  if (_tm.isActive) {
                    _tm.cancel();
                    showDialog(
                        context: context,
                        builder: (cx) => Dialog(
                            elevation: 9,
                            child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                    '$_wh/${_b * _b} White Balls ${_wh >= (_b * _b) / 2 ? '\u{2714}' : '\u{2716}'}',
                                    style: TextStyle(
                                        fontSize: 25, letterSpacing: 2)))));
                  }
                },
                onDoubleTap: () {
                  if (!_tm.isActive)
                    _tm = Timer.periodic(Duration(seconds: 1), (t) {
                      if (t.isActive)
                        setState(() {
                          _b = Random().nextInt(12) + 8;
                        });
                    });
                })),
        Opacity(
            opacity: _h,
            child: Center(
                child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('An EYE Test Game',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3,
                                  fontSize: 30)),
                          Divider(color: Colors.white, height: 24),
                          Text(
                              'Click to reveal whether it has atleast 50% WHITE Balls. Double clicking restarts loop.',
                              maxLines: 3)
                        ]))))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _e
            ? () {
                swap();
                _tm = Timer.periodic(Duration(seconds: 1), (t) {
                  if (t.isActive)
                    setState(() {
                      _b = Random().nextInt(12) + 8;
                    });
                });
              }
            : () {
                swap();
                _tm.cancel();
              },
        child: Icon(_e ? Icons.play_arrow : Icons.help),
        backgroundColor: Colors.cyanAccent,
        elevation: 16,
        tooltip: _e ? 'Init' : 'Help',
      ),
    );
  }

  swap() {
    var tmp = _h;
    setState(() {
      _h = _g;
      _g = tmp;
      _e = !_e;
    });
  }
}

class Painter extends CustomPainter {
  Painter(this.b, this.wh);
  List<Color> _cl = [Colors.white, Colors.black];
  int b;
  White wh;
  @override
  void paint(Canvas canvas, Size size) {
    int w = 0;
    double y = size.height / (b * 2);
    while (y < size.height) {
      double x = size.width / (b * 2);
      while (x < size.width) {
        var p = Paint()..color = _cl[Random().nextInt(2)];
        w += (p.color == Colors.white) ? 1 : 0;
        canvas.drawCircle(
            Offset(x, y), min(size.height / (b * 2), size.width / (b * 2)), p);
        x += size.width / b;
      }
      y += size.height / b;
    }
    wh.setW(w);
  }

  @override
  bool shouldRepaint(Painter p) => true;
}

abstract class White {
  setW(int c);
}
