import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/services/progress_service.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

import 'configs/app_configs.dart';
import 'features/bloc/connect_cubit.dart';
import 'features/home/user_class_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  ApplicationState createState() => ApplicationState();
}

class ApplicationState extends State<MyApp> {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isTablet = Resizable.isTablet(context);
      if (isTablet) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    });
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      debugPrint('connect: $result');
      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.ethernet) ||
          result.contains(ConnectivityResult.vpn)) {
        ConnectCubit.instance.update(true);
        //_messengerKey.currentState!.hideCurrentSnackBar();
        if(!AppConfigs.isFirstOpen){
          _messengerKey.currentState!.showSnackBar(SnackBar(
              duration: const Duration(milliseconds: 2500),
              backgroundColor: const Color(0xff464646),
              elevation: Resizable.padding(context, 10),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
              ),
              content: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 5)),
                  child: Center(
                      child: Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 10)),
                              child: const Icon(Icons.wifi,
                                  color: Colors.green)),
                          AutoSizeText("Đã khôi phục INTERNET",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Resizable.size(context, 18)))
                        ],
                      )))));
        }
      } else {
        AppConfigs.isFirstOpen = false;
        ConnectCubit.instance.update(false);
        _messengerKey.currentState!.hideCurrentSnackBar();
        _messengerKey.currentState!.showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 2500),
            backgroundColor: const Color(0xff464646),
            elevation: Resizable.padding(context, 10),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Resizable.size(context, 20)),
            ),
            content: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Resizable.padding(context, 5)),
                child: Center(
                    child: Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Resizable.padding(context, 10)),
                            child: const Icon(Icons.wifi_off_rounded,
                                color: Colors.white)),
                        AutoSizeText("Mất kết nối INTERNET",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Resizable.size(context, 18)))
                      ],
                    )))));
      }
    });

    super.initState();
  }

  @override
  void dispose() async {
    await subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ConnectCubit>(
            create: (BuildContext context) => ConnectCubit.instance,
          ),
          BlocProvider<UserClassCubit>(
            create: (BuildContext context) => UserClassCubit.instance,
          ),
          BlocProvider<ProgressCubit>(
            create: (BuildContext context) => ProgressCubit(),
          ),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: _messengerKey,
          navigatorKey: NavigationService.navigatorKey,
          locale: DevicePreview.locale(context),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1),
              ),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: 1.0,
                fontFamily: "Montserrat",
              ),
              useMaterial3: false
          ),
          navigatorObservers: [
            defaultLifecycleObserver,
          ],
          initialRoute: Routes.splash,
          onGenerateRoute: Routes.generateRoute,
        ));
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}