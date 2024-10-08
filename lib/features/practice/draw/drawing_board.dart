import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import '../../../../widgets/drawings.dart';

class DrawingBoard extends StatelessWidget {
  final DrawingsController controller;
  final double height;
  const DrawingBoard({super.key , required this.controller, required this.height});

  @override
  Widget build(BuildContext context) =>
      ClipRRect(
        borderRadius: BorderRadius.circular(
            Resizable.size(context, 30)
        ),
        child: Drawings(
            controller: controller,
            width: Resizable.width(context) - Resizable.padding(context, 50),
            height: height,
            backgroundColor: Colors.transparent),
      );
}

class DrawPanelController extends StatelessWidget {
  final Function() erase;
  final Function() revert;

  const DrawPanelController({required this.erase, required this.revert, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
          right: Resizable.padding(context, 0),
        ),
        width:
            Resizable.size(context, 40),
        height: Resizable.size(context, 170),
        child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: primaryColor.withOpacity(.5), width: 1),
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 30))),
            // shadowColor: PrimaryColor.value,
            elevation: Resizable.size(context, 5),
            shadowColor: primaryColor,
            color: primaryColor,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              Expanded(
                child: InkWell(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                        Resizable.size(context, 30),
                      ),
                    ),
                    highlightColor:  Colors.black.withOpacity(0.2),
                    onTap: revert,
                    child: const Center(child: Icon(Icons.restore, color: Colors.white))),
              ),
              Container(
                  color: Colors.white,
                  height: Resizable.size(context, 1),
                  padding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 12),
                  ),
                  width: Resizable.size(context, 40)),
              Expanded(
                child: InkWell(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(
                        Resizable.size(context, 30),
                      ),
                    ),
                    highlightColor: Colors.black.withOpacity(0.2),
                    onTap: erase,
                    child: const Center(child: Icon(Icons.delete_sweep, color: Colors.white))),
              )
            ])));
  }
}
