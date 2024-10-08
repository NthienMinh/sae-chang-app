import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/bloc/connect_cubit.dart';
import 'package:sae_chang/features/detail_class/overview/class_overview_cubit.dart';
import 'package:sae_chang/features/function/functions.dart';
import 'package:sae_chang/features/home/home_skill_type.dart';
import 'package:sae_chang/features/home/home_title_category.dart';
import 'package:sae_chang/features/home/user_class_cubit.dart';
import 'package:sae_chang/features/home/user_class_item.dart';
import 'package:sae_chang/models/base_model/user_class.dart';
import 'package:sae_chang/providers/cache_data/cache_data_provider.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/loading_progress.dart';
import 'package:sae_chang/widgets/see_more_button.dart';

class UserClassScreen extends StatelessWidget {
  const UserClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(milliseconds: 200));
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    });

    var cubit = UserClassCubit.instance;
    var categories = [
      HomeCategory.yourCourse,
      HomeCategory.recommendCourse,
      HomeCategory.promotion
    ];
    return BlocBuilder<UserClassCubit, int>(
        bloc: cubit..loadData(),
        builder: (c, s) {
          return RefreshIndicator(
              onRefresh: () async {
                if (ConnectCubit.instance.state) {
                  await CacheDataProvider.clearAllKey();
                  await cubit.loadData();
                }
              },
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BlocProvider(
                      //   create: (context) => SlProgressCubit(type: 'all'),
                      //   child: BlocBuilder<SlProgressCubit, double>(
                      //     builder: (context, progress) {
                      //       return HomeFavoriteButton(
                      //         percent: progress,
                      //         onUpdate: () async {
                      //           await context.read<SlProgressCubit>().loadAll();
                      //         },
                      //       );
                      //     },
                      //   ),
                      // ),
                      ...categories.map((c) => Column(
                            children: [
                              if (c == HomeCategory.yourCourse)
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: Resizable.padding(context, 10),
                                      left: Resizable.padding(context, 20)),
                                  child: HomeTitleCategory(c.title, c.icon),
                                ),
                              // if (c == HomeCategory.promotion &&
                              //     ConnectCubit.instance.state)
                              //   Padding(
                              //     padding: EdgeInsets.only(
                              //         right: Resizable.padding(context, 10),
                              //         left: Resizable.padding(context, 20)),
                              //     child: HomeTitleCategory(c.title, c.icon),
                              //   ),
                              if (categories.indexOf(c) == 0)
                                cubit.isLoading
                                    ? const Center(child: LoadingProgress())
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Resizable.padding(context, 20)),
                                        child: BlocProvider(
                                          create: (context) => SeeMoreCubit(),
                                          child:
                                              BlocBuilder<SeeMoreCubit, bool>(
                                                  builder: (cc, s) {
                                            List<UserClassModel>? listClass;
                                            listClass =
                                                List.of(cubit.listUserClass!);
                                            listClass.sort((a, b) {
                                              if (a.status == "Completed" &&
                                                  b.status != "Completed") {
                                                return 1;
                                              } else if (a.status !=
                                                      "Completed" &&
                                                  b.status == "Completed") {
                                                return -1;
                                              }
                                              return 0;
                                            });

                                            var list = s
                                                ? listClass
                                                : listClass.length >= 2
                                                    ? listClass.sublist(0, 2)
                                                    : listClass;

                                            return Column(
                                              children: [
                                                ...list.map((e) => BlocProvider(
                                                      create: (context) =>
                                                          LoadPercentItemClassCubit()
                                                            ..load(
                                                                cubit.getClass(
                                                                    e.classId)),
                                                      child: BlocBuilder<
                                                          LoadPercentItemClassCubit,
                                                          int>(
                                                        builder: (ccc, sss) {
                                                          var loadPercentCubit =
                                                              BlocProvider.of<
                                                                      LoadPercentItemClassCubit>(
                                                                  ccc);
                                                          return UserClassItem(
                                                            isPrimary: true,
                                                            description: cubit
                                                                .getClass(
                                                                    e.classId)
                                                                .description,
                                                            isCompleted: cubit
                                                                    .getClass(e
                                                                        .classId)
                                                                    .status ==
                                                                'Completed',
                                                            onPressed:
                                                                () async {
                                                              Functions.goPage(
                                                                  context,
                                                                  Routes
                                                                      .detailClass,
                                                                  arguments: {
                                                                    'user_class':
                                                                        e,
                                                                    'class_model':
                                                                        cubit.getClass(
                                                                            e.classId),
                                                                    'course_model': cubit.getCourse(cubit
                                                                        .getClass(
                                                                            e.classId)
                                                                        .courseId)
                                                                  });
                                                            },
                                                            classCode: cubit
                                                                .getClass(
                                                                    e.classId)
                                                                .code,
                                                            title: cubit
                                                                .getCourse(cubit
                                                                    .getClass(e
                                                                        .classId)
                                                                    .courseId)!
                                                                .title,
                                                            index: list.indexOf(e),
                                                            progress: loadPercentCubit
                                                                        .numAllLesson ==
                                                                    0
                                                                ? 0
                                                                : (loadPercentCubit
                                                                            .numLessonOpened /
                                                                        loadPercentCubit
                                                                            .numAllLesson)
                                                                    .toDouble(),
                                                            text: loadPercentCubit
                                                                        .numAllLesson ==
                                                                    0
                                                                ? "0/0"
                                                                : "${loadPercentCubit.numLessonOpened}/${loadPercentCubit.numAllLesson}",
                                                          );
                                                        },
                                                      ),
                                                    )),
                                                if (listClass.length > 2)
                                                  SeeMoreButton(
                                                      s, listClass.length,
                                                      onTap: () => BlocProvider
                                                              .of<SeeMoreCubit>(
                                                                  cc)
                                                          .change())
                                              ],
                                            );
                                          }),
                                        )),
                              // if (categories.indexOf(c) == 1)
                              //cubit.isLoading? const Center(child: LoadingProgress()) :Padding(
                              //       padding: EdgeInsets.symmetric(
                              //           horizontal: Resizable.padding(context, 20)),
                              //       child: Column(
                              //         children: [
                              //           if (cubit.listCourses.isEmpty)
                              //             Align(
                              //               alignment: Alignment.center,
                              //               child: Text(
                              //                   AppStudentText.txtNoRecommendCourse.text,
                              //                   style: TextStyle(
                              //                       color: primaryColor,
                              //                       fontSize: Resizable.font(context, 16),
                              //                       fontWeight: FontWeight.w600)),
                              //             ),
                              //           ...(cubit.listCourses).map((i) => Padding(
                              //               padding: EdgeInsets.only(
                              //                   top: Resizable.padding(context, 4)),
                              //               child: HomeRecommendCourseItem(
                              //                   title: i.title,
                              //                   text: i.description,
                              //                   type: i.level,
                              //                   isFav: cubit
                              //                       .getFavoriteCourseSuggest(i.courseId),
                              //                   onPress: () {
                              //                     Dialogs.showDialogCustomV1(
                              //                         context, false, ListLessonDialog(i));
                              //                   },
                              //                   icon: getIcon(i)))),
                              //         ],
                              //       )),
                              // if (categories.indexOf(c) == 2 && ConnectCubit.instance.state)
                              //   cubit.loadingBannerAndSuggest
                              //       ? const Center(child: LoadingProgress())
                              //       : HomePromotionView(cubit.listBanner)
                            ],
                          )),
                      SizedBox(height: Resizable.size(context, 50))
                    ],
                  )));
        });
  }
}

class SeeMoreCubit extends Cubit<bool> {
  SeeMoreCubit() : super(false);

  change() => emit(!state);
}
