import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';


class LossConnectBottomSheet extends StatelessWidget {
  const LossConnectBottomSheet({super.key, required this.showContinue});

  final bool showContinue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(minHeight: Resizable.size(context, 200)),
        margin:
            EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)).copyWith(bottom: Resizable.padding(context, 20)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Resizable.size(context, 20))),
        padding:
            EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: Resizable.padding(context, 10),
              ),
              Container(
                height: Resizable.size(context, 5),
                width: Resizable.size(context, 40),
                decoration: BoxDecoration(
                    color: greyColor.shade600.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20)),
              ),
              SizedBox(
                height: Resizable.padding(context, 20),
              ),
              Container(
                padding: EdgeInsets.all(Resizable.padding(context, 15)),
                decoration: BoxDecoration(
                    color: primaryColor.shade500, shape: BoxShape.circle),
                child: Icon(Icons.wifi_off_rounded, size: Resizable.size(context, 75), color: Colors.white,)
              ),
              SizedBox(
                height: Resizable.padding(context, 15),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 20),
                ),
                child: Text(
                  AppText.txtNoInternet.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: Resizable.font(context, 20)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 20),
                  vertical: Resizable.padding(context, 10),
                ),
                child: Text(
                  showContinue
                      ? AppText.txtSubTitleDisconnect1.text
                      : AppText.txtSubTitleDisconnect2.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: Resizable.font(context, 14)),
                ),
              ),
              if(showContinue)
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Text(
                              AppText.txtBack.text.toUpperCase(),
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Text(
                              AppText.txtContinue.text.toUpperCase(),
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
                height: Resizable.padding(context, 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
