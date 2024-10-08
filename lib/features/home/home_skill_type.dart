

import 'package:sae_chang/configs/text_configs.dart';

enum HomeSkillType {
  vocabulary,
  grammar,
  listening,
  reading

}

extension HomeSkillExtension on HomeSkillType {
  String get icon {
    switch (this) {
      case HomeSkillType.vocabulary:
        return 'assets/icons/ic_learn_9.png';
      case HomeSkillType.listening:
        return 'assets/icons/ic_learn_10.png';
      case HomeSkillType.reading:
        return 'assets/icons/ic_learn_6.png';
      case HomeSkillType.grammar:
        return 'assets/icons/ic_learn_8.png';
      default:
        return 'assets/images/img_logo.png';
    }
  }

  String get iconWhite {
    switch (this) {
      case HomeSkillType.vocabulary:
        return 'assets/icons/ic_home_vocabulary_white.png';
      case HomeSkillType.listening:
        return 'assets/icons/ic_home_listening_white.png';
      case HomeSkillType.reading:
        return 'assets/icons/ic_home_reading_white.png';
      case HomeSkillType.grammar:
        return 'assets/icons/ic_home_grammar_white.png';
      default:
        return 'assets/images/img_logo_2.png';
    }
  }

  String get iconColor {
    switch (this) {
      case HomeSkillType.vocabulary:
        return 'assets/icons/ic_home_vocabulary_color.png';
      case HomeSkillType.grammar:
        return 'assets/icons/ic_home_grammar_color.png';
      default:
        return 'assets/images/img_logo_2.png';
    }
  }



  String get title {
    switch (this) {
      case HomeSkillType.vocabulary:
        return AppText.txtVocabulary.text;
      case HomeSkillType.listening:
        return AppText.txtListening.text;
      case HomeSkillType.reading:
        return AppText.txtReading.text;
      default:
        return AppText.txtGrammar.text;
    }
  }
}

enum HomeCategory {
  yourCourse,
  recommendCourse,
  promotion,
}

extension HomeCategoryExtension on HomeCategory {
  String get title {
    switch (this) {
      case HomeCategory.yourCourse:
        return AppText.txtYourCourse.text;
      case HomeCategory.promotion:
        return AppText.txtPromotion.text;
      case HomeCategory.recommendCourse:
        return AppText.txtRecommendCourse.text;
      default:
        return AppText.txtGeneralKnowledge.text;
    }
  }

  String get icon {
    switch (this) {
      case HomeCategory.yourCourse:
        return 'assets/icons/ic_home_course_1x.png';
      case HomeCategory.promotion:
        return 'assets/icons/ic_home_promotion.png';
      case HomeCategory.recommendCourse:
        return 'assets/icons/ic_home_course_2x.png';
      default:
        return 'assets/images/img_logo_2.png';
    }
  }

}
