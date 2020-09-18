import 'package:bezier/bezier.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

/**
 * @author: Jason
 * @create_at: Sep 11, 2020
 */



class CurveBezier extends Curve {

final quadraticCurve = new QuadraticBezier (
        [new Vector2(-4.0, 1.0), new Vector2(-2.0, -1.0), new Vector2(1.0, 1.0)]);

  @override
  double transformInternal(double t) {
    return quadraticCurve.pointAt(t).s;
  }
}
