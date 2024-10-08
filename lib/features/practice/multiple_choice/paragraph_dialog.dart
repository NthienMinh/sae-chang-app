
import 'package:flutter/Material.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';


class LongTextDialogView extends StatelessWidget {
  final String text;
  const LongTextDialogView({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 5,
      insetPadding: EdgeInsets.symmetric(
        vertical: Resizable.height(context) * 0.1
      ),
      child: Container(
          width: Resizable.width(context) * 0.9,
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white),
          padding: EdgeInsets.all(Resizable.padding(context, 15)),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child:SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...text.split('\n').map((e) {
                  return  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SplitTextCustom(
                      text: e.trim(),
                      isParagraph: true,
                      phoneticSize: 10,
                      kanjiSize: 20,
                      kanjiFW: FontWeight.w500,

                    ),
                  );
                })
              ],
            )
          )
      ),
    );
  }
}
