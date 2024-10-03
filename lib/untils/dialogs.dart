import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/custom_dialog.dart';
import 'package:sae_chang/widgets/custom_loading_dialog.dart';
import 'package:sae_chang/widgets/loss_connect_bottom_sheet.dart';

class Dialogs {
  static void showDialogLogin(context, text, color, isError) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            text: text,
            color: color,
            isError: isError,
          );
        });
  }

  static void showDialogNotConnect(context, text, color, isError) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return NotConnectDialog(
            text: text,
            color: color,
            isError: isError,
          );
        });
  }

  static void showLoadingDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LoadingDialog();
      },
    );
  }


  static void showBottomSheet(BuildContext context, Widget widget) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Resizable.size(context, 20)),
                topRight: Radius.circular(Resizable.size(context, 20)))),
        builder: (context) {
          return widget;
        });
  }

  static void showDialogCustom(context, bool barrierDismissible, Widget child) {
    var isTablet = Resizable.isTablet(context);
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
            ),
            insetPadding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, isTablet ? 50 : 20),
                vertical: Resizable.padding(context, 20)),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius:
                  BorderRadius.circular(Resizable.size(context, 20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: child));
      },
    );
  }

  static void showErrorConnectDialog(BuildContext context, int permitPop) {
    if (permitPop == 0) {
      Navigator.pop(context);
    }
    showBottomSheetV2(
        context,
        LossConnectBottomSheet(
          showContinue: permitPop == 0 ? false : true,
        ));
  }

  static void showBottomSheetV2(BuildContext context, Widget widget) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        barrierColor: Colors.black.withOpacity(0.8),
        isDismissible: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Resizable.size(context, 20)),
                topRight: Radius.circular(Resizable.size(context, 20)))),
        builder: (context) {
          return widget;
        });
  }

  static void showDialogPractice(BuildContext context , Widget widget) {
    showMaterialModalBottomSheet(
        enableDrag: false,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => widget);
  }

}
