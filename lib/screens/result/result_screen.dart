import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/result/answer_cubit.dart';
import 'package:sae_chang/features/result/header_result.dart';
import 'package:sae_chang/features/result/result_item.dart';
import 'package:sae_chang/models/base_model/answer_model.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/services/video_service.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/app_bar_template.dart';



class ResultScreen extends StatefulWidget {
  ResultScreen(
      {super.key,
      required this.id,
      required this.score,
      required this.type,
      required this.resultId,
      required this.isOffline,
      required this.userId,
      required this.classId,
      required this.dataId,
      this.isSubClass = false})
      : soundQuestionCubit = SoundCubit();
  final int id;
  final int resultId;
  final String type;
  final bool isOffline;
  final int dataId;
  final int userId;
  final int classId;
  final SoundCubit soundQuestionCubit;
  final bool isSubClass;
  final dynamic score;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void dispose() {
    MediaService.instance.stop();
    if (VideoService.instance.player != null) {
      VideoService.instance.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarTemplate(
          'CHI TIẾT KẾT QUẢ',
          context,
          actions: const [
            SizedBox(
              width: 60,
            )
          ],
        ),
        body: BlocProvider(
          create: (context) => AnswerCubit(context, widget.id, widget.userId,
              widget.classId, widget.type, widget.isOffline, widget.dataId, widget.resultId),
          child: BlocBuilder<AnswerCubit, List<AnswerModel>?>(
            builder: (c, list) {
              if (list == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final cubit = c.read<AnswerCubit>();
              list.sort((a, b) => a.questionId.compareTo(b.questionId));

              var answers = [...list];
              debugPrint('=>>>>>>> list: ${list.length}');
              return Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    if (!widget.isSubClass)
                      HeaderResult(
                          id: widget.id,
                          dataId: widget.dataId,
                          score: widget.score,
                          cubit: cubit),
                    if (widget.isSubClass)
                      SizedBox(
                        height: Resizable.padding(context, 30),
                      ),
                    ...answers.map((e) => ResultItem(
                          index: answers.indexOf(e),
                          answerModel: e,
                          isOffline: widget.isOffline,
                          soundQuestionCubit: widget.soundQuestionCubit,
                          questionModel: cubit.listQuestions.firstWhere(
                              (element) => element.id == e.questionId), cubit: cubit,
                        )),
                    SizedBox(height: Resizable.size(context, 20))
                  ],
                ),
              );
            },
          ),
        ));
  }
}
