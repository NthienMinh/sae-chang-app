import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/home/home_skill_type.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/shadow_text.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:simple_shadow/simple_shadow.dart';

class SkillItem extends StatelessWidget {
  final HomeSkillType homeSkillType;
  final String text;
  final bool isRed;
  final Function() onTap;
  final bool hasProgress;

  const SkillItem(this.homeSkillType,
      {this.isRed = false,
        this.text = '',
        this.hasProgress = true,
        required this.onTap,
        super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: Resizable.padding(context, 10)),
      width: (MediaQuery.of(context).size.width -
          2 * Resizable.padding(context, 40) -
          Resizable.padding(context, 10)) /
          2,
      decoration: BoxDecoration(
          border: Border.all(
              color: primaryColor, width: Resizable.size(context, 1.5)),
          borderRadius: BorderRadius.circular(Resizable.padding(context, 30)),
          boxShadow: [
            BoxShadow(
                color: primaryColor.withOpacity(0.6),
                blurRadius: Resizable.padding(context, 6),
                offset: const Offset(1, 1))
          ],
          color: isRed ? primaryColor : Colors.white,
          gradient: isRed
              ?  LinearGradient(
              colors: [primaryColor, primaryColor.withOpacity(0.8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)
              : null),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        margin: EdgeInsets.zero,
        child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Resizable.padding(context, 30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical:Resizable.padding(context, 10)),
                    child: SimpleShadow(
                      color: Colors.grey.shade500.withOpacity(0.8),
                      offset: const Offset(
                          1, 1),
                      child: Image.asset(
                        homeSkillType.icon,
                        // color: primaryColor,
                        // width: Resizable.size(context, 60),
                        // height: Resizable.size(context, 60)
                      ),
                    ))),
                Expanded(
                  flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (text.isNotEmpty)
                            Text(
                              text,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: Resizable.size(context, 20),
                              ),
                            ),
                          Text(
                            homeSkillType.title.toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: Resizable.size(context, 20),
                            ),
                          ),
                          if (hasProgress)
                            SizedBox(height: Resizable.size(context, 3)),
                          if (hasProgress)
                            LinearPercentIndicator(
                              padding: EdgeInsets.zero,
                              animation: true,
                              lineHeight: Resizable.size(context, 6),
                              animationDuration: 2500,
                              percent: 0.5,
                              center: const SizedBox(),
                              barRadius: const Radius.circular(1000),
                              backgroundColor: isRed
                                  ? Colors.white.withOpacity(0.5)
                                  : primaryColor.withAlpha(100),
                              progressColor: isRed ? Colors.white : primaryColor,
                            ),
                        ],
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}