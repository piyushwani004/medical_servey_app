import "package:flutter/material.dart";
import 'package:medical_servey_app/widgets/common.dart';

class TopSliverAppBar extends StatelessWidget {
  final String text;
  final double mHeight;
  final Function? onPressedLogout;

  const TopSliverAppBar(
      {Key? key,
      required this.mHeight,
      required this.text,
      this.onPressedLogout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      centerTitle: true,
      title: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      elevation: 5,
      expandedHeight: mHeight * 0.08,
      forceElevated: true,
      actions: onPressedLogout != null
          ? [
              Padding(
                padding: EdgeInsetsDirectional.all(mHeight * 0.019),
                child: OutlinedButton(
                  //logging out
                  onPressed: () {
                    onPressedLogout!();
                  },

                  child: const Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.black,
                  ),
                  style: Common.buttonStyle(),
                ),
              ),
            ]
          : [],
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
      {Key? key, this.style, required this.text, required this.gradient})
      : super(key: key);
  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
