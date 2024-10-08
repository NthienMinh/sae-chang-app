import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class ImageQuestionRes extends StatelessWidget {
  const ImageQuestionRes({super.key, required this.q, required this.dir});
  final QuestionModel q;
  final String dir;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Resizable.size(context, 150),
        child: ListView.builder(
            itemCount: q.listImage.length,
            scrollDirection: Axis.horizontal,
            padding:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
            itemBuilder: (_, i) => GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed(Routes.fullScreen, arguments: {
                      'imageList': q.listImage,
                      'init': i,
                      'type': "download",
                      'dir': dir
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.only(
                          right: Resizable.padding(context, 10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Resizable.size(context, 10))),
                        child: Stack(
                          children: [
                            Container(
                              width: Resizable.size(context, 200),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(
                                        CustomCheck.getFlashCardImage(
                                            q.listImage[i], dir))),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: primaryColor, width: 2),
                                  color: Colors.black),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                  height: Resizable.size(context, 20),
                                  width: Resizable.size(context, 20),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            Resizable.size(context, 5)),
                                        bottomRight: Radius.circular(
                                            Resizable.size(context, 5))),
                                  ),
                                  child: Center(
                                      child: Icon(
                                    Icons.zoom_in_rounded,
                                    size: Resizable.size(context, 15),
                                    color: Colors.white,
                                  ))),
                            )
                          ],
                        ),
                      )),
                )));
  }
}
