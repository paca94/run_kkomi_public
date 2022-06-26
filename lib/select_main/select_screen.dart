import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:run_kkomi/common/close_back_button.dart';
import 'package:run_kkomi/common/custom_text_button.dart';
import 'package:run_kkomi/controller/sound_controller.dart';
import 'package:run_kkomi/data/consts.dart';
import 'package:run_kkomi/routes/app_pages.dart';
import 'package:run_kkomi/select_main/select_controller.dart';

class SelectScreen extends GetView<SelectController> {
  const SelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CloseBackButton(),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: Card(
                child: ListView.builder(
                  itemCount: Consts.characterInfoList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final currentInfo = Consts.characterInfoList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CharacterBox(
                        idx: currentInfo.idx,
                        name: currentInfo.name,
                        description: currentInfo.description,
                        characterImage: Image.asset(
                          currentInfo.selectorImagePath,
                          width: min(size.width - 100, size.height / 2 - 100),
                          height: min(size.width - 100, size.height / 2 - 120),
                        ),
                        onSelectCharacterImage: Image.asset(
                          currentInfo.onSelectorImagePath,
                          width: min(size.width - 100, size.height / 2 - 100),
                          height: min(size.width - 100, size.height / 2 - 120),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Obx(
                () => CustomTextButton(
                  text: '게임 시작',
                  fontSize: 32,
                  color: controller.selectedUnit != -1 ? null : Colors.blueGrey,
                  onTap: () {
                    if (controller.selectedUnit != -1) {
                      Get.offAndToNamed(Routes.GAME);
                    } else {
                      Get.snackbar('', '캐릭터를 선택해야 시작할 수 있습니다.');
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterBox extends GetView<SelectController> {
  final int idx;
  final Image characterImage;
  final Image onSelectCharacterImage;
  final String name;
  final String description;

  const CharacterBox(
      {Key? key,
      required this.idx,
      required this.characterImage,
      required this.onSelectCharacterImage,
      required this.name,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        SoundController.to.soundManager.click.play();
        if (controller.selectedUnit == idx) {
          controller.selectedUnit = -1;
        } else {
          controller.selectedUnit = idx;
        }
      },
      child: Card(
        child: Obx(
          () => Container(
            width: characterImage.width,
            padding: const EdgeInsets.all(8.0),
            color: controller.selectedUnit == idx
                ? Colors.blue
                : Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Container(
                    color: Colors.lightBlueAccent,
                    padding: const EdgeInsets.all(8.0),
                    child: controller.selectedUnit == idx
                        ? onSelectCharacterImage
                        : characterImage,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Card(
                    child: Container(
                      width: characterImage.width,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '[$name] $description',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
