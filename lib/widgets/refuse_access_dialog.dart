import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:speech_to_text/speech_to_text.dart';

class RefuseAccessDialog extends StatelessWidget {
  const RefuseAccessDialog({super.key, required this.onIgnore, required this.onSetting, required this.namePermission});
  final Function() onIgnore;
  final Function() onSetting;
  final String namePermission;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Resizable.width(context),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: Resizable.padding(context, 10),
          ),
          Text(
            AppText.txtGrantPermission.text,
            style: TextStyle(
                color: Colors.black,
                fontSize: Resizable.font(context, 25),
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: Resizable.padding(context, 10),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              namePermission,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: Resizable.font(context, 16),
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: Resizable.padding(context, 10),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: onIgnore,
                    child: Row(
                      children: [
                        const Icon(Icons.skip_next),
                        SizedBox(width: Resizable.padding(context, 5),),
                        Text(
                          AppText.txtIgnore.text.toUpperCase(),
                          style: TextStyle(
                              fontSize: Resizable.font(context, 15),
                              fontWeight: FontWeight.w800,
                              color: primaryColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
                const VerticalDivider(
                  color: primaryColor,
                  endIndent: 10,
                  indent: 10,
                  thickness: 1,
                ),
                TextButton(
                    onPressed: onSetting,
                    child: Row(
                      children: [
                        const Icon(Icons.settings),
                        SizedBox(width: Resizable.padding(context, 5),),
                        Text(
                          AppText.txtSetting.text.toUpperCase(),
                          style: TextStyle(
                              fontSize: Resizable.font(context, 15),
                              fontWeight: FontWeight.w800,
                              color: primaryColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(
            height: Resizable.padding(context, 10),
          ),
        ],
      ),
    );
  }
}

class RefuseAccessCubit extends Cubit<int> {
  RefuseAccessCubit() : super(0);

  bool res = false;
  bool flag = false;
  loadSpeech(SpeechToText speechToText) async {
    res = await speechToText.hasPermission;
    if(!res) {
      flag = true;
    }
    emitValue( res ? 2 : 1);
  }

  emitValue(int value) {
    if (isClosed) return;
    emit(value);
  }
}
