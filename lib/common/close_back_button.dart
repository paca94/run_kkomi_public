import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:run_kkomi/controller/sound_controller.dart';

class CloseBackButton extends StatelessWidget {
  const CloseBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Card(
        child: InkWell(
          onTap: () {
            SoundController.to.soundManager.click.play();
            Get.back();
          },
          child: const Icon(
            Icons.close,
            size: 32,
          ),
        ),
      ),
    );
  }
}
