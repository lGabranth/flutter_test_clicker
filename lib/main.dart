import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chicken Clicker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Chicken Clicker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/*Timer.periodic(duration, (Timer t) => _incrementCounter())*/
class _MyHomePageState extends State<MyHomePage> {
  int _wingsNumber = 0;
  int _cursorNumber = 1;
  int _autoclickerNumber = 0;
  int _cursorPrice = 10;
  int _autoclickerPrice = 10;
  int _numberOfClick = 0;
  bool _hasVibrated = false;

  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = AudioCache();
    return await cache.play("chicken.mp3");
  }

  void _autoIncrementWings() {
    setState(() {
      _wingsNumber += _autoclickerNumber;
    });
  }

  void patternVibrate() {
    HapticFeedback.heavyImpact();

    sleep(
      const Duration(milliseconds: 200),
    );

    HapticFeedback.heavyImpact();

    sleep(
      const Duration(milliseconds: 500),
    );

    HapticFeedback.heavyImpact();

    sleep(
      const Duration(milliseconds: 200),
    );
    HapticFeedback.heavyImpact();
  }

  late final AnimationController _controller;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _wingsNumber += _cursorNumber;
      ++_numberOfClick;
      if (!_hasVibrated && _numberOfClick >= 300) {
        _hasVibrated = true;
        playLocalAsset();
        patternVibrate();
      }
    });
  }

  void _incrementCursor() {
    setState(() {
      if (_wingsNumber >= _cursorPrice) {
        ++_cursorNumber;
        _wingsNumber -= _cursorPrice;
        _cursorPrice *= 2;
      }
    });
  }

  void _incrementAutoclicker() {
    setState(() {
      if (_wingsNumber >= _autoclickerPrice) {
        ++_autoclickerNumber;
        _wingsNumber -= _autoclickerPrice;
        _autoclickerPrice *= 4;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _autoIncrementWings();
    });
    // _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage (
            image: NetworkImage (
              "https://s.alicdn.com/@sc04/kf/Ha984c6ca434841b491009df49f1f90743.jpg_300x300.jpg",
            ),
            fit: BoxFit.cover,
          )
        ),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
                style: GoogleFonts.roboto(),
              ),
              Text(
                '$_wingsNumber',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 35
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(decoration: const BoxDecoration(
                    image: DecorationImage (
                      image: NetworkImage (
                        "https://i.imgur.com/DNHpuaA.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ), width: 400, height: 400,),
                  ImageQuiTourne(
                      onTap: _incrementCounter,
                      triggerAltImage: _wingsNumber >= 100,
                      triggerUltimateImage: _numberOfClick >= 300
                  ),
                  ListView()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ImageClicker(onTap: () { _incrementCursor(); }, image: Image.asset('assets/cursor1.png'), size: 100),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red,),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          color: const Color.fromARGB(150, 255, 255, 255)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text('New cursor price : $_cursorPrice', style: GoogleFonts.roboto()),
                        ),
                      ),
                    ]
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ImageClicker(onTap: () { _incrementAutoclicker(); }, image: Image.asset('assets/chick.png'), size: 100),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red,),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          color: const Color.fromARGB(150, 255, 255, 255)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text('Autoclicker price : $_autoclickerPrice', style: GoogleFonts.roboto()),
                        ),
                      ),
                    ]
                  ),
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImageClicker extends StatelessWidget {
  final VoidCallback onTap;
  final Image image;
  final double size;

  const ImageClicker({ required this.onTap, required this.image, required this.size }) : super();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onTap,
        icon: image,
        iconSize: size,
        tooltip: 'Increment');
  }
}

// class ImageClickerMultiple extends StatelessWidget {
class ImageClickerMultiple extends StatelessWidget {
  final VoidCallback onTap;
  final Image image;
  final double size;
  final Image altImage;
  final bool triggerAltImage;
  final Image ultimateImage;
  final bool triggerUltimateImage;

  const ImageClickerMultiple({
    required this.onTap,
    required this.image,
    required this.size,
    required this.altImage,
    required this.triggerAltImage,
    required this.ultimateImage,
    required this.triggerUltimateImage
  }) : super();

  @override
  Widget build(BuildContext context) {
    Image imageToDisplay;

    if (triggerUltimateImage) { imageToDisplay = ultimateImage; }
    else if (triggerAltImage) { imageToDisplay = altImage; }
    else { imageToDisplay = image; }

    return IconButton(
              onPressed: onTap,
              icon: imageToDisplay,
              iconSize: size,
              tooltip: 'Increment'
            );
  }
}

class ImageQuiTourne extends StatefulWidget {
  const ImageQuiTourne({ Key? key, required this.onTap, required this.triggerAltImage, required this.triggerUltimateImage }) : super(key: key);

  final VoidCallback onTap;
  final bool triggerAltImage;
  final bool triggerUltimateImage;

  @override
  State<ImageQuiTourne> createState() => AnimationCustom();
}

class AnimationCustom extends State<ImageQuiTourne> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1), upperBound: math.pi * 0);
    if (widget.triggerUltimateImage) {
      _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2, milliseconds: 2), upperBound: math.pi * 6.3)..repeat();
    }

    return RotationTransition (
      turns: Tween(begin: 0.0, end: 0.1).animate(_controller),
      child: ImageClickerMultiple(
        onTap: widget.onTap,
        image: Image.asset('assets/good-chicken.png'),
        size: 250,
        altImage: Image.asset('assets/bad_chicken.png'),
        triggerAltImage: widget.triggerAltImage,
        ultimateImage: Image.asset('assets/awesome_chicken.png'),
        triggerUltimateImage: widget.triggerUltimateImage,
      ),
    );
  }
}
