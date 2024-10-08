import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/capture_image_cubit.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/practice/multiple_choice/multiple_choice_view.dart';
import 'package:sae_chang/features/practice/record/normal_record/sounder.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/custom_padding.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/custom_dialog.dart';
import 'package:sae_chang/widgets/custom_scroll_bar.dart';
import 'package:sae_chang/widgets/loading_progress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sae_chang/widgets/next_back_widget.dart';

import '../multiple_choice/image_list.dart';
import '../paragraph_view.dart';
import '../question_custom.dart';
import 'image_item.dart';

class ImageQuestionView extends StatelessWidget {
  final QuestionModel questionModel;
  final CaptureImageCubit captureImageCubit;
  final PracticeBloc bloc;
  final String type;

  ImageQuestionView(
      {super.key,
      required this.questionModel,
      required this.bloc,
      required this.type})
      : captureImageCubit = CaptureImageCubit();

  @override
  Widget build(BuildContext context) {
    List<XFile> listImage = [];
    if (questionModel.answered.isNotEmpty) {
      for (var element in questionModel.answered) {
        listImage.add(XFile(element));
      }
    }
    ListPathCubit soundsCubit = ListPathCubit(questionModel.listSound);
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Card(
            elevation: 5,
            margin: CustomPadding.questionCardPadding(context),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 20)),
                side: const BorderSide(color: Color(0xffE0E0E0), width: 1)),
            child: Center(
              child: CustomScrollBar(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (questionModel.question != "")
                      QuestionCustom(
                        question: questionModel.question,
                      ),
                    if (questionModel.image != "")
                      Padding(
                          padding: EdgeInsets.only(
                              top: Resizable.padding(context, 30)),
                          child: ImageList(questionModel.listImage, dir: bloc.dir)),
                    if (questionModel.sound != "")
                      BlocBuilder<ListPathCubit, String>(
                          bloc: soundsCubit..load(),
                          builder: (_, String sound) {
                            return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.padding(context, 30),
                                    vertical: Resizable.padding(context, 5)),
                                child: Column(
                                  children: [
                                    BlocProvider(
                                      key: Key(questionModel.id.toString()),
                                      create: (context) => SoundCubit(),
                                      child: BlocBuilder<SoundCubit, double>(
                                        builder: (context, state) {
                                          final SoundCubit soundCubit =
                                          context.read<SoundCubit>();
                                          return Sounder1(
                                            CustomCheck.getAudioLink(sound, bloc.dir),
                                            iconColor: primaryColor,
                                            size: 20,
                                            q: questionModel,
                                            soundCubit: soundCubit,
                                            soundType: 'download',
                                          );
                                        },
                                      ),
                                    ),
                                    if (questionModel.listSound.length > 1)
                                      NextBackWidget(() {
                                        soundsCubit.next();
                                      }, () {
                                        soundsCubit.prev();
                                      },
                                          text:
                                          '${soundsCubit.index + 1}/${soundsCubit.size}'),
                                  ],
                                ));
                          }),
                    if (questionModel.paragraph != "") ...[
                      ParagraphView(questionModel: questionModel)
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: LayoutBuilder(builder: (context, height) {
            return Column(
              children: [
                BlocBuilder<CaptureImageCubit, List<XFile>>(
                    bloc: captureImageCubit..load(listImage),
                    builder: (c, images) {
                      return Container(
                          height: height.maxHeight - Resizable.height(context) * 0.05,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/icons/ic_bg_upload_image.png'))),
                          padding:
                              EdgeInsets.all(Resizable.padding(context, 20)),
                          margin: CustomPadding.questionCardPadding(context).copyWith(
                              top: Resizable.padding(context, 20)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (images.isNotEmpty)
                                SizedBox(
                                    height: Resizable.height(context) * 0.15,
                                    child: ListView.builder(
                                      itemCount: images.length,
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              Resizable.padding(context, 5)),
                                      itemBuilder: (_, i) => Padding(
                                          padding: EdgeInsets.only(
                                              right: Resizable.padding(
                                                  context, 10)),
                                          child: ImageItem(
                                            index: i,
                                            bloc: bloc,
                                            type: type,
                                            captureImageCubit: captureImageCubit,
                                            images: images,
                                            questionModel: questionModel,
                                          )),
                                    )),
                              if (captureImageCubit.isTaking)
                                const LoadingProgress(),
                              if (!captureImageCubit.isTaking && images.isEmpty)
                                GestureDetector(
                                  onTap: () {
                                    onShowDialog(context);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/ic_upload_image.png',
                                        color: primaryColor,
                                        height: Resizable.size(context, 60),
                                        fit: BoxFit.fill,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text('Tải ảnh lên tại đây',
                                          style: TextStyle(
                                              color: primaryColor.shade300,
                                              fontSize:
                                                  Resizable.font(context, 14),
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              if (!captureImageCubit.isTaking &&
                                  images.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      onShowDialog(context);
                                    },
                                    child: Text('Tải thêm ảnh tại đây',
                                        style: TextStyle(
                                            color: primaryColor.shade300,
                                            fontSize:
                                                Resizable.font(context, 14),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                            ],
                          ));
                    }),
              ],
            );
          }),
        )
      ],
    );
  }

  void onShowDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ChooseImageDialog(
            openCamera: () {
              Navigator.of(context).pop();
              captureImageCubit.takePhoto(
                  context,
                  ImageSource.camera,
                  questionModel,
                  bloc,
                  type);
            },
            openGallery: () {
              Navigator.of(context).pop();
              captureImageCubit.takePhoto(
                  context,
                  ImageSource.gallery,
                  questionModel,
                  bloc,
                  type);
            },
          );
        });
  }
}

