import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/capture_image_cubit.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:image_picker/image_picker.dart';



class ImageItem extends StatelessWidget {
  const ImageItem(
      {super.key,
      required this.questionModel,
      required this.bloc,
      required this.type,
      required this.images,
      required this.captureImageCubit,
      required this.index});

  final QuestionModel questionModel;
  final PracticeBloc bloc;
  final CaptureImageCubit captureImageCubit;
  final String type;
  final List<XFile> images;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topRight, children: [
      GestureDetector(
          onTap: () {
            List<String> listImagePath =
                images.map((element) => element.path.toString()).toList();
            Navigator.of(context, rootNavigator: true)
                .pushNamed(Routes.fullScreen, arguments: {
              'imageList': listImagePath,
              'init': listImagePath.indexOf(images[index].path),
              'type': "device",
              'dir':bloc.dir
            });
          },
          child: Container(
            height: Resizable.height(context) * 0.15,
            width: Resizable.size(context, 150),
            decoration: BoxDecoration(
                border: Border.all(width: 3, color: primaryColor.shade300),
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 15)),
                image: DecorationImage(
                  image: FileImage(File(images[index].path)),
                  fit: BoxFit.cover,
                )),
          )),
      Container(
          height: Resizable.size(context, 30),
          width: Resizable.size(context, 30),
          decoration: BoxDecoration(
            color: primaryColor.shade300,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(Resizable.size(context, 15)),
                bottomLeft: Radius.circular(Resizable.size(context, 15))),
          ),
          child: GestureDetector(
              onTap: () => captureImageCubit.removePhoto(
                  context, images[index], questionModel, bloc, type),
              child: Icon(
                Icons.close_rounded,
                size: Resizable.size(context, 18),
                color: Colors.white,
              )))
    ]);
  }
}
