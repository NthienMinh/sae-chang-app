import 'package:flutter/Material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import '../../../../configs/text_configs.dart';
import 'content_base_view.dart';

class SignalView extends GrammarContentBaseView {
  final String signal;

  const SignalView(this.signal, {super.key});

  @override
  Widget html(BuildContext context) =>
      Html(
        data: signal,
        style: {
          'html': Style(
            color: Colors.grey.shade900,
            fontSize: FontSize(
              Resizable.font(context, 18),
            ),
            fontWeight: FontWeight.w600,
          ),
          'ruby': Style(
              padding: HtmlPaddings.only(bottom: Resizable.font(context, 10))

          ),
          'rt': Style(
              padding: HtmlPaddings.only(bottom: Resizable.font(context, 12))
          ),
          'font': Style(// { }
            // fontFamily: Languages.customFont,
            fontSize: FontSize(
              Resizable.font(context, 18),
            ),
          ),
          'em': Style(// { }

          ),
          'u': Style(
            // < >
            color: Colors.red.shade900,
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
            // <<< >>>
            // fontFamily: Languages.customFont,
            fontSize: FontSize(
              Resizable.font(context, 18),
            ),
            color: Colors.blue.shade900,
            // fontWeight: FontWeight.normal,
          ),
          'strong': Style(
            // [[ ]]
            fontWeight: FontWeight.w900,
            fontSize: FontSize(
              Resizable.font(context, 20),
            ),
          ),
          'strong u': Style(
            // [[ ]]
            color: Colors.grey.shade900,
          ),
          'strong font': Style(
            // [[ ]]
            color: Colors.grey.shade900,
          ),
          'b u': Style(
            // [ <
            color: Colors.black,
          ),
        },
      );

  @override
  String get icon => 'assets/icons/ic_grammar_signal.png';

  @override
  String get title => AppText.txtSignal.text;
}