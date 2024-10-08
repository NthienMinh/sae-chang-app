import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';

class Selector extends StatelessWidget {
  final String text;
  final bool? isSelected;
  final Function() onPressed;
  final int type;

  const Selector(
      this.text,
      this.isSelected,
      this.onPressed,this.type, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          vertical: Resizable.padding(context, 3),
          horizontal: Resizable.padding(context, 20)),
      color: isSelected == null || isSelected == false
          ? Colors.white
          : primaryColor,
      elevation: isSelected == null || isSelected == false ? Resizable.size(context, 5) : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Resizable.size(context,10)),
        side: isSelected != null && isSelected!
            ? BorderSide.none
            : const BorderSide(color: primaryColor, width: 0.5),
      ),
      child: InkWell(
        onTap: () {
          onPressed();
        },
        splashColor:
        isSelected == null ? primaryColor.shade500 : Colors.transparent,
        borderRadius:
        BorderRadius.all(Radius.circular(Resizable.size(context, 1000))),
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(
            minHeight: Resizable.size(context, 40)
          ),
          padding:
          EdgeInsets.symmetric(vertical: Resizable.padding(context, 5), horizontal: Resizable.padding(context, 15)),
          child: SplitTextCustom(
            text: text,
            kanjiSize: 18,
            phoneticSize: 8,
            isSelected: isSelected == null || isSelected == false ? false : true,
            phoneticColor: isSelected == null || isSelected == false
                ? Colors.black
                : Colors.white,
            kanjiColor: isSelected == null || isSelected == false
                ? Colors.black
                : Colors.white,
            kanjiFW: FontWeight.w600,
          )
        ),
      ),
    );
  }
}
class ImageSelector extends StatelessWidget {
  final String image;
  final bool? isSelected;
  final Function() onPressed;
  final Function() onZoom;
  final double size;
  final String dir;

  const ImageSelector(
      this.image,
      this.isSelected,
      this.onPressed,this.onZoom,{
        super.key,this.size = 0.4, required this.dir
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File("$dir$image")),
                  fit: BoxFit.fill,
                ),
                border: Border.all(
                    width: Resizable.size(context,isSelected == null || isSelected == false ? 0 :3),
                    color: primaryColor),
                borderRadius: BorderRadius.all(
                    Radius.circular(Resizable.size(context, 10))),
              ),
            ),
            GestureDetector(
              onTap: () {
                onZoom();
              },
              child: Container(
                  height: Resizable.size(context, 20),
                  width: Resizable.size(context, 20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft:
                        Radius.circular(Resizable.size(context, 5)),
                        bottomRight:
                        Radius.circular(Resizable.size(context, 5))),
                  ),
                  child: Center(
                      child: Icon(
                        Icons.zoom_in_rounded,
                        size: Resizable.size(context, 15),
                        color: Colors.white,
                      ))),
            )
          ],
        ),
      ),
    );
  }
}