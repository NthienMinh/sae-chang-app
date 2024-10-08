import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/models/base_model/test_model.dart';
import 'package:sae_chang/models/base_model/test_result_model.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/progress_score.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ItemTest extends StatelessWidget {
  const ItemTest(
      {super.key,
      required this.index,
      required this.test,
      required this.testResult,
      required this.result,
      required this.userId,
      required this.classId});

  final int index, userId, classId;
  final TestModel test;
  final TestResultModel testResult;
  final dynamic result;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Resizable.size(context, 3),
      shadowColor: primaryColor.shade500.withOpacity(0.6),
      clipBehavior: Clip.none,
      color: Colors.white,
      margin: EdgeInsets.symmetric(
          vertical: Resizable.padding(context, 4),
          horizontal: Resizable.padding(context, 20)
          // horizontal: Resizable.padding(context, 10),
          ),
      shape: RoundedRectangleBorder(
        side:
            BorderSide(color: primaryColor, width: Resizable.size(context, 1.5)),
        borderRadius: BorderRadius.circular(Resizable.padding(context, 20)),
      ),
      child: InkWell(
        onTap: () => onPress(context),
        borderRadius: BorderRadius.circular(Resizable.padding(context, 20)),
        child: Padding(
            padding: EdgeInsets.all(Resizable.padding(context, 10)),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (result > 10 || result == -1)
                          SimpleShadow(
                              color: Colors.grey.shade500.withOpacity(0.8),
                              offset: const Offset(1, 1),
                              child: Image.asset(
                                color: Colors.grey.shade600,
                                'assets/icons/ic_clock_wait.png',
                                width: Resizable.size(context, 40),
                                height: Resizable.size(context, 40),
                              )),
                        if (result <= 10 && result > -1)
                          ProgressScore(
                              elevation: 0,
                              fontScore: Resizable.font(context, 14),
                              fontText: Resizable.font(context, 9),
                              weight: 4,
                              result: result,
                              size: Resizable.size(context, 55)),
                        if (result < -1)
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Image.asset('assets/images/img_border.png'),
                              Text(
                                  index < 10 ? "0$index" : index.toString(),
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: Resizable.font(context, 28)))
                            ],
                          )
                      ],
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(test.title.trim(),
                              style: TextStyle(
                                  height: 1.25,
                                  fontSize: Resizable.font(context, 18),
                                  fontWeight: FontWeight.w800,
                                  color: primaryColor,
                                  shadows: [
                                    BoxShadow(
                                        color: primaryColor.shade500
                                            .withOpacity(0.8),
                                        blurRadius:
                                            Resizable.padding(context, 3),
                                        offset: const Offset(1, 1))
                                  ])),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    testResult.dateAssign))
                                .trim()
                                .replaceAll("/", "."),
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.size(context, 13),
                                shadows: [
                                  BoxShadow(
                                      color:
                                          Colors.grey.shade500.withOpacity(0.6),
                                      blurRadius: 1,
                                      offset: const Offset(1, 1)),
                                ]),
                          ),
                        ],
                      ),
                    )),
              ],
            )),
      ),
    );
  }

  void onPress(BuildContext context) async {
    if (result != -2) {
      Navigator.of(context, rootNavigator: true)
          .pushNamed(Routes.result, arguments: {
        'id': test.id,
        'type': "test",
        'resultId': testResult.id,
        'dataId': test.isCustom ? test.dataId : test.id,
        'isOffline': false,
        'userId': userId,
        'classId': classId,
        'score': result
      });
    } else {
      await Navigator.pushNamed(context, Routes.practice, arguments: {
        'id': test.id,
        'type': "test",
        'resultId': testResult.id,
        'dataId': test.isCustom ? test.dataId : test.id,
        'isOffline': false,
        'duration': test.duration,
        'userId': userId,
        'classId': classId
      });
      // if (res != null &&
      //     res is Map<String, dynamic> &&
      //     res['complete'] == true) {
      //   await cubit.reload();
      // }
    }
  }
}
