import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/flashcard_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/flashcard/flashcard_view.dart';
import 'package:sae_chang/features/detail_class/lessons/time_custom_cubit.dart';
import 'package:sae_chang/models/base_model/class_model.dart';
import 'package:sae_chang/models/base_model/lesson_model.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/widgets/app_bar_template.dart';

class FlashCardScreen extends StatefulWidget {
  const FlashCardScreen({
    super.key,
    required this.lesson,
    required this.classModel,
  });

  final LessonModel lesson;
  final ClassModel classModel;

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  final HideButtonCubit hideButtonCubit = HideButtonCubit();
  final SwiperController swiperController = SwiperController();
  final SoundCubit soundCubit = SoundCubit();
  @override
  void dispose() {
    MediaService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TimeCustomCubit(widget.classModel.classId,widget.lesson.lessonId, 'flashcard'),
      child: BlocBuilder<TimeCustomCubit, int>(
        builder: (context, state) {
          final timeCubit = context.read<TimeCustomCubit>();
          return Scaffold(
              appBar:AppBarTemplate(widget.lesson.title, context),
              body: BlocProvider(
                  create: (context) => FlashCardCubit(
                      context, widget.lesson.lessonId,
                      swiperController,
                      soundCubit,
                      type: 'general')
                    ..load(),
                  child:  BlocBuilder<FlashCardCubit, int>(builder: (cc, i) {
                    if (i == 0) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
                    }
                    final flashCardCubit =
                    BlocProvider.of<FlashCardCubit>(cc);
                    return FlashCardView(
                      flashCardCubit: flashCardCubit,
                      hideButtonCubit: hideButtonCubit,
                      swiperController: swiperController,
                      soundCubit: soundCubit,
                      timeCubit: timeCubit,
                    );
                  })));
        },
      ),
    );
  }
}

class HideButtonCubit extends Cubit<bool> {
  HideButtonCubit() : super(true);

  update() async {
    emit(!state);
  }
}

class IndexCubit extends Cubit<int> {
  IndexCubit(this.index) : super(1);
  final int index;

  load(int index) {
    emit(index + 1);
  }
}
