import 'package:flutter/material.dart';
import 'package:flutter_app/common/style/gsy_style.dart';

class GSYUserIconWidget extends StatelessWidget {
  final String image;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;

  GSYUserIconWidget(
      {this.image,
      this.onPressed,
      this.width = 30.0,
      this.height = 30.0,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return new RawMaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding:
            padding ?? const EdgeInsets.only(top: 4.0, right: 5.0, left: 5.0),
        constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        child: new ClipOval(
          child: FadeInImage(
            placeholder: AssetImage(
              GSYICons.DEFAULT_USER_ICON,
            ),
            image: NetworkImage(image),
            //预览图
            fit: BoxFit.fitWidth,
            width: width,
            height: height,
          ),
        ),
        onPressed: onPressed);
  }
}