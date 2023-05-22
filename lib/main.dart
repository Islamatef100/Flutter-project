import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:vibration/vibration.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile comuing project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Record myRecording = Record();
  Timer? timer;

  static double volume = 0.0;
  double minVolume = -45.0;
  double total = 0.0;
  double average = 0.0;
  int counter = 0;
  Color flag = Colors.white;
  startTimer() async {
    timer ??=
        Timer.periodic(const Duration(seconds: 1), (timer) => updateVolume());
  }

// function to get new sound value.
  updateVolume() async {
    Amplitude ampl = await myRecording.getAmplitude();
    if (ampl.current > minVolume) {
      setState(() {
        if (counter == 10) {
          average = (total / 10);
          counter = 0;
          total = 0.0;
        } else {
          counter++;
          volume = (ampl.current - minVolume) / minVolume;
          total += volume;
        }
        //volume = average;
      });
    }
  }

// function to get the value ofstored  current sound  and change red flag.
  double volume0to(int maxVolumeToDisplay) {
    if (((average * maxVolumeToDisplay).round().abs()) > 70) {
      flag = Color.fromARGB(255, 122, 7, 1);
      Vibration.vibrate(duration: 500); // Vibrate for 500 milliseconds
    } else {
      flag = Colors.white;
    }
    return ((volume * 100).toDouble().round().abs()) / 100;
  }

// here to start microphone to record.
  Future<bool> startRecording() async {
    if (await myRecording.hasPermission()) {
      if (!await myRecording.isRecording()) {
        await myRecording.start();
      }
      startTimer();
      return true;
    } else {
      return false;
    }
  }

// to update value to dispaly in chart.
  static double progressValue = 0;

  void updateProgress(double newValue) {
    setState(() {
      progressValue = volume0to(100);
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Future<bool> recordFutureBuilder =
        Future<bool>.delayed(const Duration(seconds: 3), (() async {
      return startRecording();
    }));
    return Scaffold(
      backgroundColor: flag,
      appBar: AppBar(
        title: Text('Mobile comuing project'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressWithValue(value: volume0to(100)),
            SizedBox(height: 26),
            Text('sound noice: ${(volume0to(100) * 100).toStringAsFixed(1)}%'),
            SizedBox(height: 26),
            Slider(
              value: volume0to(100),
              onChanged: updateProgress,
            ),
          ],
        ),
      ),
    );
  }
}

// build in function to display circle progress.
class CircularProgressWithValue extends StatefulWidget {
  final double value;

  CircularProgressWithValue({required this.value});

  @override
  _CircularProgressWithValueState createState() =>
      _CircularProgressWithValueState();
}

class _CircularProgressWithValueState extends State<CircularProgressWithValue>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(CircularProgressWithValue oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _animation =
          Tween<double>(begin: oldWidget.value, end: widget.value).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return CircularProgressIndicator(
          value: _animation.value,
          strokeWidth: 10,
        );
      },
    );
  }
}




















































































































// this nest code untill now..

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:record/record.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mobile comuing project',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Record myRecording = Record();
//   Timer? timer;

//   static double volume = 0.0;
//   double minVolume = -45.0;
//   double total = 0.0;
//   double average = 0.0;
//   int counter = 0;
//   Color flag = Colors.white;
//   startTimer() async {
//     timer ??=
//         Timer.periodic(const Duration(seconds: 1), (timer) => updateVolume());
//   }

//   updateVolume() async {
//     Amplitude ampl = await myRecording.getAmplitude();
//     if (ampl.current > minVolume) {
//       setState(() {
//         if (counter == 10) {
//           average = (total / 10);
//           counter = 0;
//           total = 0.0;
//         } else {
//           counter++;
//           volume = (ampl.current - minVolume) / minVolume;
//           total += volume;
//         }
//         volume = average;
//       });
//     }
//   }

//   double volume0to(int maxVolumeToDisplay) {
//     if (((volume * maxVolumeToDisplay).round().abs()) > 70) {
//       flag = Color.fromARGB(255, 122, 7, 1);
//     } else {
//       flag = Colors.white;
//     }
//     return ((volume * 100).toDouble().round().abs()) / 100;
//   }

//   Future<bool> startRecording() async {
//     if (await myRecording.hasPermission()) {
//       if (!await myRecording.isRecording()) {
//         await myRecording.start();
//       }
//       startTimer();
//       return true;
//     } else {
//       return false;
//     }
//   }

//   static double progressValue = 0;

//   void updateProgress(double newValue) {
//     setState(() {
//       progressValue = volume0to(100);
//       ;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Future<bool> recordFutureBuilder =
//         Future<bool>.delayed(const Duration(seconds: 3), (() async {
//       return startRecording();
//     }));
//     return Scaffold(
//       backgroundColor: flag,
//       appBar: AppBar(
//         title: Text('Mobile comuing project'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressWithValue(value: volume0to(100)),
//             SizedBox(height: 26),
//             Text('sound noice: ${(volume0to(100) * 100).toStringAsFixed(1)}%'),
//             SizedBox(height: 26),
//             Slider(
//               value: volume0to(100),
//               onChanged: updateProgress,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CircularProgressWithValue extends StatefulWidget {
//   final double value;

