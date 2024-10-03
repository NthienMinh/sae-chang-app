class SplitText {
  List<String> splitJapanese(String text) {
    List<String> a = [];
    List<String> pairs = text.split('}');
    for(int i = 0 ; i< pairs.length; i++)
    {
      var k = pairs[i].split('{');
      for(int n =0 ; n< k.length;n++) {
        a.add(k[n]);
      }
    }
    return a;
  }
  List<String> splitFuriganaVoc(String text) {
    return text.split(',');
  }
  String getBehind(String pair) {
    return pair.substring(pair.indexOf('|') + 1, pair.length).trim();
  }

  String getFront(String pair) {
    return pair.substring(0, pair.indexOf('|')).trim();
  }

  List<String> extractPathDataList(String inputString) {
    final regex = RegExp(r'<path d="([^"]+)"\/>');
    final matches = regex.allMatches(inputString);

    final pathDataList = <String>[];
    for (final match in matches) {
      final pathData = match.group(1);
      pathDataList.add(pathData!);
    }

    return pathDataList;
  }

  List<String> extractRhythmKanji(String text) {
    return text.split('/');
  }
  List<int> extractVocabularies(String text) {
    var listVoc = <int>[];
    final list = text.split(';');
    for(var item in list){
      listVoc.add(int.parse(item.trim()));
    }
    return listVoc;
  }

  List<String> splitGrammarString(String input) {
    try {

      List<String> parts = [];
      final RegExp pattern = RegExp(r'(\{.*?\}|<.*?>|。|[^<{}。]+)');

      for (RegExpMatch match in pattern.allMatches(input)) {
        parts.add(match.group(0)!);
      }

      return parts;
    }
    catch (e) {
      return [input];
    }
  }
  List<Map<String, dynamic>> splitSentence(String japaneseText) {
   try {
     List<Map<String, dynamic>> resultList = [];

     int start = 0;
     int end = -1;

     for (int i = 0; i < japaneseText.length; i++) {
       if (japaneseText[i] == '[' || japaneseText[i] == '{') {
         start = i + 1;
       } else if (japaneseText[i] == ']' || japaneseText[i] == '}') {
         String previous = japaneseText.substring(end +1 , start - 1);
         resultList.add({
           'text': previous,
           'highlight': false,
         });
         end = i;
         String segment = japaneseText.substring(start, end);
         resultList.add({
           'text': segment,
           'highlight': true,
         });
       }

       if(i == japaneseText.length - 1 && i != end) {
         String segment = japaneseText.substring(end + 1 , japaneseText.length);
         resultList.add({
           'text': segment,
           'highlight': false,
         });
       }
     }
     return resultList;
   }
   catch (e) {
     return [
       {
         'text': japaneseText,
         'highlight': false,
       }
     ];
   }
  }

  String getId(String s) {
    int lastDotIndex = s.lastIndexOf('.');
    if (lastDotIndex != -1) {
      return  s.substring(0, lastDotIndex); // Lấy phần tử từ đầu đến dấu chấm cuối cùng
    } else {
      return s;
    }
  }

  List<String> splitKaiwaString(String input) {
    try {
      List<String> parts = [];
      final RegExp regex =   RegExp(r'\S+\|\S+|\S+');
      for (RegExpMatch match in regex.allMatches(input)) {
        parts.add(match.group(0)!);
      }
      return parts;
    }
    catch (e) {
      return [input];
    }
  }

  List<String> splitMatchColumn(String input, String separator) {
    List<String> resultList = [];
    StringBuffer currentToken = StringBuffer();
    int nestedLevel = 0;

    for (int i = 0; i < input.length; i++) {
      if (input[i] == '{') {
        nestedLevel++;
      } else if (input[i] == '}') {
        nestedLevel--;
      }

      if (input[i] == separator && nestedLevel == 0) {
        resultList.add(currentToken.toString());
        currentToken.clear();
      } else {
        currentToken.write(input[i]);
      }
    }
    resultList.add(currentToken.toString());
    return resultList;
  }

  List<String> extractSentencesReading(String input) {
    List<String> parts = [];
    RegExp exp = RegExp(r'\[.*?\]');
    Iterable<Match> matches = exp.allMatches(input);

    int start = 0;
    for (Match match in matches) {
      if (match.start > start) {
        parts.add(input.substring(start, match.start));
      }
      parts.add(match.group(0)!);
      start = match.end;
    }

    if (start < input.length) {
      parts.add(input.substring(start));
    }

    return parts;
  }
}