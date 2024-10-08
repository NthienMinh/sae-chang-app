import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/connect_cubit.dart';
import 'package:sae_chang/models/base_model/user_class.dart';
import 'package:sae_chang/providers/cache_data/cache_data_provider.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/item_shimmer.dart';
import 'package:shimmer/shimmer.dart';

import 'item_lesson.dart';
import 'lessons_cubit.dart';

class LessonsView extends StatelessWidget {
  LessonsView({super.key, required this.userClass})
      : listLessonsCubit = LessonsCubit(userClass);
  final UserClassModel userClass;
  final LessonsCubit listLessonsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonsCubit, int>(
      bloc: listLessonsCubit..load(),
      builder: (c, state) {
        return RefreshIndicator(
          onRefresh: () async {
            if (ConnectCubit.instance.state) {
              await CacheDataProvider.clearAllKey();
              listLessonsCubit.load();
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: Resizable.padding(context, 20),
                ),
                Builder(builder: (context) {
                  if (state == 0) {
                    final shimmerList = List.generate(10, (index) => index);
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...shimmerList.map((e) {
                              return const ItemShimmer();
                            })
                          ],
                        ),
                      ),
                    );
                  }
                  final listBase = listLessonsCubit.lessons!;
                  return listBase.isEmpty && !ConnectCubit.instance.state
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Resizable.padding(context, 10)),
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              AppText.txtListLessonEmptyWhenNotConnect.text,
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 20)),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            ...listBase.map(
                              (e) => ItemLesson(
                                listBase.indexOf(e) + 1,
                                listLessonsCubit.getLessonResult(e.lessonId) ==
                                        null
                                    ? 'Pending'
                                    : listLessonsCubit
                                        .getLessonResult(e.lessonId)!
                                        .status,
                                listLessonsCubit.getStdLesson(e.lessonId),
                                false,
                                lesson: e,
                                classId: userClass.classId,
                                reload: () async {
                                  await CacheDataProvider.clearAllKey();
                                  await listLessonsCubit.load();
                                },
                                level:
                                    (listBase.indexOf(e) + 1) < 10 ? "0${listBase.indexOf(e) + 1}" :
                                        "${listBase.indexOf(e) + 1}"
                                      .toString(),
                                userClass: userClass,
                                classModel: listLessonsCubit.classModel!,
                              ),
                            ),
                          ],
                        );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
