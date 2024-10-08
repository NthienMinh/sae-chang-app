import 'package:flutter/Material.dart';
import 'package:sae_chang/features/detail_class/tests/tests_view.dart';
import 'package:sae_chang/models/base_model/class_model.dart';
import 'package:sae_chang/models/base_model/course_model.dart';
import 'package:sae_chang/models/base_model/user_class.dart';
import 'package:sae_chang/widgets/app_bar_template.dart';
import 'package:sae_chang/widgets/preferred_size_custom_tabar.dart';

import 'lessons/lessons_view.dart';
import 'overview/class_overview.dart';

class DetailClassMobile extends StatelessWidget {
  const DetailClassMobile(
      {super.key,
      required this.userClass,
      required this.controller,
      required this.tabs,
      required this.classModel,
      required this.courseModel});
  final UserClassModel userClass;
  final TabController controller;
  final List<String> tabs;
  final ClassModel classModel;
  final CourseModel courseModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplateTwoTitle(
        'MÃ LỚP: ${classModel.code}',
        "${courseModel.title} - ${courseModel.termName}",
        context,
        // actions: [
        //   if (ConnectCubit.instance.state)
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         InkWell(
        //           borderRadius: BorderRadius.circular(1000),
        //           onTap: () {
        //             Functions.goPage(context, Routes.setting);
        //           },
        //           child: Container(
        //               margin: EdgeInsets.only(
        //                   right: Resizable.padding(context, 10)),
        //               padding: EdgeInsets.all(Resizable.padding(context, 5)),
        //               decoration: const BoxDecoration(
        //                   color: primaryColor,
        //                   borderRadius:
        //                       BorderRadius.all(Radius.circular(1000))),
        //               child: const Icon(Icons.person, color: Colors.white)),
        //         ),
        //       ],
        //     ),
        // ],
        bottom: PreferredSizeCustomTab(tabs, context, controller),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          ClassOverview(userClass: userClass),
          LessonsView(userClass: userClass),
          TestsView(userClass: userClass)
          // if(userClass.subClassId != 0)
          //   ElectiveListView( userClass: userClass,
          //     isLogin: isLogin,)
        ],
      ),
    );
  }
}
