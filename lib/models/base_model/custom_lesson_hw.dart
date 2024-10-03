class CustomLessonHw {
  final double hw;
  final int lessonId;

  CustomLessonHw(this.hw, this.lessonId);

  CustomLessonHw copyWith({double? hw, int? lessonId}) {
    return CustomLessonHw(
      hw ?? this.hw,
      lessonId ?? this.lessonId,
    );
  }

  factory CustomLessonHw.fromMap(Map<dynamic, dynamic> map) {
    return CustomLessonHw(
      map['hw'] == null ? 0 : double.parse(map['hw'].toString()),
      map['lesson_id'] == null ? 0 : map['lesson_id'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'hw': hw,
      'lesson_id': lessonId,
    };
  }
}