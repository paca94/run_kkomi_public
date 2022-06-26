import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:run_kkomi/common/custom_text_button.dart';
import 'package:run_kkomi/routes/app_pages.dart';

import '../common/common_scaffold.dart';

class LobbyScreen extends StatelessWidget {
  LobbyScreen({Key? key}) : super(key: key);

  double _width = 0;
  double _height = 0;

  static const double fontSizeMax = 60;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;
    final logoSize = _height / 2 - 100;
    return CommonScaffold(
      child: Container(
        color: Colors.blue,
        child: Stack(
          children: [
            Positioned(
              left: _width / 2 - logoSize / 2,
              top: 75,
              child: Image.asset(
                'assets/images/kkomi-default-stand.gif',
                width: logoSize,
                height: logoSize * 3 / 2,
                fit: BoxFit.fill,
              ),
            ),
            buildButton('Start', _width, _height, 0, () {
              Get.toNamed(Routes.CHARACTER_SELECT);
            }),
          ],
        ),
      ),
    );
  }

  ratioOrMaximum(double ratio, double maximumValue) {
    return _width / ratio < maximumValue ? _width / ratio : maximumValue;
  }

  Positioned buildButton(String text, double width, double height,
      int offsetIdx, GestureTapCallback onTap) {
    final double buttonWidth = ratioOrMaximum(3, 250);
    final double buttonHeight = ratioOrMaximum(5, 100);
    const double fontSize = 32;
    return Positioned(
      left: width / 2 - buttonWidth / 2,
      top: height / 2 + offsetIdx * (buttonHeight + 20),
      child: CustomTextButton(
        text: text,
        width: buttonWidth,
        height: buttonHeight,
        fontSize: fontSize,
        onTap: onTap,
      ),
    );
  }
}
