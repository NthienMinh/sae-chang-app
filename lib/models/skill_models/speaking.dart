class SpeakingModel {
  final int id, lessonId, type;
  final String audio, image, sentence, text, highlight, hide, vi;
  SpeakingModel({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.audio,
    required this.image,
    required this.sentence,
    required this.text,
    required this.vi,
    required this.hide,
    required this.highlight,
  });

  factory SpeakingModel.fromMap(
      Map<String, dynamic> data) {
    return SpeakingModel(
      id: int.tryParse(data["id"].toString()) ?? 0,
      lessonId: int.tryParse(data["lesson_id"].toString()) ?? 0,
      type: int.tryParse(data["type"].toString()) ?? 0,
      highlight: data["highlight"] ?? '',
      audio: data["audio"] ?? '',
      image: data["image"] ?? '',
      text: data["text"] ?? '',
      vi: data["vi"] ?? '',
      hide: data["hide"] ?? '',
      sentence:  data["sentence"] ?? '',
    );
  }

  List<String> get getListWords {
    RegExp regExp = RegExp(r'\{(.*?)\}');
    // Find all matches and extract the text inside {}
    Iterable<Match> matches = regExp.allMatches(text);
    return matches.map((match) => match.group(1)!).toList();
  }

  List<String> get underline {
   return highlight.split(';');
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
}