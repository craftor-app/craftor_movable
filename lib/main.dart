import 'package:craftor_movable/models/interactive_box_info.dart';
import 'package:craftor_movable/movable.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Craftor movable',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  movableInfo info = movableInfo(
    size: const Size(100, 100),
    position: const Offset(10, 10),
    rotateAngle: 0,
  );
  bool isSelected = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        CraftorMovable(
          isSelected: isSelected,
          // keepRatio: RawKeyboard.instance.keysPressed
          //     .contains(LogicalKeyboardKey.shiftLeft),
          keepRatio: true,
          scale: 1,
          scaleInfo: info,
          onTapInside: () => setState(() => isSelected = true),
          onTapOutside: (details) => setState(() => isSelected = false),
          onChange: (newInfo) => setState(() => info = newInfo),
          child: Container(
            color: Colors.grey,
          ),
        )
      ],
    ));
  }
}
