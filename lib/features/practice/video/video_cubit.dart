import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/services/video_service.dart';

import 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit(
    String url, {
    bool autoPlay = false,
    bool controlsVisible = false,
  }) : super(VideoState.initialize(
          url: url,
          autoPlay: autoPlay,
          controlsVisible: controlsVisible,
        )) {
    VideoService.instance.newPlayer(url).initialize().then((_) {
      VideoService.instance.player!.setLooping(true);
      emit(state.copyWith(
        loaded: true,
      ));
      if (autoPlay) {
        VideoService.instance.play();
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }

    });
  }

  void togglePlay() {
    state.playing
        ? VideoService.instance.pause()
        : VideoService.instance.play();
    emit(state.copyWith(
      playing: !state.playing,
    ));
  }

  void toggleControlsVisibility() {
    emit(state.copyWith(
      controlsVisible: !state.controlsVisible,
    ));

    if (state.controlsNotVisible && state.notPlaying) {
      togglePlay();
    }
  }

  void setVolume(
    double value,
  ) {
    VideoService.instance.setVolume(value);
    emit(state.copyWith(
      volume: value,
    ));
  }

  void toggleMute() {
    var newState = state.copyWith(
      volume: state.mute ? state.volumeBeforeMute : 0,
      volumeBeforeMute: state.notMute ? state.volume : state.volumeBeforeMute,
    );
    VideoService.instance.setVolume(newState.volume);
    emit(newState);
  }
}
