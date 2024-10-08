import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:flutter_html/flutter_html.dart';
import 'content_base_view.dart';

class StructuresView extends GrammarContentBaseView {
  final String structures;

  StructuresView(this.structures, {super.key}) {
    debugPrint(structures);
  }

  @override
  Widget html(BuildContext context) => Container(
    margin: EdgeInsets.symmetric(
        vertical: Resizable.padding(context, 10)
    ),
    padding: EdgeInsets.symmetric(
      vertical: Resizable.padding(context, 10),
      horizontal: Resizable.padding(context, 10),

    ),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: Offset(0,3),
              blurRadius: 3
          )
        ],
        border: Border.all(color: primaryColor ,width: 2, )
    ),
    child: Html(
      data: structures,
      style: {
        'html': Style(
          color: Colors.red.shade900,
          fontSize: FontSize(
            Resizable.font(context, 20),
          ),
          fontWeight: FontWeight.bold,
        ),
        'ruby': Style(
            padding: HtmlPaddings.only(bottom: Resizable.font(context, 12))

        ),
        'rt': Style(
            padding: HtmlPaddings.only(bottom: Resizable.font(context, 14))

        ),
        'font': Style(
          // { }
          color: Colors.grey.shade900,
          // fontFamily: Languages.customFont,
          fontSize: FontSize(
            Resizable.font(context, 18,),
          ),
        ),
        'em': Style(
          // {{ }}
          fontWeight: FontWeight.w900,
          color: Colors.black,
          fontSize: FontSize(
            Resizable.font(context, 18),
          ),
          textDecoration: TextDecoration.underline,
          fontStyle: FontStyle.normal,
        ),
        'u': Style(
          // < >
          color: Colors.red.shade900,
        ),
        'del': Style(
          // < >
          backgroundColor: Colors.grey.shade400,
          // color: Colors.black,
        ),
        'b': Style(
          // [ ]
          fontSize: FontSize(
            Resizable.font(context, 18),
          ),
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
        'i': Style(
          // fontFamily: Languages.customFont,
          fontSize: FontSize(
            Resizable.font(context, 18),
          ),
          // <<< >>>
          color: Colors.blue.shade900,
          // fontWeight: FontWeight.normal,
          // textDecoration: Languages.current == Language.English
          //     ? TextDecoration.lineThrough
          //     : TextDecoration.none,
        ),
        'strong': Style(
          // [[ ]]
          fontWeight: FontWeight.w900,
          color: Colors.grey.shade900,

          fontSize: FontSize(
            Resizable.font(context, 16) ,
          ),
        ),
        'strong font': Style(
          // [[ {{
          fontWeight: FontWeight.w900,
          color: Colors.grey.shade900,
          fontSize: FontSize(
            Resizable.font(context, 16) ,
          ),
        ),
        'strong u': Style(
          // [[ <
          color: Colors.grey.shade900,
        ),
        'b u': Style(
          // [ <
          color: Colors.black,
        ),
      },
    ),
  );

  @override
  String get icon => 'assets/icons/ic_grammar_structure.png';

  @override
  String get title => AppText.txtStructure.text;
}