import 'package:sae_chang/models/skill_models/reading.dart';

import 'flash_card_model.dart';
import 'item_learn_model.dart';

class Grammar {
  final String _note;
  final String mean;
  final String _structure;
  final String _uses;
  final String _signal;
  final int id;
  final String title;
  final int lessonId;
  final String video;
  final String example;
  final String example_mean;
  final List<QuestionReading> questions;
  final String keyPrefix;
  Grammar(
      {required note,
      required this.mean,
      required structures,
      required uses,
      required signal,
      required this.id,
      required this.title,
      required this.lessonId,
       this.questions = const [],
      required this.example_mean,
      required this.example,
        this.keyPrefix = '',
      required this.video})
      : _note = note,
        _signal = signal,
        _structure = structures,
        _uses = uses;

  factory Grammar.fromJson(Map<String, dynamic> json) {
    return Grammar(
      note: json['note'] ?? '',
      signal: json['signal'] ?? json['signal_vi'] ?? '',
      mean: json['mean'] ?? json['title_vi'] ?? '',
      structures: json['structures'] ?? json['structures_vi'] ??'',
      uses: json['uses'] ?? json['uses_vi'] ?? '',
      id: json['id'] ?? 0,
      questions: json["questions"] == null ? [] : List<QuestionReading>.from(
          json["questions"].map((x) => QuestionReading.fromJsonV2(x))),
      title: json['title'] ?? '',
      lessonId: json['lessonId'] ?? json['lesson_id'] ?? 0,
      video: json['video'] ?? '',
      example: json['example'] ?? '',
      example_mean: json['example_mean'] ?? json['example_vi'] ?? '',
    );
  }
  factory Grammar.fromJsonV1(Map<String, dynamic> json) {
    return Grammar(
      note: json['note'] ?? '',
      signal: json['signal'] ?? json['signal_vi'] ?? '',
      mean: json['mean'] ?? json['title_vi'] ?? '',
      structures: json['structures'] ?? json['structures_vi'] ??'',
      uses: json['uses'] ?? json['uses_vi'] ?? '',
      id: int.tryParse(json['id'].toString())??0,
      title: json['title'] ?? '',
      questions: json["questions"] == null ? [] : List<QuestionReading>.from(
          json["questions"].map((x) => QuestionReading.fromJsonV2(x))),
      lessonId: int.tryParse(json['lessonId'].toString())?? int.tryParse(json['lesson_id'].toString()) ?? 0,
      video: json['video'] ?? '',
      example: json['example'] ?? '',
      example_mean: json['example_mean'] ?? json['example_vi'] ?? '',
    );
  }
  factory Grammar.fromJsonV2(Map<String, dynamic> json, List<QuestionReading> list) {
    return Grammar(
      note: json['note'] ?? '',
      signal: json['signal'] ?? json['signal_vi'] ?? '',
      mean: json['mean'] ?? json['title_vi'] ?? '',
      structures: json['structures'] ?? json['structures_vi'] ??'',
      uses: json['uses'] ?? json['uses_vi'] ?? '',
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      questions: list,
      lessonId: int.tryParse(json['lessonId'].toString()) ??  int.tryParse(json['lesson_id'].toString()) ?? 0,
      video: json['video'] ?? '',
      example: json['example'] ?? '',
      example_mean: json['example_mean'] ?? json['example_vi'] ?? '',
    );
  }
  int get getLessonId => lessonId != 0 ? lessonId : lessonId;
  FlashCardModel get grammarFlashcard {
    var flashCardModel =
    FlashCardModel(
        id: id,
        lessonId: lessonId,
        skillId: 2,
        titleFront:  title,
        titleBack: mean,
        textFront: example,
        textBack: example_mean,
        imageFront: '',
        imageBack: '',
        soundFront: '',
        soundBack: '',
        columnBack: '');
    return flashCardModel;
  }

  String get structureFav {
    return _structure;
  }
  String get noteFav {
    return _note;
  }
  String get signalFav {
    return _signal;
  }
  String get usesFav {
    return  _uses;
  }
  String get structure {
    // debugPrint(_structure);

    // if (Languages.current == Language.English) {
    //   _structure = _structure.replaceAll(RegExp("<<<.*?>>>"), "");
    // }
    return (fixGrammar(_structure)
            .replaceAll("/ ", "/")
            .replaceAll("/", "{/}")
            // .replaceAll("<", "@")
            .replaceAll("<", "@")
            .replaceAll(">", "#")
            .replaceAll("\n", "</br>")
            .replaceAll("(|", "<ruby>")
            .replaceAll("|)", "</rt></ruby>")
            .replaceAll("|", "<rt>")
            .replaceAll("{{", "{\u2605} <em>")
            .replaceAll("}}", "</em>")
            .replaceAll("@@@", "<i>(")
            .replaceAll("###", ")</i>")
            .replaceAll("@@", "<s><del>")
            .replaceAll("##", "</del></s>")
            .replaceAll("@", "<u>")
            .replaceAll("#", "</u>")
            // .replaceAll("\$", "<u>")
            // .replaceAll("\%", "</u>")
            .replaceAll("[[", "<strong>")
            .replaceAll("]]", "</strong>")
            .replaceAll("[", "<b>")
            .replaceAll("] ", " </b>")
            .replaceAll("]", "</b>")
            .replaceAll("{", "<font>")
            .replaceAll("} ", " </font>")
            .replaceAll("}", "</font>"))
        // +'<var>a<sup>2</sup>'
        ;
  }

