import 'package:flutter/material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/models/skill_models/sentences.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'listening_detail_cubit.dart';
import 'message_center.dart';
import 'message_left.dart';
import 'message_right.dart';

class ConversationListView extends StatefulWidget {
  const ConversationListView({super.key, required this.listSentences});
  final List<Sentences> listSentences;

  @override
  State<ConversationListView> createState() => _ConversationListViewState();
}

class _ConversationListViewState extends State<ConversationListView> {
  List<Map<String, dynamic>> maps = [];

  @override
  void initState() {
    final cubit = context.read<ListeningDetailCubit>();

    double size = 0;
    cubit.controller = AutoScrollController(
        viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, size),
        axis: Axis.vertical);
    mapPosition();
    debugPrint('=>>>>>>>>>>>>maps: $maps');
    super.initState();
  }

  void mapPosition() {
    var temp = <Sentences>[];
    for (var i in widget.listSentences) {
      if (i.start == 0 && i.end == 0) {
        if (temp.isNotEmpty) {
          if (checkOnlyOneCharacter(temp)) {
            for (var j in temp) {
              maps.add({'id': j.id, 'position': 'center'});
            }
          } else {
            String c = temp.first.character;
            Map<String, String> history = {};
            history[c] = c.isEmpty ? 'center' : 'left';
            for (var j in temp) {
              String pos = j.character.isEmpty
                  ? 'center'
                  : history.containsKey(j.character)
                      ? history[j.character]!
                      : getOppositeString(history.values.first);
              maps.add({'id': j.id, 'position': pos});
              history.clear();
              history[j.character] = pos;
            }
          }
        }
        temp.clear();
      } else {
        temp.add(i);
      }
    }
    if (temp.isNotEmpty) {
      if (checkOnlyOneCharacter(temp)) {
        for (var j in temp) {
          maps.add({'id': j.id, 'position': 'center'});
        }
      } else {
        String c = temp.first.character;
        Map<String, String> history = {};
        history[c] = c.isEmpty ? 'center' : 'left';
        for (var j in temp) {
          String pos = j.character.isEmpty
              ? 'center'
              : history.containsKey(j.character)
                  ? history[j.character]!
                  : getOppositeString(history.values.first);
          maps.add({'id': j.id, 'position': pos});
          history.clear();
          history[j.character] = pos;
        }
      }
    }
    temp.clear();
  }

  String getOppositeString(String value) {
    if (value == 'right' || value == 'center') return 'left';
    return 'right';
  }

  String getPosition(Sentences sen) {
    final index = maps.indexWhere((element) => element['id'] == sen.id);
    if (index == -1) {
      return '';
    }
    return maps[index]['position'];
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ListeningDetailCubit>();
    return Stack(
      children: [
        ListView.builder(
            padding: EdgeInsets.only(
                top: 20,
                bottom: Resizable.size(context, 200),
                left: 10,
                right: 10),
            controller: cubit.controller,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast,
            ),
            itemCount: widget.listSentences.length,
            itemBuilder: (context, idx) {
              String pos = getPosition(widget.listSentences[idx]);
              switch (pos) {
                case '':
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: Resizable.size(context, 5),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.5,
                        ),
                        margin: EdgeInsets.only(
                            bottom: Resizable.size(context, 20)),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 3),
                                blurRadius: 4)
                          ],
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ],
                  );
                case 'center':
                  return AutoScrollTag(
                      controller: cubit.controller!,
                      key: ValueKey(idx),
                      index: idx,
                      child: MessageCenter(
                        cons: widget.listSentences[idx],
                      ));
                case 'left':
                  return AutoScrollTag(
                      controller: cubit.controller!,
                      key: ValueKey(idx),
                      index: idx,
                      child: MessageLeft(
                        cons: widget.listSentences[idx],
                      ));
                case 'right':
                  return AutoScrollTag(
                      controller: cubit.controller!,
                      key: ValueKey(idx),
                      index: idx,
                      child: MessageRight(cons: widget.listSentences[idx]));
                default:
                  return Container();
              }
            }),
      ],
    );
  }

  bool checkOnlyOneCharacter(List<Sentences> listSentences) {
    var list = <String>[];
    for (var i in listSentences) {
      if (!list.contains(i.character)) {
        list.add(i.character);
      }
    }
    return (list.length == 1 || list.isEmpty);
  }
}
