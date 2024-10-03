import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:simple_shadow/simple_shadow.dart';

class FloatActionBoard extends StatelessWidget {
  const FloatActionBoard(
      {super.key,
        this.onLearn,
        this.onFlashcard,
        this.onPractice,
        this.onVideo,
        this.onMultipleChoice,
        this.onChallenge1,
        this.onChallenge2,
        this.onDetail,
        this.onDraw,
        this.showFloatIcon = true,
        this.onChallenge});

  final Function()? onLearn;
  final Function()? onFlashcard;
  final Function()? onPractice;
  final Function()? onVideo;
  final Function()? onMultipleChoice;
  final Function()? onChallenge1;
  final Function()? onChallenge2;
  final Function()? onDetail;
  final Function()? onDraw;
  final Function()? onChallenge;
  final bool showFloatIcon;

  @override
  Widget build(BuildContext context) {
    var list = [
      // if (onLearn != null)
      //   KnowledgePracticeModel(
      //       title: AppStudentText.txtLearn.text,
      //       icon: 'assets/icons/ic_home_course_1y.png',
      //       onPressed: onLearn!),
      // if (onDetail != null)
      //   KnowledgePracticeModel(
      //       title: AppStudentText.txtDetail.text,
      //       icon: 'assets/icons/ic_home_detail.png',
      //       onPressed: onDetail!),
      // if (onDraw != null)
      //   KnowledgePracticeModel(
      //       title: AppStudentText.titlePracticeDrawing.text,
      //       icon: 'assets/icons/ic_home_jlpt_3x.png',
      //       onPressed: onDraw!),
      if (onFlashcard != null)
        KnowledgePracticeModel(
            title: AppText.txtFlashcard.text,
            icon: 'assets/icons/ic_home_flashcard.png',
            onPressed: onFlashcard!),
      // if (onVideo != null)
      //   KnowledgePracticeModel(
      //       title: AppStudentText.txtFloatLecture.text,
      //       icon: 'assets/icons/ic_home_video.png',
      //       onPressed: onVideo!),
      // if (onMultipleChoice != null)
      //   KnowledgePracticeModel(
      //     title: AppStudentText.txtMultipleChoice.text,
      //     icon: 'assets/icons/ic_home_test_white.png',
      //     onPressed: onMultipleChoice!,
      //   ),
      // if (onChallenge1 != null)
      //   KnowledgePracticeModel(
      //     title: AppStudentText.txtChallenge1.text,
      //     icon: 'assets/icons/ic_home_practice.png',
      //     onPressed: onChallenge1!,
      //   ),
      // if (onChallenge2 != null)
      //   KnowledgePracticeModel(
      //       title: AppStudentText.txtChallenge2.text,
      //       icon: 'assets/icons/ic_home_practice.png',
      //       onPressed: onChallenge2!),
      // if (onPractice != null)
      //   KnowledgePracticeModel(
      //     title: AppStudentText.txtPractice.text,
      //     icon: 'assets/icons/ic_home_practice.png',
      //     onPressed: onPractice!,
      //   ),
      // if (onChallenge != null)
      //   KnowledgePracticeModel(
      //       title: AppStudentText.txtChallenge.text,
      //       icon: 'assets/icons/ic_home_practice.png',
      //       onPressed: onChallenge!),
    ];
    return list.isEmpty
        ? Container()
        : !showFloatIcon
        ? KnowledgePracticeBoard(
        onTap: () => Navigator.pop(context),
        list: list)
        : Align(
      alignment: Alignment.bottomCenter,
      child: BlocProvider(
          create: (context) => PracticeBoardCubit(true),
          child: BlocBuilder<PracticeBoardCubit, bool>(
            builder: (c, s) => Stack(
              children: [
                s
                    ? KnowledgePracticeBoard(
                    onTap: () =>
                        BlocProvider.of<PracticeBoardCubit>(c)
                            .change(),
                    list: list)
                    : Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingButton(
                      onPressed: () =>
                          BlocProvider.of<PracticeBoardCubit>(c)
                              .change()),
                )
              ],
            ),
          )),
    );
  }
}

