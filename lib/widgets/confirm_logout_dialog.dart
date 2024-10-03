import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import 'custom_button.dart';

class LogoutConfirmDialog extends StatelessWidget {
  final Function() btnYes, btnNo;

  const LogoutConfirmDialog(
      {super.key,
        required this.btnYes,
        required this.btnNo,
        });

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
                    Icon(Icons.logout, color: primaryColor,
                      size: Resizable.size(context, 90)),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.size(context, 30),
                            vertical: Resizable.size(context, 20))
                            .copyWith(bottom: 0),
                        child: Text(AppText.txtConfirmLogout.text,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 20),
                                color: primaryColor),
                            textAlign: TextAlign.center)),
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
                                title: 'Quay lại',
                                onTap: btnNo,
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
                                title: AppText.txtLogout.text,
                                onTap: btnYes,
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
            ],
          )),
    );
  }
}