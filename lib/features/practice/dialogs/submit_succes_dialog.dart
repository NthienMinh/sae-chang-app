import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/custom_button.dart';

class SubmitSuccessDialog extends StatelessWidget {
  final Function() btnReturn;

  const SubmitSuccessDialog({super.key, required this.btnReturn});

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
                      "assets/icons/ic_progress_completed.png",
                      color: primaryColor,
                      height: Resizable.size(context, 90),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.size(context, 30),
                            vertical: Resizable.size(context, 20))
                            .copyWith(bottom: 0),
                        child: Text('Nộp bài \nthành công!',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 20),
                                color: primaryColor),
                            textAlign: TextAlign.center)),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Resizable.size(context, 30),
                            vertical: Resizable.size(context, 5)),
                        child: Text(
                            'Bài của bạn đã được hệ thống ghi nhận. Hãy chờ Giáo viên chấm bài bạn nhé!',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Resizable.font(context, 11),
                                color: greyColor.shade600),
                            textAlign: TextAlign.center)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 20)),
                              child: CustomButton(
                                  title: AppText.txtPrevious.text,
                                  onTap: btnReturn,
                                  backgroundColor: primaryColor,
                                  textColor: Colors.white,
                                  height: 40),
                            )),
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