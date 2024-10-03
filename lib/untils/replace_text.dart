class ReplaceText {
  static String replaceCharacterJapan(String temp) {
    return temp.replaceAll('／', '/')
        .replaceAll('（', '(')
        .replaceAll('）', ')')
        .replaceAll('［', '[')
        .replaceAll('］', ']')
        .replaceAll('＜', '<')
        .replaceAll('＞', '>')
        .replaceAll('｜', '|')
        .replaceAll('；', ';')
        .replaceAll('\u2026', '')
        .replaceAll('：', ':');
  }
}