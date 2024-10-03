import 'package:path_provider/path_provider.dart';

class ApplicationSingleton {
  late String _rootDir;

  static final ApplicationSingleton _singleton = ApplicationSingleton._internal();

  factory ApplicationSingleton() {
    return _singleton;
  }

  Future<void> initialize() async {
    _rootDir = (await getApplicationDocumentsDirectory()).path;
  }

  String get rootDir {
    return _rootDir;
  }
  ApplicationSingleton._internal();
}