  String get uses {
    // debugPrint(_uses);

    // if (Languages.current == Language.English) {
    //   _uses = _uses.replaceAll(RegExp("<<<.*?>>>"), "");
    // }

    // _uses = '<ruby>読読<rt>よ</rt>む</ruby>';
    return fixGrammar(_uses)
        .trim()
        .replaceAll("<", "@")
        .replaceAll(">", "#")
        .replaceAll("\n", "</br>")
        .replaceAll("(|", "<ruby>")
        .replaceAll("|)", "</rt></ruby>")
        .replaceAll("|", "<rt>")
        .replaceAll("{{", "<font>")
        .replaceAll("}}", "</font>")
        .replaceAll("{", "<font>")
        .replaceAll("}", "</font>")
        .replaceAll("@@@", "<i>(")
        .replaceAll("###", ")</i>")
        .replaceAll(" @", "<u> ")
        .replaceAll("@", "<u>")
        .replaceAll("# ", " </u>")
        .replaceAll("#", "</u>")
        .replaceAll("[[[", "<em>")
        .replaceAll("]]]", "</em>")
        .replaceAll("[[", "<strong>")
        .replaceAll("]]", "</strong>")
        .replaceAll("[", "<b>")
        .replaceAll("]", "</b>");

    // return '''<ruby>xxx<rt></rt></ruby><ruby xml:lang="zh-Hant" style="ruby-position: under;">
    //
    // xxx<rt>Malaysia</rt>
    // <rbc>
    // <rb>馬</rb><rp>(</rp><rt>mǎ</rt><rp>)</rp>
    // <rb>來</rb><rp>(</rp><rt>lái</rt><rp>)</rp>
    // <rb>西</rb><rp>(</rp><rt>xī</rt><rp>)</rp>
    // <rb>亞</rb><rp>(</rp><rt>yà</rt><rp>)</rp>
    // </rbc>
    // <rtc xml:lang="en" style="ruby-position: over;">
    // <rp>(</rp><rt>Malaysia</rt><rp>)</rp>
    // </rtc>
    // </ruby>''';
  }

  String get note {
    // debugPrint(_note);

    // if (Languages.current == Language.English) {
    //   _note = _note.replaceAll(RegExp("<<<.*?>>>"), "");
    // }

    return fixGrammar(_note)
        .trim()
        .replaceAll("<", "@")
        .replaceAll(">", "#")
        .replaceAll("(|", "<ruby>")
        .replaceAll("|)", "</rt></ruby>")
        .replaceAll("|", "<rt>")
        .replaceAll("\n", "</br>")
        .replaceAll("{{", "<font>")
        .replaceAll("}}", "</font>")
        .replaceAll(" {", "<font> ")
        .replaceAll("{", "<font>")
        .replaceAll("} ", " </font>")
        .replaceAll("}", "</font>")
        .replaceAll("@@@", "<i>(")
        .replaceAll("###", ")</i>")
        .replaceAll("@", "<u>")
        .replaceAll("#", "</u>")
        // .replaceAll("\$", "<u>")
        // .replaceAll("\%", "</u>")
        .replaceAll("[[", "<strong>")
        .replaceAll("]]", "</strong>")
        .replaceAll("[", "<b>")
        .replaceAll("]", "</b>");
  }

  String get signal {
    // if (Languages.current == Language.English) {
    //   _signal = _signal.replaceAll(RegExp("<<<.*?>>>"), "");
    // }
    return fixGrammar(_signal)
        .trim()
        .replaceAll("<", "@")
        .replaceAll(">", "#")
        .replaceAll("\n", "</br>")
        .replaceAll("(|", "<ruby>")
        .replaceAll("|)", "</rt></ruby>")
        .replaceAll("|", "<rt>")
        .replaceAll("{{", "<em>")
        .replaceAll("}}", "</em>")
        .replaceAll("{", "<font>")
        .replaceAll("}", "</font>")
        .replaceAll("@@@", "<i>(")
        .replaceAll("###", ")</i>")
        .replaceAll("@", "<u>")
        .replaceAll("#", "</u>")
        // .replaceAll("\$", "<u>")
        // .replaceAll("\%", "</u>")
        .replaceAll("[[", "<strong>")
        .replaceAll("]]", "</strong>")
        .replaceAll("[", "<b>")
        .replaceAll("]", "</b>");
  }


  bool? _isClick;
  bool get isClick => _isClick ?? false;



  set isClick(bool value) {
    _isClick = value;
  }

  bool? _isHighlight;
  bool get isHighlight => _isHighlight ?? false;

  set isHighlight(bool value) {
    _isHighlight = value;
  }

  ItemLearnGrammar  get itemLearn => ItemLearnGrammar(id, this);


}

String fixGrammar(String value) {
  return value.replaceAllMapped(
    RegExp(r'\{([^|}]*)\|([^}]+)\}'),
        (Match match) {
      if(match.group(1)!.contains('(|') || match.group(2)!.contains('|)')){
        return '{${match.group(1)}|${match.group(2)}}';
      }
      return '{(|${match.group(1)}|${match.group(2)}|)}';
    },
  );


}