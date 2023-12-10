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
                sin(rotateAngle),
              ) *
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
          double deltaBL = updatedHeight - newHeightBL;

          updatedHeight = newHeightBL > 0 ? newHeightBL : 0;
          updatedWidth = newWidthBL > 0 ? newWidthBL : 0;

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

        case ScaleDirection.bottomRight:
          double newHeightBR = updatedHeight + dy;
          double aspectRatioBR = updatedWidth / updatedHeight;
          double newWidthBR = newHeightBR * aspectRatioBR;
          double deltaBR = newWidthBR - updatedWidth;

          updatedWidth = newWidthBR > 0 ? newWidthBR : 0;
          updatedHeight = newHeightBR > 0 ? newHeightBR : 0;

          // right
          var rotationalOffsetBR = Offset(
                cos(rotateAngle) - 1, // x
                sin(rotateAngle), // y
              ) *
              deltaBR /
              2;
          // bottom
          var rotationalOffset2BR = Offset(
                -sin(rotateAngle),
                cos(rotateAngle) - 1,
              ) *
              dy /
              2;

          updatedXPosition += rotationalOffsetBR.dx + rotationalOffset2BR.dx;
          updatedYPosition += rotationalOffsetBR.dy + rotationalOffset2BR.dy;

          break;

        case ScaleDirection.topRight:
          double newHeightBR = updatedHeight - dy;
          double aspectRatioBR = updatedWidth / updatedHeight;
          double newWidthBR = newHeightBR * aspectRatioBR;
          double deltaBR = newWidthBR - updatedWidth;

          updatedWidth = newWidthBR > 0 ? newWidthBR : 0;
          updatedHeight = newHeightBR > 0 ? newHeightBR : 0;

          // right
          var rotationalOffset = Offset(
                cos(rotateAngle) - 1, // x
                sin(rotateAngle), // y
              ) *
              deltaBR /
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

    // // is circle, scale from center
    // if (options.shape == Shape.circle) {
    //   updatedHeight = updatedWidth;
    //   switch (options.scaleDirection) {
    //     case ScaleDirection.topLeft:
    //       final double mid = (dx + dy) / 2;

    //       updatedWidth = updatedWidth - 2 * mid;
    //       updatedHeight = updatedHeight - 2 * mid;
    //       updatedXPosition = updatedXPosition + mid;
    //       updatedYPosition = updatedYPosition + mid;
    //       break;
    //     case ScaleDirection.bottomLeft:
    //       final double mid = ((dx * -1) + dy) / 2;

    //       updatedHeight = updatedHeight + 2 * mid;
    //       updatedWidth = updatedWidth + 2 * mid;
    //       updatedXPosition -= mid;
    //       updatedYPosition -= mid;
    //       break;

    //     case ScaleDirection.topRight:
    //       final double mid = (dx + (dy * -1)) / 2;

    //       updatedWidth = updatedWidth + 2 * mid;
    //       updatedHeight = updatedHeight + 2 * mid;
    //       updatedXPosition -= mid;
    //       updatedYPosition -= mid;
    //       break;
    //     case ScaleDirection.bottomRight:
    //       final double mid = (dx + dy) / 2;

    //       updatedHeight = updatedHeight + 2 * mid;
    //       updatedWidth = updatedWidth + 2 * mid;
    //       updatedXPosition -= mid;
    //       updatedYPosition -= mid;
    //       break;

    //     default:
    //   }

    //   return ScaleInfo(
    //     width: updatedWidth > 0 ? updatedWidth : 0,
    //     height: updatedHeight > 0 ? updatedHeight : 0,
    //     x: updatedXPosition,
    //     y: updatedYPosition,
    //   );
    // }

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
