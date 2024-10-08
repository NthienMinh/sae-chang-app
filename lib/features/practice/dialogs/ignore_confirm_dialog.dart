import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/custom_button.dart';

class IgnoreConfirmDialog extends StatelessWidget {
  final Function() btnYes, btnNo, onDoAgain;
  final String subTitle;

  const IgnoreConfirmDialog(
      {super.key,
        required this.btnYes,
        required this.btnNo,
        required this.onDoAgain,
        required this.subTitle});

  @override
  Widget build(BuildContext context) {
    final isTablet = Resizable.isTablet(context);
    return AlertDialog(
      elevation: 0,
      contentPadding: EdgeInsets.zero,
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
      ),
      insetPadding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, isTablet ? 50 : 30)),
      content: Center(
          child: Stack(
            children: [
              Container(
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
                      "assets/icons/ic_progress_submit.png",
                      color: primaryColor,
                      height: Resizable.size(context, 90),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.size(context, 30),
                            vertical: Resizable.size(context, 20))
                            .copyWith(bottom: 0),
                        child: Text(AppText.txtConfirmSubmit.text,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: Resizable.font(context, 22),
                                color: primaryColor),
                            textAlign: TextAlign.center)),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.size(context, 30),
                            vertical: Resizable.size(context, 10)),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                  child: Center(
                                    child: Text('Số câu chưa \nhoàn thành',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: Resizable.font(context, 14),
                                            color: greyColor.shade600),
                                        textAlign: TextAlign.center),
                                  )),
                              VerticalDivider(
                                color: greyColor.shade600,
                                thickness: 1,
                                width: 2,
                                endIndent: Resizable.padding(context, 7),
                                indent: Resizable.padding(context, 7),
                              ),
                              Expanded(
                                  child: Text(subTitle,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: Resizable.font(context, 23),
                                          color: primaryColor),
                                      textAlign: TextAlign.center))
                            ],
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: Resizable.padding(context, 10),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Resizable.padding(context, 0)),
                            child: CustomButton(
                                title: AppText.txtSubmit.text,
                                onTap: btnYes,
                                backgroundColor: Colors.white,
                                textColor: primaryColor,
                                border: true,
                                height: 40),
                          ),
                        ),
                        SizedBox(
                          width: Resizable.padding(context, 10),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Resizable.padding(context, 0)),
                            child: CustomButton(
                                title:  AppText.txtReturn.text,
                                onTap: onDoAgain,
                                backgroundColor: primaryColor,
                                textColor: Colors.white,
                                height: 40),
                          ),
                        ),
                        SizedBox(
                          width: Resizable.padding(context, 10),
                        ),
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
                    onPressed: btnNo,
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