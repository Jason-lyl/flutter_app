import 'package:flutter/material.dart';

/**
 * @author: Jason
 * @create_at: Sep 10, 2020
 */


///动画大小变化打开的路由
class SizeRoute extends PageRouteBuilder {
  final Widget widget;

  SizeRoute({this.widget})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              widget,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Align(
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
            ),
          ),
        );
}

class NoAnimationRoute extends PageRouteBuilder {
  final Widget widget;

  NoAnimationRoute({this.widget})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              widget,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(0.0, 0.0),
              end: const Offset(0.0, 0.0),
            ).animate(animation),
            child: child,
          ),
        );
}