import 'dart:io';

import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/models/skill_models/word.dart';
import 'package:sae_chang/providers/download/vocabulary_provider.dart';
import 'package:sae_chang/services/media_service.dart';

class CircleButtonPlaySound extends StatelessWidget {
  const CircleButtonPlaySound({super.key,
    required this.word,
    required this.size,
    required this.playSound, required this.dir});
  final Word word;
  final Size size;
  final bool playSound;
  final String dir;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: Key(word.id.toString()),
      create: (context) => PlayFirstCubit(word, playSound,dir)..load(),
      child: BlocBuilder<PlayFirstCubit, int>(
        builder: (context, state) {
          var cubit = context.read<PlayFirstCubit>();
          return Container(
              height: size.height,
              width: size.width,
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0.0, 0.0),
                    spreadRadius: 0,
                    blurRadius: 5,
                  )
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => cubit.playSoundImage(word),
                    child: Image.asset(
                      'assets/icons/ic_sounder.png',
                      color: primaryColor,
                    )),
              ));
        },
      ),
    );
  }
}

class PlayFirstCubit extends Cubit<int> {
  PlayFirstCubit(this.word, this.playSound, this.dir) : super(0);
  final Word word;
  final bool playSound;
  final String dir;
  load() async  {
    if(playSound) {
      await playSoundImage(word);
    }
    emit(state + 1);
  }

  playSoundImage(Word word) async {
    final repo = VocabularyProvider.instance;
    String path = word.pathAudio.isNotEmpty ? word.pathAudio : repo
        .getUrlAudioById(word.id.toString(),dir);
    if (File(path).existsSync()) {
      await MediaService.instance.playFile(path);
    }
  }
}