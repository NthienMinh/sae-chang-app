import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/connect_cubit.dart';
import 'package:sae_chang/untils/custom_toast.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class ProgressService {
  ProgressService(this.context, this.isDismissible, this.type) {
    debugPrint('progress load');
    load();
  }

  final BuildContext context;
  final bool isDismissible;
  final String type;

  load() async {
    debugPrint('=>>>>>>load dialog');
    final cubit = context.read<ProgressCubit>()..load(type);
    await showDialog(
        context: context,
        barrierDismissible: isDismissible,
        builder: (context) {
          return BlocConsumer<ConnectCubit, bool>(
            listener: (context, state) {
              if(!state) {
                Navigator.pop(context);
                Navigator.pop(context);
                CustomToast.showBottomToast(context, 'Mất kết nối mạng! Vui lòng thử lại.');
              }
            },
            builder: (context, state) {
              return BlocBuilder<ProgressCubit, int>(
                bloc: cubit,
                builder: (_, state) {
                  final isTablet = Resizable.isTablet(context);
                  return WillPopScope(
                    onWillPop: () async {
                      return isDismissible;
                    },
                    child: Dialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      insetPadding: EdgeInsets.symmetric(
                        horizontal:
                            Resizable.padding(context, isTablet ? 50 : 30),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(
                              Resizable.size(context, 20)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: Resizable.size(context, 20),
                                ),
                                Image.asset(
                                  "assets/images/img_logo.png",
                                  height: Resizable.size(context, 120),
                                ),
                                Flexible(
                                  child: Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                Resizable.padding(context, 20),
                                            vertical:
                                                Resizable.padding(context, 10)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Resizable.padding(context, 00),
                                            vertical:
                                                Resizable.padding(context, 10)),
                                        child: Builder(builder: (context) {
                                          var text1 = '';
                                          var text2 = '';
                                          if (cubit.idiom.contains('_')) {
                                            text1 = cubit.idiom.split('_')[0];
                                            text2 = cubit.idiom.split('_')[1];
                                          } else {
                                            text1 = cubit.idiom;
                                          }
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              AutoSizeText(
                                                text1
                                                    .trim()
                                                    .replaceAll('"', ''),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Resizable.font(
                                                        context, 18)),
                                              ),
                                              if (text2.isNotEmpty)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: Resizable.padding(
                                                          context, 10)),
                                                  child: AutoSizeText(
                                                    '- ${text2.trim()} -',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: darkGreyColor,
                                                        fontSize:
                                                            Resizable.font(
                                                                context, 10)),
                                                  ),
                                                ),
                                            ],
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: Resizable.size(context, 20),
                                ),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            Resizable.padding(context, 20),
                                        vertical:
                                            Resizable.padding(context, 0)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        LinearPercentIndicator(
                                          padding: EdgeInsets.zero,
                                          animation: true,
                                          animateFromLastPercent: true,
                                          lineHeight: 8,
                                          animationDuration: 0,
                                          percent:
                                              (cubit.progress / 100).toDouble(),
                                          center: const SizedBox(),
                                          barRadius: const Radius.circular(8),
                                          backgroundColor: Colors.grey.shade300,
                                          progressColor: primaryColor,
                                        ),
                                        SizedBox(
                                          height:
                                              Resizable.padding(context, 10),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AutoSizeText(
                                              cubit.firstText!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: greyColor.shade600,
                                                  fontSize: Resizable.font(
                                                      context, 13)),
                                            ),
                                            AutoSizeText(
                                              '${cubit.progress.truncate()}%',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: greyColor.shade600,
                                                  fontSize: Resizable.font(
                                                      context, 13)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: Resizable.size(context, 20),
                                ),
                              ],
                            ),
                            if (cubit.type == 'download')
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.clear_rounded),
                                    iconSize: Resizable.size(context, 30),
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        });
  }

  Future update(double progress) async {
    if (!context.mounted) return;
    final cubit = context.read<ProgressCubit>();
    debugPrint('=>>>>>>update dialog');
    cubit.update(progress);
    if (progress == 100) {
      await hide();
    }
  }

  Future hide() async {
    if (!context.mounted) return;
    Navigator.pop(context);
  }
}

class ProgressCubit extends Cubit<int> {
  ProgressCubit() : super(0);
  String? type;
  String? firstText;
  List<String> idiomDownload = [
    'Tìm thấy chính mình trong những điều mà bản thân cố gắng. Học cũng vậy',
    'Học tập là hạt giống của kiến thức, kiến thức là hạt giống của hạnh phúc _Ngạn ngữ Gruzia',
    'Hãy ám thị bản thân bằng câu : " Mình rất thích tiếng Trung. Mình đang cải thiện hơn. Mình sẽ giỏi hơn "',
    'Luyện mãi thành tài, miệt mài tất giỏi ',
    'Đừng xấu hổ khi không biết, chỉ xấu hổ khi không học _ Khuyết danh',
    'Đời sống có hạn mà sự học thì vô hạn. _ Trang Tử',
    'Điều tuyệt vời nhất của việc học hành là không ai có thể lấy nó đi khỏi bạn',
    'Nếu bạn không muốn học, không ai có thể giúp bạn. Nếu bạn quyết tâm học, không ai có thể ngăn cản bạn dừng lại',
    'Để hiểu được sắc đẹp của một bông tuyết, cần phải đứng ra giữa trời lạnh. Học cũng vậy',
    'Học có thể không giúp mình kiếm tiền nhiều hơn. Nhưng ít ra cũng giúp mình tự tin hơn với những gì mình đã học.',
    'Mỗi ngày cố gắng học thêm 10 từ vựng nữa nhé ! '
  ];
  List<String> idiomSubmit = [
    'Học tiếng Trung chán thì đọc manga. Xem truyện mà chán thì xem các chương trình truyền hình, anime. Không thì nghe nhạc, nghe post card.\nMẫu chốt nằm ở chỗ : biết đưa tiếng Trung từ từ vào cuộc sống của mình',
    'Những ngày khó nhọc mà bạn kiên trì, vẫn học tiếng Trung thì chắc chắn bạn sẽ vượt lên rất xa so với các bạn đồng trang lứa',
    'Bản chất của việc giỏi ngoại ngữ chính là sự duy trì việc học',
    'Tôi có thể chưa kaiwa lưu loát. Nhưng thật vui vì hôm nay tôi đã nói được câu dài hơn hơn qua',
    'Hãy nhớ : các tiền bối cũng từng là người đi học !',
    'Lạc quan cũng là đức tính giúp các bạn học tiếng Trung tốt '
  ];
  String idiom = '';
  double progress = 0;

  emitState() {
    if (isClosed) return;
    emit(state + 1);
  }

  load(String t) {
    type = t;
    firstText = 'Chờ một chút...';
    emit(0);
    progress = 0;
    if (type == 'download') {
      idiom = idiomDownload[Random().nextInt(idiomDownload.length)];
      firstText = 'Đang tải dữ liệu bài học...';
    } else if (type == 'wait') {
      idiom = idiomSubmit[Random().nextInt(idiomSubmit.length)];
      firstText = 'Đang tải dữ liệu lên server...';
    } else {
      idiom = idiomSubmit[Random().nextInt(idiomSubmit.length)];
      firstText = 'Đang chờ nộp bài...';
    }
    emitState();
  }

  update(double pro) {
    progress = pro;
    if (progress == 100) {
      firstText = 'Đã hoàn thành';
    }
    emitState();
  }
}
