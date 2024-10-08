
import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/practice/record/device_sounder.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/resizable_utils.dart';


class TeacherNoteResult extends StatelessWidget {
  const TeacherNoteResult(
      {super.key,
      required this.answerModel,
      required this.questionModel,
      required this.soundCubit, required this.dir});

  final AnswerModel answerModel;
  final QuestionModel questionModel;
  final SoundCubit soundCubit;
  final String dir;

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '=>>>>>>>>>>>>>>>answerModel: ${answerModel.questionId}${answerModel.records.length}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (answerModel.teacherNote.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Resizable.padding(context, 30),
              vertical: Resizable.padding(context, 5),
            ),
            child: Text(answerModel.teacherNote,
                style: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
          ),
        if (answerModel.images.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Resizable.padding(context, 30),
              vertical: Resizable.padding(context, 5),
            ),
            child: Text("Chú thích ảnh: ",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
          ),
          SizedBox(
              height: Resizable.size(context, 150),
              child: ListView.builder(
                  itemCount: answerModel.images.length,
                  scrollDirection: Axis.horizontal,
                  padding:
                      EdgeInsets.only(left: Resizable.padding(context, 30)),
                  itemBuilder: (_, i) => GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(Routes.fullScreen, arguments: {
                            'imageList': answerModel.images
                                .map((e) => e.toString())
                                .toList(),
                            'init': i,
                            'type': "network",
                            'dir':dir
                          });
                        },
                        child: Container(
                          width: Resizable.size(context, 150),
                          margin: EdgeInsets.only(
                              right: Resizable.padding(context, 10)),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      answerModel.images[i].toString())),
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(
                                  Resizable.size(context, 20))),
                        ),
                      ))),
        ],
        if (answerModel.records.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Resizable.padding(context, 30),
              vertical: Resizable.padding(context, 5),
            ),
            child: Text("Chú thích record: ",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
          ),
          ...answerModel.records.map((e) => Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.size(context, 30),
                  vertical: Resizable.size(context, 5)),
              child: TeacherSounder(
                e.toString(),
                'network',
                answerModel.records.indexOf(e),
                size: Resizable.size(context, 20),
                elevation: 0,
                iconColor: primaryColor,
                backgroundColor: Colors.white,

                soundCubit: soundCubit,
                type: 1,
              )))
        ],
      ],
    );
  }
}
