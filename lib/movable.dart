// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field
import 'dart:math';
import 'dart:ui';

import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';

import 'enums/scale_direction_enum.dart';
import 'helpers/scale_helper.dart';
import 'models/interactive_box_info.dart';
import 'models/scale_info.dart';

class CraftorMovable extends StatefulWidget {
  const CraftorMovable({
    super.key,
    required this.isSelected,
    required this.keepRatio,
    required this.scale,
    required this.scaleInfo,
    required this.onTapInside,
    this.onDoubleTap,
    required this.onTapOutside,
    required this.onChange,
    this.onChangeEnd,
    this.onChangeStart,
    this.onSecondaryTapDown,
    required this.child,
  });

  final bool isSelected;

  final bool keepRatio;
  final double scale;
  final movableInfo scaleInfo;
  final Function()? onDoubleTap;

  final Function() onTapInside;
  final Function(PointerDownEvent e) onTapOutside;
  final Function(TapDownDetails)? onSecondaryTapDown;

  final Function(movableInfo) onChange;
  final Function()? onChangeEnd;
  final Function()? onChangeStart;

  final Widget child;

  @override
  State<CraftorMovable> createState() => _CraftorMovableState();
}

class _CraftorMovableState extends State<CraftorMovable> {
  late double _width;
  late double _height;

  // bool _isPerforming = false;
  bool isMoving = false;

  double _x = 0.0;
  double _y = 0.0;

  @override
  void initState() {
    super.initState();

    _x = widget.scaleInfo.position.dx;
    _y = widget.scaleInfo.position.dy;
    _width = widget.scaleInfo.size.width;
    _height = widget.scaleInfo.size.height;
    _finalAngle = widget.scaleInfo.rotateAngle;
  }

  /// The starting angle when users first contact with the widget on screen.
  double _startingAngle = 0.0;

  /// The previous [_finalAngle].
  double _prevAngle = 0.0;

  /// The current rotation angle.
  double _finalAngle = 0.0;

