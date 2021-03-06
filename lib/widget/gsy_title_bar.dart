import 'package:flutter/material.dart';

/**
 * @author: Jason
 * @create_at: Sep 22, 2020
 */

class GSYTitleBar extends StatelessWidget {
  final String title;
  final IconData iconData;
  final ValueChanged onRigintIconPressed;
  final bool needRightLocalIcon;
  final Widget rightWidget;
  final GlobalKey rightKey = GlobalKey();

  GSYTitleBar(this.title,
      {this.iconData,
      this.onRigintIconPressed,
      this.needRightLocalIcon = false,
      this.rightWidget});
  @override
  Widget build(BuildContext context) {
    Widget widget = rightWidget;
    if (rightWidget == null) {
      widget = (needRightLocalIcon)
          ? new IconButton(
              icon: new Icon(iconData, key: rightKey, size: 19.0),
              onPressed: () {
                RenderBox renderBox2 =
                    rightKey.currentContext?.findRenderObject();
                var position = renderBox2.localToGlobal(Offset.zero);
                var size = renderBox2.size;
                var centerPosition = Offset(
                  position.dx + size.width / 2,
                  position.dy + size.height / 2,
                );
                onRigintIconPressed?.call(centerPosition);
              })
          : new Container();
    }
    return Container(
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          widget
        ],
      ),
    );
  }
}
