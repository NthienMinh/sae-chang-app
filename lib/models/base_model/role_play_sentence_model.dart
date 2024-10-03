class RolePlaySentenceModel {
  final String sentence;
  final double position;

  static List<RolePlaySentenceModel> fromScript(String question) =>
      question.contains('[[')
          ? (question.split('[[')..removeAt(0))
          .map((e) {
        return RolePlaySentenceModel.fromString(e);
      })
          .toList()
          : [];

  factory RolePlaySentenceModel.fromString(String string) {
    String s = '';
    double p = 0;
    var temp = string.split(']]');
    if (temp.length == 2) {
      s = temp[1];
      var temp2 = temp[0].split(":");
      p = (double.parse(temp2[0]) * 60 + double.parse(temp2[1])) * 1000;
    }

    return RolePlaySentenceModel(s, p);
  }

  RolePlaySentenceModel(this.sentence, this.position);
}