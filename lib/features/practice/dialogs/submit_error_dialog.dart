import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/custom_button.dart';

class SubmitErrorDialog extends StatelessWidget {
  final String error;
  final Function() btnReturn;

  const SubmitErrorDialog(
      {super.key, required this.error, required this.btnReturn});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      contentPadding: EdgeInsets.zero,
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
      ),
      insetPadding:
      EdgeInsets.symmetric(horizontal: Resizable.padding(context, 30)),
      content: Center(
          child: Stack(
            children: [
              Container(
                width: Resizable.width(context) * 0.8,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Resizable.padding(context, 20),
                    ),
                    Image.asset(
                      "assets/icons/ic_failed.png",
                      height: Resizable.size(context, 90),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.size(context, 30),
                            vertical: Resizable.size(context, 20))
                            .copyWith(bottom: 0),
                        child: Text('Nộp bài \nthất bại!',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 20),
                                color: primaryColor),
                            textAlign: TextAlign.center)),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.size(context, 30),
                            vertical: Resizable.size(context, 5)),
                        child: Text(error,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Resizable.font(context, 11),
                                color: greyColor.shade600),
                            textAlign: TextAlign.center)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: Resizable.width(context) -
                                Resizable.padding(context, 120),
                            child: CustomButton(
                                title: AppText.txtPrevious.text,
                                onTap: btnReturn,
                                backgroundColor: primaryColor.shade300,
                                textColor: Colors.white,
                                height: 40)),
                      ],
                    ),
                    SizedBox(
                      height: Resizable.padding(context, 20),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: btnReturn,
                    icon: const Icon(Icons.clear_rounded),
                    iconSize: Resizable.size(context, 30),
                    color: primaryColor,
                  ),
                ),
              )
            ],
          )),
    );
  }
}