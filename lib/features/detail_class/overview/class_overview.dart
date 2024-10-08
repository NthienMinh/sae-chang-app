import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/connect_cubit.dart';
import 'package:sae_chang/features/home/user_class_cubit.dart';
import 'package:sae_chang/models/base_model/user_class.dart';
import 'package:sae_chang/providers/cache_data/cache_data_provider.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import 'class_overview_cubit.dart';
import 'item_in_overview.dart';
import 'progress_circle_overview.dart';

class ClassOverview extends StatelessWidget {
  ClassOverview({super.key, required this.userClass})
      : cubit = ClassOverviewCubit(userClass);
  final UserClassModel userClass;
  final ClassOverviewCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassOverviewCubit, int>(
      key: Key(ConnectCubit.instance.state.toString()),
      bloc: cubit..load(),
      builder: (context, state) {
        // var classModel = UserClassCubit.instance.getClass(userClass.classId);
        var mapItems = [
          {
            'isScore': false,
            'title': AppText.txtPercentAttendance.text.toUpperCase(),
            'icon': 'assets/icons/ic_learn_5.png',
            'progress': cubit.attendPercent,
          },
          {
            'isScore': false,
            'title': AppText.txtPercentBTVN.text.toUpperCase(),
            'icon': 'assets/icons/ic_home.png',
            'progress': cubit.homeworkPercent,
          },
          {
            'isScore': true,
            'title': AppText.txtScoreBTVN.text.toUpperCase(),
            'icon': 'assets/icons/ic_learn_4.png',
            'progress': cubit.avgScoreHomeWork,
          },
          {
            'isScore': true,
            'title': AppText.txtScoreTest.text.toUpperCase(),
            'icon': 'assets/icons/ic_learn_3.png',
            'progress': cubit.avgScoreTest,
          },
        ];
        if (cubit.classModel != null && cubit.classModel!.subClassId != -1) {
          mapItems.add(
            {
              'isScore': false,
              'title': cubit.titleElective,
              'icon': 'assets/icons/ic_learn_2.png',
              'progress': cubit.subClassPercent,
            },
          );
        }
        return Stack(
          children: [
            Scaffold(
              body: RefreshIndicator(
                  onRefresh: () async {
                    if (ConnectCubit.instance.state) {
                      await CacheDataProvider.clearAllKey();
                      cubit.load();
                    }
                  },
                  child: SingleChildScrollView(
                    physics:const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Center(
                            child: ProgressCircleOverView(
                          cubit: cubit,
                        )),
                        SizedBox(
                          height: Resizable.padding(context, 20),
                        ),
                        ...mapItems.map((e) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: Resizable.padding(context, 4),
                              left: Resizable.padding(context, 20),
                              right: Resizable.padding(context, 20),
                            ),
                            child: ItemInOverView(
                                title: e['title'] as String,
                                icon: e['icon'] as String,
                                isScore: e['isScore'] as bool,
                                progress: e['progress'] as double),
                          );
                        }),
                        SizedBox(
                          height: Resizable.padding(context, 200),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        );
      },
    );
  }
}
