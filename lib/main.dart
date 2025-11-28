import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/constants/color.dart';
import 'package:sample_app/enums/language.dart';
import 'package:sample_app/firebase_options.dart';
import 'package:sample_app/initialization/sample_app_init.dart';
import 'package:sample_app/localizations/codegen_loader.g.dart';
import 'package:sample_app/providers/app_state_manager.dart';
import 'package:sample_app/routing/app_route_parser.dart';
import 'package:sample_app/routing/app_router.dart';

import 'services/interfaces/authentication_service.dart';

var initError = false;

void main() {
  runZonedGuarded(
    () async {
      try {
        WidgetsFlutterBinding.ensureInitialized();
        await EasyLocalization.ensureInitialized();
        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform);

        String? documentsPath;

        if (!kIsWeb) {
          // Add this where you initialize Isar
          // final dir = await getApplicationDocumentsDirectory();
          // final isar = await Isar.open(
          //   [UserSettingSchema],
          //   directory: dir.path,
          //   inspector: true,
          //   maxSizeMiB: 512,
          // );
          // documentsPath = dir.path;
        }

        await SampleAppInit.launchInit(documentsPath);

        final auth = GetIt.instance<AuthenticationService>();
        final appState = GetIt.instance<AppStateManager>();

        final isAlreadyLoggedIn = await auth.isAlreadyLoggedIn();
        if (isAlreadyLoggedIn) {
          // var profileSvc = GetIt.I<ProfileService>();
          // profileSvc.initialize();

          // this will tell router to directly navigate to home page
          await appState.completeLogin();
        } else {
          appState.setIsLoggedIn = false;
        }

        return runApp(EasyLocalization(
            path: 'assets/translations',
            supportedLocales: [
              Language.bahasa.toLocale(),
              // Language.englishUS.toLocale()
            ],
            assetLoader: const CodegenLoader(),
            child: const SampleApp()));
      } catch (e) {
        initError = true;
        rethrow;
      }
    },
    (error, stack) {
      if (kDebugMode) {
        debugPrint(
            "ERROR main.dart (initError: $initError): ${error.toString()}");
      }
    },
  );
}

class SampleApp extends StatefulWidget {
  const SampleApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SampleAppState();
}

class _SampleAppState extends State<SampleApp> {
  final _scaffoldMessengerStateKey = GlobalKey<ScaffoldMessengerState>();
  final _routeParser = AppRouteParser();
  late AppRouter _appRouter;

  final _appStateManager = GetIt.instance<AppStateManager>();

  @override
  void initState() {
    _appRouter = AppRouter();
    super.initState();

    // WidgetsBinding.instance
    //     .addObserver(LifecycleEventHandler(resumeCallBack: onResume));
  }

  // Future onResume() async {
  //   if (_appStateManager.isLoggedIn) {
  //     _appStateManager.syncData(abortPrevious: false);
  //   } else {
  //     await _appUpdateProvider.checkForUpdates();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    ColorScheme appColors =
        ColorScheme.fromSeed(seedColor: AppColors.primaryColor);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => _appStateManager),
        // ChangeNotifierProvider(
        //   create: (ctx) => GetIt.I<UserSettingsProvider>(),
        // ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Consumer<AppStateManager>(
          builder: (BuildContext context, value, Widget? child) {
            return MaterialApp.router(
              locale: context.locale,
              routeInformationParser: _routeParser,
              routerDelegate: _appRouter,
              scaffoldMessengerKey: _scaffoldMessengerStateKey,
              title: "Wish Laundry POS",
              // themeMode: value.mode,
              theme: ThemeData(
                useMaterial3: false,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.primaryColor,
                  primary: AppColors.primaryColor,
                ),
                textTheme: TextTheme(
                    titleLarge:
                        TextStyle(color: appColors.primary)), //<--and this
              ),
              backButtonDispatcher: RootBackButtonDispatcher(),
              supportedLocales: context.supportedLocales,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
            );
          },
        ),
      ),
    );
  }
}