class PracticeBoardCubit extends Cubit<bool> {
  PracticeBoardCubit(this.isShow) : super(isShow);
  final bool isShow;

  change() => emit(!state);
}

class KnowledgePracticeModel {
  final String title;
  final String icon;
  final Function() onPressed;

  KnowledgePracticeModel(
      {required this.title, required this.icon, required this.onPressed});
}

class FloatingButton extends StatelessWidget {
  final Function() onPressed;
  const FloatingButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: primaryColor,
      margin: EdgeInsets.only(
          bottom: Resizable.padding(context, 20),
          right: Resizable.padding(context, 20)),
      elevation: Resizable.size(context, 5),
      shadowColor: primaryColor,
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.white, width: Resizable.size(context, 2)),
          borderRadius: BorderRadius.circular(Resizable.padding(context, 15))),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(Resizable.padding(context, 15)),
        child: Padding(
          padding: EdgeInsets.all(Resizable.padding(context, 10)),
          child: Icon(
            Icons.menu_rounded,
            size: Resizable.size(context, 36),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class KnowledgePracticeBoard extends StatelessWidget {
  final List<KnowledgePracticeModel> list;
  final Function() onTap;
  const KnowledgePracticeBoard(
      {required this.list,
        required this.onTap,
        super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          color: primaryColor,
          shadowColor: primaryColor,
          elevation: 5,
          margin: EdgeInsets.symmetric(
            horizontal: Resizable.borderPadding(
                context, Resizable.isTablet(context) ? 50 : 30),
            vertical: Resizable.padding(context, 30),
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: primaryColor.withOpacity(.5),
                width: Resizable.size(context, 1)),
            borderRadius: BorderRadius.circular(
              Resizable.size(context, 30),
            ),
          ),
          child: Stack(
            children: [
              Container(
                  margin: EdgeInsets.only(top: Resizable.padding(context, 10)),
                  child: list.length > 2
                      ? GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(
                      Resizable.padding(context, 10),
                    ),
                    clipBehavior: Clip.none,
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: <Widget>[
                      ...list.map((e) => KnowledgePracticeBoardItem(e))
                    ],
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: <Widget>[
                        ...list.map((e) =>
                            Expanded(child: KnowledgePracticeBoardItem(e)))
                      ],
                    ),
                  )),

              Align(
                alignment: Alignment.topRight,
                child: Card(
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.white, width: Resizable.size(context, 1)),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(
                        Resizable.size(context, 30),
                      ),
                      bottomLeft: Radius.circular(
                        Resizable.size(context, 30),
                      ),
                    ),
                  ),
                  shadowColor: Colors.black,
                  elevation: Resizable.size(context, 15),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(
                        Resizable.size(context, 30),
                      ),
                      bottomLeft: Radius.circular(
                        Resizable.size(context, 30),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Resizable.padding(context, 10),
                        horizontal: Resizable.padding(context, 20),
                      ),
                      child: Icon(
                        Icons.close,
                        color: primaryColor,
                        size: Resizable.size(context, 17),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class KnowledgePracticeBoardItem extends StatelessWidget {
  final KnowledgePracticeModel model;
  const KnowledgePracticeBoardItem(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            iconSize: Resizable.size(context, 60),
            icon: SimpleShadow(
              child: Image.asset(
                model.icon,
                color: Colors.white,
                fit: BoxFit.cover,
              ),
            ),
            onPressed: model.onPressed),
        AutoSizeText(
          model.title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          minFontSize: 10,
          style: TextStyle(
            shadows: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: Resizable.size(context, 3),
                  offset: const Offset(2, 2))
            ],
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: Resizable.font(context, 14),
          ),
        ),
      ],
    );
  }
}