import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/detail_class/lessons/reading/reading_cubit.dart';
import 'package:sae_chang/models/skill_models/reading.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class ReadingItem extends StatelessWidget {
  const ReadingItem({super.key, required this.reading});
  final Reading reading;

  @override
  Widget build(BuildContext context) {
    final rCubit = context.read<ReadingCubit>();
    return Container(
      constraints: BoxConstraints(minHeight: Resizable.size(context, 55)),
      margin: EdgeInsets.symmetric(
          vertical: Resizable.padding(context, 3),
          horizontal: Resizable.padding(context, 15)),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: primaryColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () async {
            Navigator.pushNamed(context, Routes.readingDetail, arguments: {
              'rCubit': rCubit,
              'reading': reading,
              'isGetData': false,
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Center(
                  child: Container(
                    height: Resizable.size(context, 30),
                    width: Resizable.size(context, 30),
                    margin: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 15),
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/icons/ic_learn_6.png',
                      color: primaryColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reading.title.toUpperCase(),
                        style: TextStyle(fontSize: Resizable.font(context, 16), color: darkGreyColor),
                      ),
                      SizedBox(
                        height: Resizable.padding(context, 5),
                      ),
                      Text(reading.mean,
                          style:  TextStyle(fontSize: Resizable.font(context, 15), color: darkGreyColor)),
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
      ),
    );
  }
}
