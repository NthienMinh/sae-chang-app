import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/models/skill_models/lesson.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import 'listening_cubit.dart';

class LessonItem extends StatefulWidget {
  const LessonItem({
    super.key,
    required this.lesson,
  });
  final Lesson lesson;

  @override
  State<LessonItem> createState() => _LessonItemState();
}

class _LessonItemState extends State<LessonItem> {
  final soundService = MediaService.instance;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ListeningCubit>();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () async {

          Navigator.pushNamed(context, Routes.practiceListeningDetail,
              arguments: {
                'listeningCubit': cubit,
                'positionNow': Duration.zero,
                'lesson': widget.lesson,
              });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              BlocBuilder<ListeningCubit, int?>(
                bloc: cubit,
                builder: (_, __) {
                  return Center(
                    child: Container(
                      height: Resizable.size(context, 30),
                      width: Resizable.size(context, 30),
                      margin: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 15),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: primaryColor),
                      alignment: Alignment.center,
                      child: Icon(Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: Resizable.size(context, 30)),
                    ),
                  );
                },
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.lesson.mean,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          fontSize: Resizable.font(context, 16),
                        )),
                    SizedBox(
                      height: Resizable.padding(context, 5),
                    ),
                    Text(widget.lesson.title,
                        style: TextStyle(
                            fontSize: Resizable.font(context, 15),
                            color: darkGreyColor)),
                  ],
                ),
              ),
              SizedBox(
                width: Resizable.size(context, 50),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
