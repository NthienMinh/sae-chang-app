class AppConfigs {
  static int countDraw = 0;
  static String currentRoute = '';
  static const bool isRunningDebug = false;
  static bool isFirstOpen = true;
  static const String endpoint = "http://173.199.127.90:3000";
  static const passwordUnzip = 'Aa@12345';
  static String getTestUrl(int testId, String token){
    return "$endpoint/api/v1/mobile/static/get/?token=$token&name=test_$testId.zip";
  }
  static String getBTVNUrl(int lessonId, String token){
    return "$endpoint/api/v1/mobile/static/get/?token=$token&name=btvn_$lessonId.zip";
  }

  static String getUrl(int id, String token, String folder){
    return "$endpoint/api/v1/mobile/static/get/?token=$token&name=${folder}_$id.zip";
  }


  static const String KEY_LISTENING_BLUR = 'listening_blur';
  static const String KEY_LISTENING_TRANSLATE = 'listening_translate';
  static const String KEY_LISTENING_PHONETIC = 'listening_phonetic';
  static const String KEY_LISTENING_FURIGANA = 'listening_furigana';
}