import 'package:flutter/Material.dart';
import 'package:record/record.dart';
import 'package:sae_chang/screens/login/login_screen.dart';
import 'package:sae_chang/screens/splash/splash_screen.dart';

import 'configs/app_configs.dart';

class Routes {
  static const splash = "/";
  static const login = "/login";
  static const forgotPass = "/forgotPass";
  static const home = "/home";
  static const chooseLevel = "/chooseLevel";
  static const setting = "/setting";
  static const detailClass = "/detailClass";
  static const practice = "/practice";
  static const result = "/result";
  static const fullScreen = "/fullScreen";
  static const lesson = "/lesson";
  static const practiceListening = '/practiceListening';
  static const practiceListeningDetail = '/practiceListeningDetail';
  static const reading = '/reading';
  static const readingDetail = '/readingDetail';
  static const vocabulary = '/vocabulary';
  static const grammar = '/grammar';
  static const grammarDetail = '/grammarDetail';
  static const flashCard = '/flashCard';
  static const wordFlashcard = '/wordFlashcard';

  static Route? generateRoute(RouteSettings settings) {
    AppConfigs.currentRoute = settings.name ?? '';

    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());

      case Routes.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      // case Routes.forgotPass:
      //   return MaterialPageRoute(
      //       builder: (context) => const ForgotPassScreen());

      // case Routes.chooseLevel:
      //   return MaterialPageRoute(builder: (context) => ChooseLevelScreen());
      //
      // case Routes.home:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //       builder: (context) => HomeScreen(title: map['level']));
      //
      // case Routes.setting:
      //   return MaterialPageRoute(builder: (context) => const SettingScreen());
      //
      // case Routes.detailClass:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //       builder: (context) =>
      //           DetailClassScreen(userClass: map['user_class'], classModel: map['class_model'], courseModel: map['course_model']));
      //
      // case Routes.practice:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //       builder: (context) => PracticeScreen(
      //             id: map['id'],
      //             type: map['type'],
      //             resultId: map['resultId'],
      //             dataId: map['dataId'],
      //             duration: map['duration'],
      //             isOffline: map['isOffline'],
      //             userId: map['userId'],
      //             classId: map['classId'],
      //           ));
      // case Routes.result:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //       builder: (context) => ResultScreen(
      //             id: map['id'],
      //             type: map['type'],
      //             resultId: map['resultId'],
      //             dataId: map['dataId'],
      //             isOffline: map['isOffline'],
      //             userId: map['userId'],
      //             classId: map['classId'],
      //             score: map['score'],
      //           ));
      // case Routes.fullScreen:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //     settings: settings,
      //     builder: (context) => ImageFullScreenList(
      //       imageList: map['imageList'],
      //       init: map['init'],
      //       type: map['type'],
      //       dir: map['dir'],
      //     ),
      //   );
      // case Routes.lesson:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //     builder: (context) => ResponsiveLayout(
      //       mobileLayout: LessonClassView(
      //         lesson: map['lesson'],
      //         teacherNote: map['teacherNote'],
      //         reload: map['reload'],
      //         userClass: map['userClass'],
      //         hw: map['hw'],
      //         classModel: map['class'],
      //         lessonState: map['studentLesson'],
      //       ),
      //       tabletLayout: LessonClassView(
      //         lesson: map['lesson'],
      //         teacherNote: map['teacherNote'],
      //         reload: map['reload'],
      //         userClass: map['userClass'],
      //         hw: map['hw'],
      //         classModel: map['class'],
      //         lessonState: map['studentLesson'],
      //       )
      //     ),
      //   );
      // case Routes.practiceListening:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //     builder: (c) => PracticeListeningScreen(
      //         lessonId: map['lessonId'],
      //         classId: map['classId'],
      //         update: map['update'],
      //         status: map['status'] ?? -2),
      //   );
      // case Routes.practiceListeningDetail:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //     builder: (c) => PracticeListeningDetailScreen(
      //       positionNow: map['positionNow'],
      //       lesson: map['lesson'],
      //       audioRecorder: AudioRecorder(),
      //       cubit: map['listeningCubit'],
      //     ),
      //   );
      // case Routes.reading:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //     builder: (c) => ReadingScreen(
      //         lessonId: map['lessonId'],
      //         classId: map['classId'],
      //         update: map['update'],
      //         status: map['status'] ?? -2),
      //   );
      // case Routes.readingDetail:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //     builder: (c) => ReadingDetailScreen(
      //       rCubit: map['rCubit'],
      //       reading: map['reading'],
      //       isGetData: map['isGetData'],
      //     ),
      //   );
      // case Routes.vocabulary:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //     builder: (c) => VocabularyScreen(
      //         lessonId: map['lessonId'],
      //         classId: map['classId'],
      //         update: map['update'],
      //         status: map['status'] ?? -2
      //     ),
      //   );
      //
      // case Routes.grammar:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //     builder: (c) => GrammarScreen(
      //         lessonId: map['lessonId'],
      //         classId: map['classId'],
      //         update: map['update'],
      //         status: map['status'] ?? -2
      //     ),
      //   );
      //
      // case Routes.grammarDetail:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //     builder: (c) => GrammarDetailScreen(
      //       grammar: map['grammar'],
      //       lessonId: map['lessonId'],
      //       grammars: map['grammars'] ?? [],
      //     ),
      //   );
      //
      // case Routes.flashCard:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //     builder: (context) => FlashCardScreen(
      //       lesson: map['lessonId'],
      //       classModel: map['class']
      //     ),
      //   );
      //
      // case Routes.wordFlashcard:
      //   Map map = settings.arguments as Map;
      //   return MaterialPageRoute(
      //     builder: (c) => WordFlashCardScreen(
      //       listWord: map['listWord'],
      //       lessonId: map['lessonId'],
      //     ),
      //   );
    }
    return null;
  }
}
