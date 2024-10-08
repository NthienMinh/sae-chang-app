import 'package:flutter/material.dart';
import 'package:sae_chang/configs/app_configs.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_state.dart';
import 'package:sae_chang/untils/btvn_utils.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/drawings.dart';
import 'package:record/record.dart';
import 'package:screenshot/screenshot.dart';

class DragBottomPractice extends StatefulWidget {
  const DragBottomPractice({
    super.key,
    required this.state,
    required this.bloc,
    required this.onSubmit,
    required this.screenshotController,
    required this.type,
    required this.isStudent,
    required this.drawController,
    required this.isOffline,
    required this.audioRecorder,
    required this.id,
    required this.resultId, required this.dataId, required this.classId, required this.userId,
  });

  final int dataId;
  final int id;
  final  int classId;
  final  int userId;
  final  int resultId;
  final QuestionState state;
  final PracticeBloc bloc;
  final Function() onSubmit;
  final ScreenshotController screenshotController;
  final String type;
  final bool isStudent;
  final bool isOffline;
  final DrawingsController drawController;
  final AudioRecorder audioRecorder;

  @override
  State<DragBottomPractice> createState() => _DragBottomPracticeState();
}

class _DragBottomPracticeState extends State<DragBottomPractice> {
  final int count = AppConfigs.countDraw;
  final _controller = ScrollController();
  final dragController = DraggableScrollableController();

  onHide() {
    dragController.animateTo(
      .1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
    );
  }

  onExpand() {
    dragController.animateTo(
      .44,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
    );
  }

  @override
  Widget build(BuildContext context) {
    var enabledButton = false;
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      enabledButton = true;
    });

    final btvnUtils = BtvnUtils(
        state: widget.state,
        bloc: widget.bloc,
        onSubmit: widget.onSubmit,
        screenshotController: widget.screenshotController,
        type: widget.type,
        isStudent: widget.isStudent,
        drawController: widget.drawController,
        audioRecorder: widget.audioRecorder,
        isOffline: widget.isOffline);
    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: .1,
        minChildSize: .1,
        maxChildSize: .44,
        controller: dragController,
        builder: (BuildContext context, ScrollController scrollController) {
          return InkWell(
            onTap: () {
              if (dragController.size == .44) {
                onHide();
              } else if (dragController.size < .44) {
                onExpand();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -10))
                  ],
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Resizable.padding(context, 20)))),
              child: ListView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                children: [
                  SizedBox(
                    height: Resizable.height(context) * .09,
                    child: previewWidget(
                        context, (){
                      btvnUtils.onPrevious(widget.id, widget.resultId);
                    }, () async {
                      if (enabledButton) {
                        btvnUtils.handleNext(
                            context,widget.dataId,widget.id,widget.classId,widget.userId,widget.resultId,
                            widget.state.practiceIndex ==
                                widget.state.count - 1);
                      }
                    }),
                  ),
                  SizedBox(
                      height: Resizable.height(context) * .3,
                      child: expandedWidget(context, (int value) async {
                        if (enabledButton) {
                          btvnUtils.handleNext(context,widget.dataId,widget.id,widget.classId,widget.userId,widget.resultId, false, value);
                          onHide();
                        }
                      })),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  previewWidget(
      BuildContext context, Function() onPrevious, Function() onNext) {
    final isSubmit = widget.state.practiceIndex + 1 == widget.state.count;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: widget.state.practiceIndex == 0 ? null : onPrevious,
                iconSize: Resizable.size(context, 30),
                icon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(Icons.arrow_back_rounded),
                ),
              ),
            ),
          ),
          Text(
            '${widget.state.practiceIndex + 1}/${widget.state.count}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: Resizable.size(context, 18),
            ),
          ),
          isSubmit
              ? Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: onNext,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.padding(context, 15),
                                    vertical: Resizable.padding(context, 7)),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(1000),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black26, blurRadius: 10)
                                    ]),
                                child: Center(
                                  child: Text(
                                    AppText.txtEnd.text,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 16)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: onNext,
                      iconSize: Resizable.size(context, 30),
                      icon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Icon(Icons.arrow_forward_rounded),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  expandedWidget(BuildContext context, Function(int value) onClick) {
    final list = generateIndexList(widget.state.count);
    return RawScrollbar(
      //always show scrollbar
      thickness: Resizable.size(context, 7),
      thumbVisibility: true,
      trackVisibility: true,
      thumbColor: primaryColor,
      trackColor: greyAccent,
      padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 20),
          vertical: Resizable.padding(context, 10)),
      controller: _controller,
      //width of scrollbar
      radius: const Radius.circular(1000),
      //corner radius of scrollbar
      scrollbarOrientation: ScrollbarOrientation.bottom,
      //wh
      child: ListView(
        shrinkWrap: true,
        controller: _controller,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 20),
            vertical: Resizable.padding(context, 20)),
        children: [
          ...list.map((e) => FittedBox(
                child: Column(
                  children: [
                    ...e.map((e) => e == -1
                        ? Container(
                            height: Resizable.size(context, 70),
                            width: Resizable.size(context, 70),
                            margin: EdgeInsets.only(
                                right: Resizable.padding(context, 15),
                                bottom: Resizable.padding(context, 15)),
                          )
                        : CircleItemPractice(
                            title: e.toString(),
                            type: getType(e),
                            onPress: () {
                              onClick(e - 1);
                            },
                          ))
                  ],
                ),
              ))
        ],
      ),
    );
  }

  List<List<int>> generateIndexList(int itemCount) {
    List<List<int>> indexList = [];
    List<int> currentGroup = [];

    for (int i = 1; i <= itemCount; i++) {
      currentGroup.add(i);

      if (currentGroup.length == 3 || i == itemCount) {
        while (currentGroup.length < 3) {
          currentGroup.add(-1);
        }
        indexList.add([...currentGroup]);
        currentGroup.clear();
      }
    }

    return indexList;
  }

  int getType(int e) {
    final item = widget.state.listQuestions[e - 1];
    return !widget.state.listIgnore.map((e) => e.id).contains(item.id)
        ? 1
        : widget.state.practiceIndex + 1 == e
            ? 0
            : -1;
  }
}

class CircleItemPractice extends StatelessWidget {
  const CircleItemPractice(
      {super.key,
      required this.title,
      required this.onPress,
      required this.type});

  final String title;
  final Function() onPress;
  final int type;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: Resizable.size(context, 70),
        width: Resizable.size(context, 70),
        margin: EdgeInsets.only(
            right: Resizable.padding(context, 15),
            bottom: Resizable.padding(context, 15)),
        decoration: BoxDecoration(
            color: type == 1 ? primaryColor : Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 10)
            ]),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: type == -1
                    ? Colors.black
                    : type == 0
                        ? primaryColor
                        : Colors.white,
                fontSize: Resizable.font(context, 25),
                fontWeight: type == 0 ? FontWeight.w600 : FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
