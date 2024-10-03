import 'dart:io';

import 'package:sae_chang/models/base_model/question_model.dart';





class CustomCheck {
  static bool isVietnameseCharacter(String character) {
    final RegExp regex = RegExp(r'^[a-zA-ZÀ-ỹĂ-ửẠ-ỹẰ-ỶẢ-ỸẲ-ỶÂ-ỬĂ-ỰĐđĨŨẼỄỖỐ0-9!@#\$%^&*(),.?":{}|<>+=\-\[\]\\/\s]*$');
    return regex.hasMatch(character);
  }

  static String getId(String s) {
    int lastDotIndex = s.lastIndexOf('.');
    if (lastDotIndex != -1) {
      return  s.substring(0, lastDotIndex); // Lấy phần tử từ đầu đến dấu chấm cuối cùng
    } else {
      return s;
    }
  }

  static String getFlashCardImage(String input, String dir) {
    var id = getId(input);

    List<String> imageExtensions = ['.png', '.jpeg', '.jpg', '.gif', '.bmp', '.webp'];

    for (var extension in imageExtensions) {
      var filePath = "$dir$id$extension";

      if (File(filePath).existsSync()) {
        return filePath;
      }
    }

    return '';
  }
  static String getAudioLink(String input,String dir, [String path = '']) {

    if(path.isNotEmpty && File(path).existsSync()){
      return path;
    }
    var id = getId(input);
    List<String> audioExtensions = ['.mp3', '.oga', '.ogg', '.wav', '.aac'];

    for (var extension in audioExtensions) {
      var filePath = "$dir$id$extension";

      if (File(filePath).existsSync()) {
        return filePath;
      }
    }
    return '';
  }

  static String getAnswer(QuestionModel q) {
    if (q.answer == '1') {
      return q.a;
    } else if (q.answer == '2') {
      return q.b;
    } else if (q.answer == '3') {
      return q.c;
    } else if (q.answer == '4') {
      return q.d;
    } else {
      return '';
    }
  }
}