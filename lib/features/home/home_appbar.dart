import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/providers/firebase/firebase_provider.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/confirm_logout_dialog.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'choose_level_button.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            alignment: Alignment.bottomCenter,
            height: Resizable.barSize(context, 60),
            margin:
                EdgeInsets.symmetric(horizontal: Resizable.padding(context, 0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Center(
                      child: SimpleShadow(
                        color: primaryColor.withOpacity(0.1),
                        sigma: 2,
                        child: Image.asset(
                          'assets/images/img_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // ChooseLevelButton(title: title),
                        SizedBox(width: Resizable.size(context, 6)),
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: Resizable.padding(context, 6),
                          ),
                          child:CircleAvatar(
                              backgroundColor: primaryColor,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showDialog(
                                            context: context,
                                            builder: (BuildContext dc) {
                                              return LogoutConfirmDialog(
                                                btnYes: () => FireBaseProvider.instance.logOutUser(context),
                                                btnNo: () => Navigator.of(context).pop(),
                                              );
                                            },
                                          );
                                },
                              ))


                          // InkWell(
                          //   borderRadius: BorderRadius.circular(1000),
                          //   onTap: () {
                          //     showDialog(
                          //       context: context,
                          //       builder: (BuildContext dc) {
                          //         return LogoutConfirmDialog(
                          //           btnYes: () => FireBaseProvider.instance.logOutUser(context),
                          //           btnNo: () => Navigator.of(context).pop(),
                          //         );
                          //       },
                          //     );
                          //   },
                          //   //=> Functions.goPage(context, Routes.setting),
                          //   child: SimpleShadow(
                          //     sigma: 3,
                          //     offset: const Offset(3, 3),
                          //     child: Container(
                          //         margin: EdgeInsets.symmetric(
                          //             //horizontal: Resizable.padding(context, 6),
                          //             vertical: Resizable.padding(context, 6)),
                          //         padding: EdgeInsets.all(
                          //             Resizable.padding(context, 6)),
                          //         height: double.infinity,
                          //         decoration: BoxDecoration(
                          //             color: primaryColor,
                          //             shape: BoxShape.circle,
                          //             border: Border.all(
                          //                 color: primaryColor, width: 0.5)),
                          //         child: Center(
                          //           child: Icon(Icons.output,
                          //               color: Colors.white,
                          //               size: Resizable.size(context, 20)),
                          //         )
                          //         // Image.asset(
                          //         //     'assets/icons/ic_settings.png',
                          //         //     color: Colors.white,
                          //         //     height: Resizable.size(context, 20),
                          //         //   )
                          //         ),
                          //   ),
                          // ),
                        ),
                      ],
                    )),
              ],
            )));
  }
}
