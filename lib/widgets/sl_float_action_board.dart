import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class SlFloatActionBoard extends StatelessWidget {
  const SlFloatActionBoard(
      {super.key, this.onAdd, this.onReview, this.onPractice, this.isVip = false});

  final Function()? onAdd;
  final Function()? onReview;
  final Function()? onPractice;
  final bool isVip;
  @override
  Widget build(BuildContext context) {
    int index = 0;
    var list = <ItemSl>[
      // if (onAdd != null)
      //   ItemSl(
      //       onTap: onAdd!, title: AppText.btnAdd.text, index: index++),
      // if (onReview != null)
      //   ItemSl(
      //       onTap: onReview!,
      //       title: AppText.btnReview.text,
      //       index: index++),
      if (onPractice != null)
        ItemSl(
            onTap: onPractice!,
            title: AppText.btnPractice.text,
            index: index++)
    ];
    if (list.length == 2) {
      list.insert(1, ItemSl(onTap: () {}, title: '-1', index: -2));
    } else if (list.length == 3) {
      list.insert(1, ItemSl(onTap: () {}, title: '-1', index: -2));
      list.insert(3, ItemSl(onTap: () {}, title: '-1', index: -2));
    }

    return Container(
      padding: EdgeInsets.only(bottom: Resizable.padding(context, 20)),
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Card(
          color: primaryColor,
          margin: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 30),
            // vertical: Resizable.padding(context, 20),
          ),
          shadowColor: primaryColor,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
          elevation: Resizable.size(context, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...list.map((e) {
                if (e.index != -2) {
                  return Expanded(child: ItemSlBoard(
                      isVip: isVip,
                      item: list.length == 1 ? e.copyWith(
                          index: -1
                      ) : list.length == 3 ? e.copyWith(
                          index: e.index == 1 ? 2 : e.index
                      ) : e

                  ));
                }
                return Container(
                  width: Resizable.size(context, 1),
                  height: Resizable.size(context, 20),
                  color: Colors.white,
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

class ItemSl {
  final Function() onTap;
  final String title;
  final int index;

  ItemSl({required this.onTap, required this.title, required this.index});

  // The copyWith method
  ItemSl copyWith({
    Function()? onTap,
    String? title,
    int? index,
  }) {
    return ItemSl(
      onTap: onTap ?? this.onTap,
      title: title ?? this.title,
      index: index ?? this.index,
    );
  }
}


class ItemSlBoard extends StatelessWidget {
  const ItemSlBoard({super.key, required this.item, required this.isVip});

  final ItemSl item;
  final bool isVip;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Resizable.size(context, 50),
      child: InkWell(
        borderRadius: item.index == -1
            ? BorderRadius.horizontal(
            left: Radius.circular(Resizable.padding(context, 1000)),
            right: Radius.circular(Resizable.padding(context, 1000)))
            : item.index == 0
            ? BorderRadius.horizontal(
            left: Radius.circular(Resizable.padding(context, 1000)))
            : item.index == 1
            ? null
            : BorderRadius.horizontal(
            right: Radius.circular(Resizable.padding(context, 1000))),
        onTap: () {
          // if (isVip) {
          //   VipFunctionController.vipFunctionPopup(
          //       type: LimitType.feature);
          //   return;
          // }
          item.onTap.call();
        },
        child: Center(
          child: Text(item.title.toUpperCase(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Resizable.font(context, 15),
                  fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}