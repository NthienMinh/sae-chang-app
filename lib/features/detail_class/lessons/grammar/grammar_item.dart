import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/models/skill_models/grammar.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class GrammarItem extends StatelessWidget {
  const GrammarItem(
      {super.key,
      required this.grammar,
      required this.lessonId,
      required this.grammars});
  final Grammar grammar;
  final List<Grammar> grammars;
  final int lessonId;
  @override
  Widget build(BuildContext context) {
    var isTablet = Resizable.isTablet(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 55),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: isTablet ? 30 : 15),
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
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            await Navigator.pushNamed(context, Routes.grammarDetail, arguments: {
              'grammar': grammar,
              'lessonId': lessonId,
              'grammars' : grammars

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
                        horizontal: Resizable.padding(context, 15)),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/icons/ic_grammar_head.png',
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
                        grammar.mean.toUpperCase().replaceAll("{", "").replaceAll("}", ""),
                        style: TextStyle(
                          fontSize: Resizable.font(context, 16),
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: Resizable.padding(context, 5),
                      ),
                      Text(grammar.title.replaceAll("{", "").replaceAll("}", ""),
                          style: TextStyle(
                            fontSize: Resizable.font(context, 15),
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          )),
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
