import 'dart:math';

import 'package:flutter/material.dart';

import '../enums/scale_direction_enum.dart';
import '../models/scale_info.dart';

/// A helper that handles scaling stuff
class ScaleHelper {
  static ScaleInfo getScaleInfo({
    required ScaleInfo current,
    required ScaleInfoOpt options,
    required bool keepAspectRatio,
  }) {
    final double dx = options.dx;
    final double dy = options.dy;
    final double rotateAngle = options.rotateAngle;
    double updatedWidth = current.width;
    double updatedHeight = current.height;
    double updatedXPosition = current.x;
    double updatedYPosition = current.y;

    if (keepAspectRatio) {
      switch (options.scaleDirection) {
        case ScaleDirection.topLeft:
          double newHeightTL = updatedHeight - dy;
          double aspectRatioTL = updatedWidth / updatedHeight;
          double newWidthTL = newHeightTL * aspectRatioTL;

          // Calculate delta values
          double deltaWidthTL = updatedWidth - newWidthTL;
          double deltaHeightTL = updatedHeight - newHeightTL;

          // Update width and height
          updatedWidth = newWidthTL > 0 ? newWidthTL : 0;
          updatedHeight = newHeightTL > 0 ? newHeightTL : 0;

          // left
          var rotationalOffsetTL = Offset(
                  cos(rotateAngle) + 1, // x
                  sin(rotateAngle)) *
              deltaWidthTL /
              2;
          // top
          var rotationalOffset2TL = Offset(
                -sin(rotateAngle),
                cos(rotateAngle) + 1,
              ) *
              deltaHeightTL /
              2;

          updatedXPosition += rotationalOffsetTL.dx + rotationalOffset2TL.dx;
          updatedYPosition += rotationalOffsetTL.dy + rotationalOffset2TL.dy;

          break;
        case ScaleDirection.bottomLeft:
          double aspectRatioBL = updatedWidth / updatedHeight;
          double newHeightBL = updatedHeight + dy;
          double newWidthBL = newHeightBL * aspectRatioBL;
          double deltaBL = updatedWidth - newWidthBL;

          updatedHeight = newHeightBL > 0 ? newHeightBL : 0;
          updatedWidth = newWidthBL > 0 ? newWidthBL : 0;
          // updatedXPosition += deltaBL;

          // left
          var rotationalOffsetBL = Offset(
                cos(rotateAngle) + 1, // x
                sin(rotateAngle), // y
              ) *
              deltaBL /
              2;
          // bottom
          var rotationalOffset2BL = Offset(
                -sin(rotateAngle),
                cos(rotateAngle) - 1,
              ) *
              dy /
              2;

          updatedXPosition += rotationalOffsetBL.dx + rotationalOffset2BL.dx;
          updatedYPosition += rotationalOffsetBL.dy + rotationalOffset2BL.dy;

          break;

        case ScaleDirection.topRight:
          double newHeight = updatedHeight - dy;
          double scale = newHeight / updatedHeight;
          double newWidth = updatedWidth * scale;

          updatedHeight = newHeight > 0 ? newHeight : 0;
          updatedWidth = newWidth > 0 ? newWidth : 0;

          // right
          var rotationalOffset = Offset(
                cos(rotateAngle) - 1, // x
                sin(rotateAngle), // y
              ) *
              dx /
              2;
          // top
          var rotationalOffset2 = Offset(
                -sin(rotateAngle),
                cos(rotateAngle) + 1,
              ) *
              dy /
              2;

          updatedXPosition += rotationalOffset.dx + rotationalOffset2.dx;
          updatedYPosition += rotationalOffset.dy + rotationalOffset2.dy;

          break;

        case ScaleDirection.bottomRight:
          double newHeight = updatedHeight + dy;
          // double newWidth = updatedWidth + dx;
          double scale = newHeight / updatedHeight;

          updatedWidth = updatedWidth * scale;
          updatedHeight = updatedHeight * scale;

          // right
          var rotationalOffset = Offset(
                cos(rotateAngle) - 1, // x
                sin(rotateAngle), // y
              ) *
              dx /
              2;
          // bottom
          var rotationalOffset2 = Offset(
                -sin(rotateAngle),
                cos(rotateAngle) - 1,
              ) *
              dy /
              2;

          updatedXPosition += rotationalOffset.dx + rotationalOffset2.dx;
          updatedYPosition += rotationalOffset.dy + rotationalOffset2.dy;

          break;

        default:
          break;
      }

      return ScaleInfo(
        width: updatedWidth,
        height: updatedHeight,
        x: updatedXPosition,
        y: updatedYPosition,
      );
    }

    ///
    /// Rotational offset
    /// - Fix x, y position after scaling if rotated
    ///
    /// https://stackoverflow.com/a/73930511
    /// Author: @Steve
    ///
    switch (options.scaleDirection) {
      case ScaleDirection.centerLeft:
        double newWidth = updatedWidth - dx;

        updatedWidth = newWidth > 0 ? newWidth : 0;

        // left
        var rotationalOffset = Offset(
              cos(rotateAngle) + 1, // x
              sin(rotateAngle), // y
            ) *
            dx /
            2;
        updatedXPosition += rotationalOffset.dx;
        updatedYPosition += rotationalOffset.dy;

        break;

      case ScaleDirection.centerRight:
        double newWidth = updatedWidth + dx;
        updatedWidth = newWidth > 0 ? newWidth : 0;

        // right
        var rotationalOffset = Offset(
              cos(rotateAngle) - 1, // x
              sin(rotateAngle), // y
            ) *
            dx /
            2;
        updatedXPosition += rotationalOffset.dx;
        updatedYPosition += rotationalOffset.dy;

        break;
      case ScaleDirection.topLeft:
        double newHeight = updatedHeight -= dy;
        double newWidth = updatedWidth - dx;

        updatedHeight = newHeight > 0 ? newHeight : 0;
        updatedWidth = newWidth > 0 ? newWidth : 0;

        // left
        var rotationalOffset = Offset(
              cos(rotateAngle) + 1, // x
              sin(rotateAngle), // y
            ) *
            dx /
            2;
        // top
        var rotationalOffset2 = Offset(
              -sin(rotateAngle),
              cos(rotateAngle) + 1,
            ) *
            dy /
            2;

        updatedXPosition += rotationalOffset.dx + rotationalOffset2.dx;
        updatedYPosition += rotationalOffset.dy + rotationalOffset2.dy;

        break;

      case ScaleDirection.topCenter:
        double newHeight = updatedHeight -= dy;
        updatedHeight = newHeight > 0 ? newHeight : 0;

        // top
        var rotationalOffset = Offset(
              -sin(rotateAngle),
              cos(rotateAngle) + 1,
            ) *
            dy /
            2;

        updatedXPosition += rotationalOffset.dx;
        updatedYPosition += rotationalOffset.dy;

        break;

      case ScaleDirection.topRight:
        double newHeight = updatedHeight -= dy;
        double newWidth = updatedWidth + dx;

        updatedHeight = newHeight > 0 ? newHeight : 0;
        updatedWidth = newWidth > 0 ? newWidth : 0;

        // right
        var rotationalOffset = Offset(
              cos(rotateAngle) - 1, // x
              sin(rotateAngle), // y
            ) *
            dx /
            2;
        // top
        var rotationalOffset2 = Offset(
              -sin(rotateAngle),
              cos(rotateAngle) + 1,
            ) *
            dy /
            2;

        updatedXPosition += rotationalOffset.dx + rotationalOffset2.dx;
        updatedYPosition += rotationalOffset.dy + rotationalOffset2.dy;

        break;

      case ScaleDirection.bottomLeft:
        double newHeight = updatedHeight + dy;
        double newWidth = updatedWidth - dx;

        updatedWidth = newWidth > 0 ? newWidth : 0;
        updatedHeight = newHeight > 0 ? newHeight : 0;

        // left
        var rotationalOffset = Offset(
              cos(rotateAngle) + 1, // x
              sin(rotateAngle), // y
            ) *
            dx /
            2;
        // bottom
        var rotationalOffset2 = Offset(
              -sin(rotateAngle),
              cos(rotateAngle) - 1,
            ) *
            dy /
            2;

        updatedXPosition += rotationalOffset.dx + rotationalOffset2.dx;
        updatedYPosition += rotationalOffset.dy + rotationalOffset2.dy;

        break;
      case ScaleDirection.bottomCenter:
        double newHeight = updatedHeight + dy;
        updatedHeight = newHeight > 0 ? newHeight : 0;

        // bottom
        var rotationalOffset = Offset(
              -sin(rotateAngle),
              cos(rotateAngle) - 1,
            ) *
            dy /
            2;

        updatedXPosition += rotationalOffset.dx;
        updatedYPosition += rotationalOffset.dy;

        break;
      case ScaleDirection.bottomRight:
        double newHeight = updatedHeight + dy;
        double newWidth = updatedWidth + dx;

        // right
        var rotationalOffset = Offset(
              cos(rotateAngle) - 1, // x
              sin(rotateAngle), // y
            ) *
            dx /
            2;
        // bottom
        var rotationalOffset2 = Offset(
              -sin(rotateAngle),
              cos(rotateAngle) - 1,
            ) *
            dy /
            2;

        updatedXPosition += rotationalOffset.dx + rotationalOffset2.dx;
        updatedYPosition += rotationalOffset.dy + rotationalOffset2.dy;
        updatedWidth = newWidth > 0 ? newWidth : 0;
        updatedHeight = newHeight > 0 ? newHeight : 0;

        break;
      default:
    }

    return ScaleInfo(
      width: updatedWidth,
      height: updatedHeight,
      x: updatedXPosition,
      y: updatedYPosition,
    );
  }
}
