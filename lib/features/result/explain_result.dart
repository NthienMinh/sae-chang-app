

import 'package:flutter/Material.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';

class ExplainResult extends StatelessWidget {
  const ExplainResult({super.key, required this.explain});
  final String explain;
  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 25),
          vertical: Resizable.padding(context, 5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...explain.split('\n').map( (e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: SplitTextCustom(
                    text: e.trim(),
                    kanjiSize: 16,
                    phoneticSize: 9,
                    kanjiFW: FontWeight.w700,
                    isParagraph: true,
                ),
              );
            })
          ],
        ));
  }
}