  @override
  void didUpdateWidget(CraftorMovable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.scaleInfo != widget.scaleInfo) {
      _x = widget.scaleInfo.position.dx;
      _y = widget.scaleInfo.position.dy;
      _width = widget.scaleInfo.size.width;
      _height = widget.scaleInfo.size.height;
      _finalAngle = widget.scaleInfo.rotateAngle;
    }
  }

  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    const borderColor = Colors.black;

    return TapRegion(
      onTapInside: (d) => widget.onTapInside(),
      onTapOutside: (d) => widget.onTapOutside(d),
      child: Stack(
        children: [
          Positioned(
            left: _x,
            top: _y,
            width: _width,
            height: _height,
            child: DeferredPointerHandler(
              child: GestureDetector(
                onDoubleTap: widget.onDoubleTap,
                onPanUpdate: _onMoving,
                onSecondaryTapDown: widget.onSecondaryTapDown,
                onPanEnd: (d) {
                  setState(() {
                    isMoving = false;
                  });
                  widget.onChangeEnd?.call();
                },
                onPanStart: (d) {
                  setState(() {
                    isMoving = true;
                  });
                  _onScalingStart();
                },
                supportedDevices: const {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
                child: Transform.rotate(
                  angle: _finalAngle,
                  alignment: Alignment.center,
                  child: Stack(
                    fit: StackFit.passthrough,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: MouseRegion(
                          onEnter: (e) {
                            setState(() {
                              isHover = true;
                            });
                          },
                          onExit: (e) {
                            setState(() {
                              isHover = false;
                            });
                          },
                          child: Container(
                            width: _width,
                            height: _height,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: borderColor, width: 2 / widget.scale),
                            ),
                            child: widget.child,
                          ),
                        ),
                      ),

                      if (!widget.keepRatio) ...[
                        // top center
                        Positioned(
                          top: -4 / widget.scale,
                          left: 0,
                          child: DeferPointer(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeUpDown,
                              child: GestureDetector(
                                onPanStart: (d) {
                                  _onScalingStart();
                                },
                                onPanUpdate: (details) {
                                  _onScaling(details, ScaleDirection.topCenter);
                                },
                                onPanEnd: (details) {
                                  _onScalingEnd(details);
                                },
                                supportedDevices: const {
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.mouse,
                                },
                                child: Container(
                                  height: 9 / widget.scale,
                                  color: Colors.transparent,
                                  width: (_width),
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // bottom center
                        Positioned(
                          bottom: -4 / widget.scale,
                          left: 0,
                          child: DeferPointer(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeUpDown,
                              child: GestureDetector(
                                onPanStart: (d) {
                                  _onScalingStart();
                                },
                                onPanUpdate: (details) {
                                  _onScaling(
                                      details, ScaleDirection.bottomCenter);
                                },
                                onPanEnd: (details) {
                                  _onScalingEnd(details);
                                },
                                supportedDevices: const {
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.mouse,
                                },
                                child: Container(
                                  height: 9 / widget.scale,
                                  color: Colors.transparent,
                                  width: _width,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // center left
                        Positioned(
                          top: 0,
                          left: -4 / widget.scale,
                          child: DeferPointer(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeLeftRight,
                              child: GestureDetector(
                                onPanStart: (d) {
                                  _onScalingStart();
                                },
                                onPanUpdate: (details) {
                                  _onScaling(
                                      details, ScaleDirection.centerLeft);
                                },
                                onPanEnd: (details) {
                                  _onScalingEnd(details);
                                },
                                supportedDevices: const {
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.mouse,
                                },
                                child: Container(
                                  width: 9 / widget.scale,
                                  color: Colors.transparent,
                                  height: (_height),
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // center right
                        Positioned(
                          top: 0,
                          right: -4 / widget.scale,
                          child: DeferPointer(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeLeftRight,
                              child: GestureDetector(
                                onPanStart: (d) {
                                  _onScalingStart();
                                },
                                onPanUpdate: (details) {
                                  _onScaling(
                                      details, ScaleDirection.centerRight);
                                },
                                onPanEnd: (details) {
                                  _onScalingEnd(details);
                                },
                                supportedDevices: const {
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.mouse,
                                },
                                child: Container(
                                  width: 9 / widget.scale,
                                  color: Colors.transparent,
                                  height: _height,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                      // top left
                      Positioned(
                        top: -4 / widget.scale,
                        left: -4 / widget.scale,
                        child: DeferPointer(
                          child: GestureDetector(
                            onPanStart: (d) {
                              _onScalingStart();
                            },
                            onPanUpdate: (details) {
                              _onScaling(details, ScaleDirection.topLeft);
                            },
                            onPanEnd: (details) {
                              _onScalingEnd(details);
                            },
                            supportedDevices: const {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                            child: Container(
                              width: 9 / widget.scale,
                              height: 9 / widget.scale,
                              decoration: buildBorder(
                                Alignment.topLeft,
                                borderColor,
                              ),

                              // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                            ),
                          ),
                        ),
                      ),

                      // top right
                      Positioned(
                        top: -4 / widget.scale,
                        right: -4 / widget.scale,
                        child: DeferPointer(
                          child: GestureDetector(
                            onPanStart: (d) {
                              _onScalingStart();
                            },
                            onPanUpdate: (details) {
                              _onScaling(details, ScaleDirection.topRight);
                            },
                            onPanEnd: (details) {
                              _onScalingEnd(details);
                            },
                            supportedDevices: const {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                            child: Container(
                              width: 9 / widget.scale,
                              height: 9 / widget.scale,
                              decoration:
                                  buildBorder(Alignment.topRight, borderColor),
                            ),
                          ),
                        ),
                      ),

                      // bottom left
                      Positioned(
                        bottom: -4 / widget.scale,
                        left: -4 / widget.scale,
                        child: DeferPointer(
                          child: GestureDetector(
                            onPanStart: (d) {
                              _onScalingStart();
                            },
                            onPanUpdate: (details) {
                              _onScaling(details, ScaleDirection.bottomLeft);
                            },
                            onPanEnd: (details) {
                              _onScalingEnd(details);
                            },
                            supportedDevices: const {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                            child: Container(
                              width: 9 / widget.scale,
                              height: 9 / widget.scale,
                              decoration: buildBorder(
                                  Alignment.bottomLeft, borderColor),
                            ),
                          ),
                        ),
                      ),

                      // bottom right
                      Positioned(
                        bottom: -4 / widget.scale,
                        right: -4 / widget.scale,
                        child: DeferPointer(
                          child: GestureDetector(
                            onPanStart: (d) {
                              _onScalingStart();
                            },
                            onPanUpdate: (details) {
                              _onScaling(details, ScaleDirection.bottomRight);
                            },
                            onPanEnd: (details) {
                              _onScalingEnd(details);
                            },
                            supportedDevices: const {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                            child: Container(
                              width: 9 / widget.scale,
                              height: 9 / widget.scale,
                              decoration: buildBorder(
                                  Alignment.bottomRight, borderColor),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: -20,
                        child: DeferPointer(
                          child: GestureDetector(
                            onPanStart: (details) {
                              _startingAngle = _finalAngle;
                            },
                            onPanUpdate: (details) {
                              final center =
                                  Rect.fromLTWH(0, 0, _width, _height).center;

                              final newAngle = getAngleFromPoints(
                                  center, details.localPosition);
                              setState(() {
                                _finalAngle =
                                    _startingAngle + newAngle + pi / 2;
                              });

                              widget.onChange(_getCurrentBoxInfo);
                            },
                            onPanEnd: (details) {
                              _prevAngle = _finalAngle;
                              widget.onChange(_getCurrentBoxInfo);
                            },
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                    height: 20, width: 2, color: borderColor),
                                MouseRegion(
                                  cursor: SystemMouseCursors.grab,
                                  child: Container(
                                    width: 9,
                                    height: 9,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1.2, color: borderColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration buildBorder(Alignment alignment, Color borderColor) {
    return BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(width: 1.2 / widget.scale, color: borderColor),
    );
  }

  void _onScaling(
    DragUpdateDetails update,
    ScaleDirection scaleDirection,
  ) {
    final ScaleInfo current = ScaleInfo(
      width: _width,
      height: _height,
      x: _x,
      y: _y,
    );
    final double dx = update.delta.dx;
    final double dy = update.delta.dy;

    final ScaleInfoOpt scaleInfoOpt = ScaleInfoOpt(
      scaleDirection: scaleDirection,
      dx: dx,
      dy: dy,
      rotateAngle: _finalAngle,
    );

    final ScaleInfo scaleInfoAfterCalculation = ScaleHelper.getScaleInfo(
      current: current,
      keepAspectRatio: widget.keepRatio,
      options: scaleInfoOpt,
    );

    double updatedWidth = scaleInfoAfterCalculation.width;
    double updatedHeight = scaleInfoAfterCalculation.height;
    double updatedXPosition = scaleInfoAfterCalculation.x;
    double updatedYPosition = scaleInfoAfterCalculation.y;

    if (_isWidthUnderscale(updatedWidth) ||
        _isHeightUnderscale(updatedHeight)) {
      return;
    }

    setState(() {
      _width = updatedWidth;
      _height = updatedHeight;
      _x = updatedXPosition;
      _y = updatedYPosition;
    });

    widget.onChange(_getCurrentBoxInfo);
  }

  bool _isWidthUnderscale(double width) {
    return width <= 0;
  }

  bool _isHeightUnderscale(double height) {
    return height <= 0;
  }

  movableInfo get _getCurrentBoxInfo => movableInfo(
        size: Size(_width, _height),
        position: Offset(_x, _y),
        rotateAngle: _finalAngle,
      );

  void _onScalingEnd(DragEndDetails details) {
    widget.onChangeEnd?.call();
  }

  void _onScalingStart() {
    widget.onChangeStart?.call();
  }

  void _onMoving(DragUpdateDetails update) {
    double updatedXPosition = _x;
    double updatedYPosition = _y;

    updatedXPosition += (update.delta.dx);
    updatedYPosition += (update.delta.dy);

    setState(() {
      _x = updatedXPosition;
      _y = updatedYPosition;
    });

    widget.onChange(_getCurrentBoxInfo);
  }
}

/// Get the angle radian between two points
double getAngleFromPoints(Offset point1, Offset point2) {
  return atan2(point2.dy - point1.dy, point2.dx - point1.dx);
}

/// Rotate a point around an origin by an angle degree
Offset rotatePoint(Offset point, Offset origin, double angle) {
  final cosTheta = cos(angle * pi / 180);
  final sinTheta = sin(angle * pi / 180);

  final oPoint = point - origin;
  final x = oPoint.dx;
  final y = oPoint.dy;

  final newX = x * cosTheta - y * sinTheta;
  final newY = x * sinTheta + y * cosTheta;

  return Offset(newX, newY) + origin;
}