//   CircularProgressWithValue({required this.value});

//   @override
//   _CircularProgressWithValueState createState() =>
//       _CircularProgressWithValueState();
// }

// class _CircularProgressWithValueState extends State<CircularProgressWithValue>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );

//     _animation = Tween<double>(begin: 0, end: widget.value).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     _animationController.forward();
//   }

//   @override
//   void didUpdateWidget(CircularProgressWithValue oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.value != oldWidget.value) {
//       _animation =
//           Tween<double>(begin: oldWidget.value, end: widget.value).animate(
//         CurvedAnimation(
//           parent: _animationController,
//           curve: Curves.easeInOut,
//         ),
//       );
//       _animationController.forward(from: 0.0);
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (BuildContext context, Widget? child) {
//         return CircularProgressIndicator(
//           value: _animation.value,
//           strokeWidth: 10,
//         );
//       },
//     );
//   }
// }

















// ---------- All Two Codes ------------------------
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:record/record.dart';

// -----------------2--------------------------------

// void main() {
//   runApp(const MaterialApp(home: MicPage()));
// }

// class MicPage extends StatefulWidget {
//   const MicPage({super.key});

//   @override
//   State<MicPage> createState() => _MicPageState();
// }

// class _MicPageState extends State<MicPage> {
//   Record myRecording = Record();
//   Timer? timer;

//   double volume = 0.0;
//   double minVolume = -45.0;
//   double total = 0.0;
//   double average = 0.0;
//   int counter = 0;
//   Color flag = Colors.white;
//   startTimer() async {
//     timer ??=
//         Timer.periodic(const Duration(seconds: 1), (timer) => updateVolume());
//   }

//   updateVolume() async {
//     Amplitude ampl = await myRecording.getAmplitude();
//     if (ampl.current > minVolume) {
//       setState(() {
//         if (counter == 10) {
//           average = (total / 10);
//           counter = 0;
//           total = 0.0;
//         } else {
//           counter++;
//           volume = (ampl.current - minVolume) / minVolume;
//           total += volume;
//         }
//         volume = average;
//       });
//     }
//   }

//   int volume0to(int maxVolumeToDisplay) {
//     if (((volume * maxVolumeToDisplay).round().abs()) > 70) {
//       flag = Color.fromARGB(255, 122, 7, 1);
//     } else {
//       flag = Colors.white;
//     }
//     return (volume * maxVolumeToDisplay).round().abs();
//   }

//   Future<bool> startRecording() async {
//     if (await myRecording.hasPermission()) {
//       if (!await myRecording.isRecording()) {
//         await myRecording.start();
//       }
//       startTimer();
//       return true;
//     } else {
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Future<bool> recordFutureBuilder =
//         Future<bool>.delayed(const Duration(seconds: 3), (() async {
//       return startRecording();
//     }));

//     return FutureBuilder(
//         future: recordFutureBuilder,
//         builder: (context, AsyncSnapshot<bool> snapshot) {
//           return Scaffold(
//             backgroundColor: flag,
//             body: Center(
//                 child: snapshot.hasData
//                     ? Text("VOLUME\n${volume0to(100)}",
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                             fontSize: 42, fontWeight: FontWeight.bold))
//                     : const CircularProgressIndicator()),
//           );
//         });
//   }
// }


// -----------------2--------------------------------

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mobile comuing project',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   double progressValue = 0.6;

//   void updateProgress(double newValue) {
//     setState(() {
//       progressValue = newValue;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mobile comuing project'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressWithValue(value: progressValue),
//             SizedBox(height: 16),
//             Text('sound noice: ${(progressValue * 100).toStringAsFixed(1)}%'),
//             SizedBox(height: 26),
//             Slider(
//               value: progressValue,
//               onChanged: updateProgress,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CircularProgressWithValue extends StatefulWidget {
//   final double value;

//   CircularProgressWithValue({required this.value});

//   @override
//   _CircularProgressWithValueState createState() =>
//       _CircularProgressWithValueState();
// }

// class _CircularProgressWithValueState extends State<CircularProgressWithValue>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );

//     _animation = Tween<double>(begin: 0, end: widget.value).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     _animationController.forward();
//   }

//   @override
//   void didUpdateWidget(CircularProgressWithValue oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.value != oldWidget.value) {
//       _animation =
//           Tween<double>(begin: oldWidget.value, end: widget.value).animate(
//         CurvedAnimation(
//           parent: _animationController,
//           curve: Curves.easeInOut,
//         ),
//       );
//       _animationController.forward(from: 0.0);
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (BuildContext context, Widget? child) {
//         return CircularProgressIndicator(
//           value: _animation.value,
//           strokeWidth: 10,
//         );
//       },
//     );
//   }
// }
