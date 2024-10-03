import 'dart:io';

import 'package:video_player/video_player.dart';

class VideoService {
  VideoService._privateConstructor();

  static final VideoService _instance = VideoService._privateConstructor();

  static VideoService get instance => _instance;

  VideoPlayerController? _playerController;

  VideoPlayerController newPlayer(String url) {
    if (_playerController != null) {
      if (_playerController!.value.isPlaying) {
        _playerController!.pause();
      }
      _playerController!.dispose();
    }

    _playerController = VideoPlayerController.file(File(url));
    return _playerController!;
  }

  VideoPlayerController? get player => _playerController;

  play(){
    if(_playerController != null){
      _playerController!.play();
    }
  }

  pause(){
    if(_playerController != null){
      _playerController!.pause();
    }
  }
  setVolume(
      double value,
      ) {
    _playerController!.setVolume(value);
  }
  dispose(){
    _playerController!.dispose();
  }
}