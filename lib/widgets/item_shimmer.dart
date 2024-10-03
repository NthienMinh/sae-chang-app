import 'package:flutter/Material.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class ItemShimmer extends StatelessWidget {
  const ItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    var isTablet = Resizable.isTablet(context);
    return Padding(
        padding: EdgeInsets.only(
            bottom: Resizable.padding(context, 10),
            right: Resizable.padding(context, isTablet ? 0 : 20),
            left: Resizable.padding(context,isTablet ? 0 : 20)),
        child: Card(
            margin: EdgeInsets.zero,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Resizable.size(context, 20)),
              ),
              side: const BorderSide(
                color: Color(0xffB0B0B0),
                width: 0.5,
              ),
            ),
            elevation: 3,
            child: SizedBox(
              height: Resizable.size(context, 130),
              child: Column(
                children: [
                  SizedBox(
                    height: Resizable.size(context, 130),
                    child: const Row(
                      children: [
                        Text('hhhhh'),
                      ],
                    ),
                  ),


                ],
              ),
            )));
  }
}