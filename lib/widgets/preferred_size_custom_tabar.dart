import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class PreferredSizeCustomTab extends PreferredSize {
  final List<String> list;
  final BuildContext context;
  final TabController controller;

  PreferredSizeCustomTab(this.list, this.context, this.controller, {super.key})
      : super(
            preferredSize: list.length <= 1
                ? const Size.fromHeight(0)
                : Size.fromHeight(Resizable.size(context, 50)),
            child: list.length <= 1
                ? Container()
                : getTab(context, list, controller));

  // static Widget getTab(
  //     BuildContext context, List<String> list, TabController controller) {
  //   var isTablet = Resizable.isTablet(context);
  //   return Container(
  //       height: Resizable.size(context, 43),
  //       decoration: BoxDecoration(
  //         color: greyAccent,
  //         borderRadius: BorderRadius.circular(Resizable.size(context, 1000)),
  //       ),
  //       margin: EdgeInsets.symmetric(
  //         vertical: Resizable.padding(context, 15),
  //         horizontal: Resizable.padding(context, isTablet ? 40 : 20),
  //       ),
  //       child: TabBar(
  //           controller: controller,
  //           isScrollable: false,
  //           physics: const ClampingScrollPhysics(),
  //           indicatorPadding:
  //           const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
  //           indicator: BoxDecoration(
  //             color: primaryColor,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.25),
  //                 spreadRadius: 0,
  //                 blurRadius: 4,
  //                 offset: const Offset(0, 4), // changes position of shadow
  //               ),
  //             ],
  //             borderRadius: BorderRadius.circular(Resizable.size(context, 100)),
  //           ),
  //           unselectedLabelColor: primaryColor.shade500.withOpacity(0.8),
  //           splashFactory: NoSplash.splashFactory,
  //           overlayColor: WidgetStateProperty.resolveWith<Color?>(
  //                   (Set<WidgetState> states) {
  //                 return states.contains(WidgetState.focused)
  //                     ? null
  //                     : Colors.transparent;
  //               }),
  //           labelColor: Colors.white,
  //           unselectedLabelStyle: TextStyle(
  //               fontWeight: FontWeight.w500,
  //               color: primaryColor.shade500.withOpacity(0.8),
  //               fontSize: Resizable.font(context, 17)),
  //           labelStyle: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: Resizable.font(context, 17)),
  //           tabs: list
  //               .map((e) => Tab(
  //             text: e[0].toUpperCase() + e.substring(1).toLowerCase(),
  //           ))
  //               .toList()));
  // }


  static Widget getTab(
      BuildContext context, List<String> list, TabController controller) {
    final tabCubit = TabBarCubit();
    controller.addListener(() async{
      await tabCubit.update(controller.index);
    });
    return BlocBuilder<TabBarCubit, int>(
      bloc: tabCubit,
      builder: (context, state) {
        return TabBar(
            isScrollable: true,
            controller: controller,
            physics: const ClampingScrollPhysics(),
            indicatorColor: Colors.transparent,
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 20)),
            labelPadding: EdgeInsets.zero,
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              return states.contains(WidgetState.focused)
                  ? null
                  : Colors.transparent;
            }),
            tabs: list.map((e) {
              final index = list.indexOf(e);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 10),
                constraints:
                    BoxConstraints(minWidth: Resizable.padding(context, 100)),
                decoration: BoxDecoration(
                  color: state == index ? primaryColor : greyAccent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: state == index
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(
                                0, 4), // changes position of shadow
                          ),
                        ]
                      : null,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 25),
                    vertical: Resizable.padding(context, 10)),
                margin: EdgeInsets.symmetric(
                    horizontal: Resizable.padding(context, 5), vertical: Resizable.padding(context, 10)),
                child: Center(
                  child: Text(
                    e[0].toUpperCase() + e.substring(1).toLowerCase(),
                    style: TextStyle(
                        fontSize: Resizable.font(context, 16),
                        color:
                            state == index ? Colors.white : greyColor.shade600),
                  ),
                ),
              );
            }).toList());
      },
    );
  }
}

class TabBarCubit extends Cubit<int> {
  TabBarCubit() : super(0);

  update(int value) {
    emit(value);
  }
}
