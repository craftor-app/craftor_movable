import 'package:flutter/material.dart';

class MoveableInfo {
  Size size;
  Offset position;
  double rotateAngle;

  MoveableInfo({
    required this.size,
    required this.position,
    required this.rotateAngle,
  });
  Rect get rect => position & size;
  double get x => position.dx;
  double get y => position.dy;
  double get width => size.width;
  double get height => size.height;

  MoveableInfo copyWith({Size? size, Offset? position, double? rotateAngle}) {
    return MoveableInfo(
      size: size ?? this.size,
      position: position ?? this.position,
      rotateAngle: rotateAngle ?? this.rotateAngle,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["width"] = size.width;
    map["height"] = size.height;
    map["x"] = position.dx;
    map["y"] = position.dy;
    map["rotateAngle"] = rotateAngle;

    return map;
  }

  @override
  String toString() {
    return "size: $size, position: $position, rotateAngle: $rotateAngle";
  }
}
