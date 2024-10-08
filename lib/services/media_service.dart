import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/bloc/voice_record_cubit.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:video_player/video_player.dart';




class MediaService {
  MediaService._privateConstructor();

  static final MediaService _instance = MediaService._privateConstructor();

  static MediaService get instance => _instance;

  VideoPlayerController? _player;

  bool isMute = false;

  mute() {
    isMute = true;
  }

  unMute() {
    isMute = false;
  }


  bool checkExist() {
    if (_player != null) {
      return true;
    }
    return false;
  }
  VideoPlayerController newPlayer(String url, String type)   {

    if (_player != null ) {
      if (_player!.value.isPlaying) {
        _player!.pause();
      }
      _player!.dispose();
    }

    if(type == "network"){
      _player = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
            allowBackgroundPlayback: true
          ),
      )..initialize().then((value)  {
        debugPrint('init: ${_player!.value.duration}');
      });
    }
    else if (type == 'asset'){
      _player = VideoPlayerController.asset(
        url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true,allowBackgroundPlayback: true),
      )..initialize();
    }
    else {
      _player = VideoPlayerController.file(
        File(url),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true,allowBackgroundPlayback: true),
      )..initialize();
    }
    if(isMute) {
      _player!.setVolume(0);
    }
    return _player!;
  }
  Future<VideoPlayerController> newPlayerAsync(String url, String type)  async  {

    if (_player != null) {
      if (_player!.value.isPlaying) {
       await _player!.pause();
      }
      await _player!.dispose();
    }

    if(type == "network"){
      _player = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true,allowBackgroundPlayback: true),
      );
    }
    else if (type == 'asset'){
      _player = VideoPlayerController.asset(
        url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true,allowBackgroundPlayback: true),
      );
    }
    else {
      _player = VideoPlayerController.file(
        File(url),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true,allowBackgroundPlayback: true),
      );
    }

    await _player!.initialize();
    if(isMute) {
      _player!.setVolume(0);
    }
    return _player!;
  }
  VideoPlayerController getPlayer(){
    return _player!;
  }
  stop() {
    if (_player != null) {
      if (_player!.value.isPlaying) {
        _player!.pause();
      }
      _player!.dispose();
      _player = null;
    }
  }
  dispose(){
    if(_player != null){
      _player!.dispose();
      _player = null;
    }
  }
  setSpeed(double value) async {
    if(_player != null){
      _player!.setPlaybackSpeed(value);
    }
  }
  play(){
    if(_player != null){
      _player!.play();
    }
  }

  seek(Duration position) async {
    if(_player != null){
      debugPrint("========>seek to ${position.inMilliseconds.toDouble()} ");
      await _player!.seekTo(position);
      if(!_player!.value.isPlaying){
        _player!.play();
      }
    }
  }

  bool isPause(){

    if(_player?.value.isPlaying == false){
      return true;
    }
    return false;
  }
  resume(SoundCubit soundCubit) async {
    await _player!.play();
    await soundCubit.change(soundCubit.currentPosition);
  }
  pause(SoundCubit soundCubit) async {
    if(_player != null){
      _player!.pause();
    }
    soundCubit.currentPosition = soundCubit.state;

    await soundCubit.pause();
  }



  playSound(String sound, SoundCubit soundCubit, String type,{bool isPracticeSpeaking = false}) async {
    debugPrint("=======>$sound");
    debugPrint("=======>$type");

    if(isPracticeSpeaking) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    var player = newPlayer(sound, type);

    await soundCubit.loading();
    await soundCubit.changeActive(type, sound);


    player.play();

    player.addListener(() {
      soundCubit.duration = player.value.duration.inMilliseconds.toDouble();
      debugPrint('=>>>>${player.value.duration.inMilliseconds}');
      soundCubit.change(player.value.position.inMilliseconds.toDouble());
      if(player.value.duration == player.value.position && player.value.position.inMilliseconds.toDouble() != 0){
        soundCubit.change(soundCubit.duration);
        soundCubit.reStart();
        debugPrint("===========>completed");
        player.dispose();
      }
    });



  }
  playAndRecord(
      String sound,
      SoundCubit soundCubit,
      QuestionModel questionModel,
      PracticeBloc bloc,
      RolePlayStateCubit recordingStateCubit,
      VoiceRecordCubit voiceRecordCubit, String type) async {
    var player = newPlayer(sound , type);

    await soundCubit.loading();
    await soundCubit.changeActive(type, sound);

    debugPrint(
        "===========>voiceRecordCubit startRecord : ${soundCubit.duration}");
    int time = DateTime.now().millisecondsSinceEpoch;
    var res  = await  voiceRecordCubit.startRecord(
        "record_$time" );
    if(!res) {
      soundCubit.reStart();
      return;
    }
    player.play();
    player.addListener(() async {
      if(soundCubit.duration != player.value.duration.inMilliseconds.toDouble()) {
        soundCubit.duration = player.value.duration.inMilliseconds.toDouble();
        recordingStateCubit.change(1);
      }

      if ((player.value.position.inMilliseconds != 0 && player.value.isPlaying)) {
        soundCubit.change(player.value.position.inMilliseconds.toDouble());
      }
      if(player.value.duration == player.value.position && player.value.position.inMilliseconds.toDouble() != 0){
        debugPrint("===========>onPlayerComplete stop");
        await player.seekTo(Duration.zero);
        await player.pause();
        await voiceRecordCubit.stopRecord(questionModel, bloc, type);
        recordingStateCubit.change(0);
        soundCubit.change(0);
        soundCubit.reStart();
      }
    });
  }

  playFile(String url) {
    debugPrint('=>>>>>>>>>mediaPlay');
    debugPrint(url);
    var player = newPlayer(url, 'file');
    player.play();
  }

  playAsset(String url) {
    debugPrint('=>>>>>>>>>mediaPlay');
    var player = newPlayer(url, 'asset');
    player.play();
  }
}

class RolePlayStateCubit extends Cubit<int> {
  RolePlayStateCubit() : super(0);

  change(int i) {
    debugPrint('44444');
    emit(i);
  }
}
