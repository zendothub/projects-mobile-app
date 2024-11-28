import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Ensure this import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'package:zen_mobile/config/plane_keys.dart';
import 'package:zen_mobile/provider/provider_list.dart';
import 'package:zen_mobile/services/shared_preference_service.dart';
import 'package:zen_mobile/startup/dependency_resolver.dart';
import 'package:zen_mobile/utils/constants.dart';
import 'package:zen_mobile/utils/global_functions.dart';
import 'app.dart';
import 'config/config_variables.dart';
import 'config/const.dart';
import 'screens/on_boarding/on_boarding_screen.dart';
import 'utils/enums.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'utils/app_theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

late String selectedTheme;

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file here
  await dotenv.load(fileName: '.env'); 
  
  // Access your BASE_API from .env
  String baseApiUrl = dotenv.env['BASE_API'] ?? 'https://projects.zendot.in/';  // Default if not found
  
  // Debug log to ensure .env is loaded correctly
  log('Base API URL: $baseApiUrl');

  await Future.delayed(const Duration(milliseconds: 300));
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Set UI style and load other services
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await SharedPrefrenceServices.init();
  SharedPrefrenceServices.getTokens();
  SharedPrefrenceServices.getUserID();
  sentryService();

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  runApp(
    ProviderScope(
      child: MyApp(baseApiUrl),  // Pass baseApiUrl to MyApp
    ),
  );
}  // Pass the baseApiUrl to your app


class MyApp extends ConsumerStatefulWidget {
  final String baseApiUrl;  // Make baseApiUrl available to the app

  const MyApp(this.baseApiUrl, {super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    DependencyResolver.resolve(ref: ref);
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    final themeProvider = ref.read(ProviderList.themeProvider);
    final profileProvider = ref.read(ProviderList.profileProvider);

    if (profileProvider.userProfile.theme != null &&
        profileProvider.userProfile.theme!['theme'] == PlaneKeys.SYSTEM_THEME) {
      final theme = profileProvider.userProfile.theme;

      theme!['theme'] = fromTHEME(theme: THEME.systemPreferences);
      log(theme.toString());
      themeProvider.changeTheme(data: {'theme': theme}, context: null);
    }
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    AppTheme.setUiOverlayStyle(
        theme: themeProvider.theme, themeManager: themeProvider.themeManager);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: PlaneKeys.APP_NAME,
        theme: AppTheme.getThemeData(themeProvider.themeManager),
        themeMode: AppTheme.getThemeMode(themeProvider.theme),
        navigatorKey: Const.globalKey,
        navigatorObservers: checkPostHog() ? [PosthogObserver()] : [],
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: Overlay(
            initialEntries: [
              OverlayEntry(builder: (context) {
                return UpgradeAlert(
                  child: Const.accessToken == null
                      ? const OnBoardingScreen()
                      : const App(),
                );
              })
            ],
          ),
        ));
  }

  bool checkPostHog() {
    bool enablePostHog = false;
    if (Config.posthogApiKey != null && Config.posthogApiKey != '') {
      enablePostHog = true;
    } else {
      enablePostHog = false;
    }
    return enablePostHog;
  }
}
