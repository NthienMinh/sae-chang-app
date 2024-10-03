import 'package:sae_chang/models/skill_models/reading.dart';
import 'package:sae_chang/models/skill_models/sentences.dart';
import 'package:sae_chang/models/skill_models/speaking.dart';

import 'grammar.dart';
import 'lesson.dart';

abstract class ItemLearnModel {
  final int id;
  ItemLearnModel(this.id);

  bool? _isRemember;

  bool get remembered => _isRemember ?? false;

  set remembered(bool isRemember) {
    _isRemember = isRemember;
  }
}


class ItemLearnGrammar extends ItemLearnModel {
  final Grammar item;

  ItemLearnGrammar(super.id, this.item);
}



class ItemLearnSpeaking extends ItemLearnModel {
  final SpeakingModel item;
  ItemLearnSpeaking(super.id, this.item);
}

class ItemLearnListening extends ItemLearnModel {
  final Lesson item;

  ItemLearnListening(super.id, this.item);
}


class ItemLearnSentenceListening extends ItemLearnModel {
  final Sentences item;
  final Lesson lesson;

  ItemLearnSentenceListening(super.id, this.item, this.lesson);
}
class ItemLearnReading extends ItemLearnModel {
  final Reading item;

  ItemLearnReading(super.id, this.item);
}

class ItemLearnSkill extends ItemLearnModel {
  final String title;
  final String mean;
  final String? pathAudio;

  ItemLearnSkill(super.id, this.title, this.mean, {this.pathAudio});
}

class ItemLearnSentenceReading extends ItemLearnModel {
  final Sentence item;
  final Reading reading;

  ItemLearnSentenceReading(super.id, this.item, this.reading);
}