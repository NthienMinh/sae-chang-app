import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/connect_cubit.dart';
import 'package:sae_chang/features/detail_class/detail_class_mobile.dart';
import 'package:sae_chang/features/home/user_class_cubit.dart';
import 'package:sae_chang/models/base_model/class_model.dart';
import 'package:sae_chang/models/base_model/course_model.dart';
import 'package:sae_chang/models/base_model/user_class.dart';

class DetailClassScreen extends StatefulWidget {
  const DetailClassScreen({super.key, required this.userClass, required this.classModel, required this.courseModel});
  final UserClassModel userClass;
  final ClassModel classModel;
  final CourseModel courseModel;
  @override
  State<DetailClassScreen> createState() => _DetailClassScreenState();
}

class _DetailClassScreenState extends State<DetailClassScreen> with SingleTickerProviderStateMixin {
  late TabController controller;
  var tabs = [
    AppText.txtOverview.text,
    AppText.txtLesson.text,
    AppText.txtTest.text,
  ];

  @override
  void initState() {
    if (UserClassCubit.instance.getClass(widget.userClass.classId)!.subClassId != -1) {
      tabs.add(
        AppText.txtElective.text,
      );
    }
    controller = TabController(length: tabs.length, vsync: this)
      ..addListener(() {
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectCubit, bool>(
        bloc: ConnectCubit.instance,
        builder: (cc,ss){
          return DetailClassMobile(
            controller: controller,
            userClass: widget.userClass,
            tabs: tabs, classModel: widget.classModel, courseModel: widget.courseModel,
          );
          // ResponsiveLayout(
          //   mobileLayout: ,
          //   tabletLayout: DetailClassMobile(
          //     controller: controller,
          //     userClass: widget.userClass,
          //     tabs: tabs,
          //   ),
          // );
        });
  }
}
