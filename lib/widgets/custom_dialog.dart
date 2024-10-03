import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class CustomDialog extends StatelessWidget {
  final String text;
  final Color color;
  final bool isError;
  const CustomDialog(
      {super.key,
      required this.text,
      required this.color,
      required this.isError});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Center(
            child: Container(
          height: Resizable.size(context, 250),
          width: Resizable.size(context, 250),
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
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.clear,
                    color: color,
                  ),
                ),
              ),
              Container(
                height: Resizable.size(context, 100),
                width: Resizable.size(context, 100),
                margin: EdgeInsets.only(bottom: Resizable.padding(context, 20)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                child: Icon(
                  isError ? Icons.clear_outlined : Icons.check,
                  color: Colors.white,
                  size: Resizable.size(context, 50),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 20)),
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: Resizable.size(context, 20),
                        color: color,
                        fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ))
            ],
          ),
        )));
  }
}

class NotConnectDialog extends StatelessWidget {
  final String text;
  final Color color;
  final bool isError;
  const NotConnectDialog(
      {super.key,
      required this.text,
      required this.color,
      required this.isError});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Center(
            child: Container(
          height: Resizable.size(context, 250),
          width: Resizable.size(context, 250),
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
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.clear,
                    color: color,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        'assets/icons/ic_failed.png',
                        width: Resizable.size(context, 70.0),
                        height: Resizable.size(context, 70.0),
                        // color: Colors.white,
                      ),
                      SizedBox(height: Resizable.size(context, 15.0)),
                      Text(
                        text,
                        style: TextStyle(
                            fontSize: Resizable.size(context, 17),
                            color: color,
                            fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ))
            ],
          ),
        )));
  }
}

class ChooseImageDialog extends StatelessWidget {
  final Function() openCamera;
  final Function() openGallery;
  const ChooseImageDialog({
    super.key,
    required this.openCamera,
    required this.openGallery,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        elevation: 0,
        scrollable: true,
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Center(
            child: Container(
              height: Resizable.size(context, 200),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: openCamera,
                      child: Container(
                        height: Resizable.size(context, 150),
                        width: Resizable.size(context, 120),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius:
                          BorderRadius.circular(Resizable.size(context, 30)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "assets/icons/ic_camera.png",
                              height: Resizable.size(context, 50),
                            ),
                            Text(
                              AppText.txtOpenCamera.text.toUpperCase(),
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 15),
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      )),
                  InkWell(
                    onTap: openGallery,
                    child: Container(
                      height: Resizable.size(context, 150),
                      width: Resizable.size(context, 120),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius:
                        BorderRadius.circular(Resizable.size(context, 30)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "assets/icons/ic_gallery.png",
                            height: Resizable.size(context, 50),
                          ),
                          Text(
                            AppText.txtOpenGallery.text.toUpperCase(),
                            style: TextStyle(
                                fontSize: Resizable.font(context, 15),
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
