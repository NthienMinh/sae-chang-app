import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/detail_class/lessons/reading/reading_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/reading/reading_detail_cubit.dart';
import 'package:sae_chang/models/skill_models/reading.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/app_bar_template.dart';
import 'package:sae_chang/widgets/drop_cap_text.dart';
import 'package:sae_chang/widgets/split_text_custom.dart';

class ReadingDetailScreen extends StatelessWidget {
  const ReadingDetailScreen(
      {super.key, required this.rCubit, required this.reading, required this.isGetData});

  final ReadingCubit rCubit;
  final Reading reading;
  final bool isGetData;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        if(isGetData )
          BlocProvider.value(
            value: rCubit..getData(),
          ),
        if(!isGetData)
          BlocProvider.value(
            value: rCubit,
          ),
      ],
      child: BlocProvider(
        create: (context) => ReadingDetailCubit(reading),
        child: BlocBuilder<ReadingDetailCubit, int>(
          builder: (context, state) {
            final readDetailCubit = context.read<ReadingDetailCubit>();
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBarTemplate(
                reading.title.toUpperCase(),
                context,
                titleColor: primaryColor,
                elevation: 0,
                actions: [
                  IconButton(
                      onPressed: () {
                        readDetailCubit.updateTranslate();
                      },
                      splashRadius: 25,
                      icon: Image.asset(
                        'assets/icons/${readDetailCubit.translate ? 'ic_not_trans' : 'ic_trans'}.png',
                        scale: 0.5,
                        color: primaryColor,
                      )),
                ],
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Resizable.size(context, 5),
                        ),
                        !readDetailCubit.translate
                            ? Padding(
                          padding: EdgeInsets.only(
                            left: Resizable.size(context, 20),
                            right: Resizable.size(context, 20),
                            bottom: Resizable.size(context, 20),
                          ),
                          child: Builder(builder: (context) {
                            var text = reading.sentences
                                .map((e) => e.furigana
                                .replaceAll('//', '\n'))
                                .join("");
                            return SentenceReading(
                              rCubit: rCubit,
                              reading: reading,
                              rDCubit: readDetailCubit,
                              text: text,
                            );
                          }),
                        )
                            : Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            ...reading.sentences
                                .map((e) => Padding(
                              padding: EdgeInsets.only(
                                left: Resizable.size(
                                    context, 20),
                                right: Resizable.size(
                                    context, 20),
                                bottom: Resizable.size(
                                    context, 20),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  SentenceReading(
                                    rCubit: rCubit,
                                    reading: reading,
                                    rDCubit:
                                    readDetailCubit,
                                    text: e.furigana
                                        .replaceAll(
                                        '//', ''),
                                  ),

                                  SizedBox(
                                    height:
                                    Resizable.padding(
                                        context, 20),
                                  ),
                                  DropCapText(
                                    e.mean.replaceAll(
                                        '//', ''),
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.w500,
                                        color:
                                        greyColor.shade600,
                                        height: 1.1,
                                        fontSize:
                                        Resizable.size(
                                            context,
                                            20)),
                                    dropCapPosition:
                                    DropCapPosition
                                        .start,
                                    dropCapPadding:
                                    EdgeInsets.only(
                                        right: Resizable
                                            .padding(
                                            context,
                                            10)),
                                    dropCap: DropCap(
                                      width: Resizable.size(
                                          context, 20),
                                      height:
                                      Resizable.size(
                                          context, 20),
                                      child: Image.asset(
                                        'assets/icons/ic_reading_vie.png',
                                        scale: 1,
                                        color: primaryColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ))
                                ,
                          ],
                        ),
                        SizedBox(
                          height: Resizable.size(context, 200),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class SentenceReading extends StatelessWidget {
  const SentenceReading(
      {super.key,
        required this.rCubit,
        required this.reading,
        required this.rDCubit,
        required this.text});

  final ReadingCubit rCubit;
  final ReadingDetailCubit rDCubit;
  final Reading reading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SplitTextCustom(
      text: text,
      isParagraph: true,
      isReading: true,
      kanjiFW: FontWeight.w400,
      onShowWord: (int value) {
        // showModalBottomSheet(
        //     context: context,
        //     isScrollControlled: true,
        //     backgroundColor: Colors.white,
        //     shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             topRight: Radius.circular(20))),
        //     builder: (context) {
        //       final word = rCubit.listReadingVocabulary
        //           .firstWhere((element) => element.id == value);
        //       return BottomSheetWord(
        //         rCubit: rCubit,
        //         rDCubit: rDCubit,
        //         word: word,
        //         reading: reading,
        //       );
        //     });
      },
    );
  }
}