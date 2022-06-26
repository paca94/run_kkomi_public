import 'package:flutter/material.dart';
import 'package:run_kkomi/controller/sound_controller.dart';

class CustomTextButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final double? width;
  final double? height;
  final Color? color;
  final String text;
  final double fontSize;

  const CustomTextButton(
      {Key? key,
      required this.onTap,
      this.width,
      this.height,
      this.color,
      required this.text,
      required this.fontSize})
      : super(key: key);

  ratioOrMaximum(
      double width, double height, double ratio, double maximumValue) {
    return width / ratio < maximumValue ? height / ratio : maximumValue;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    late final double buttonWidth;
    late final double buttonHeight;
    if (width == null) {
      buttonWidth = ratioOrMaximum(size.width, size.height, 3, 250);
    } else {
      buttonWidth = width!;
    }
    if (height == null) {
      buttonHeight = ratioOrMaximum(size.width, size.height, 5, 100);
    } else {
      buttonHeight = height!;
    }
    return Card(
      child: InkWell(
        onTap: () {
          SoundController.to.soundManager.click.play();
          onTap();
        },
        child: SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontFamily: 'dalmoori',
                  fontSize: fontSize,
                  color: color ?? Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}
