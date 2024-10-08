import 'package:flutter/Material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import 'content_base_view.dart';

class UsesView extends GrammarContentBaseView {
  final String uses;

  const UsesView(this.uses, {super.key}) ;

  @override
  Widget html(BuildContext context) => Html(
    data: uses,

    style: {
      'html': Style(
        color: Colors.grey.shade800,
        fontSize: FontSize(
          Resizable.font(context, 18) ,
        ),
        fontWeight: FontWeight.w600,
      ),
      'ruby': Style(
          padding: HtmlPaddings.only(bottom: Resizable.font(context, 10))

      ),
      'rt': Style(
          padding: HtmlPaddings.only(bottom: Resizable.font(context, 12))

      ),
      'font': Style(
        // { }
        fontSize: FontSize(
          Resizable.font(context, 18),
        ),
      ),
      'em': Style(
        fontSize: FontSize(
          Resizable.font(context, 18),
        ),
        fontWeight: FontWeight.w700,
      ),
      'u': Style(
        // < >
        color: Colors.red.shade900,
        textDecoration: TextDecoration.none,
      ),
      'b': Style(
        // [ ]
        fontSize: FontSize(
          Resizable.font(context, 18) ,
        ),
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      'i': Style(
        // <<< >>>
        fontSize: FontSize(
          Resizable.font(context, 18),
        ),
        color: Colors.blue.shade900,
        // fontWeight: FontWeight.normal,
      ),
      'strong': Style(
        fontWeight: FontWeight.w900,
        fontSize: FontSize(
          Resizable.font(context, 19),
        ),
      ),
      'strong u': Style(
        color: Colors.red.shade900,
        textDecoration: TextDecoration.none,
      ),
      'strong font': Style(
        color: Colors.grey.shade900,
      ),
      'b u': Style(
        // [ <
        color: Colors.black,
      ),
    },
  );

  @override
  String get icon => 'assets/icons/ic_grammar_use.png';

  @override
  String get title => AppText.txtUsage.text;
}