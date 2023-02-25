import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:overlay_support/overlay_support.dart';
import 'package:quote_tiger/components/dialogs/quote_tiger_dialog.dart';
import 'package:quote_tiger/controllers/singletons/navigation.dart';
import 'package:quote_tiger/provider/globals_provider.dart';
import 'package:quote_tiger/provider/notifications_provider.dart';
import 'package:quote_tiger/route_generator.dart';
import 'package:quote_tiger/services/firebase/dynamic_link_service.dart';
import 'package:quote_tiger/services/notifications/notifications.dart';
import 'package:quote_tiger/utils/globals.dart';
import 'package:quote_tiger/views/authentication/auth_wrapper.dart';
import 'package:quote_tiger/views/authentication/profile_creation/profile_creation_wrapper.dart';
import 'package:quote_tiger/views/navigation_wrapper.dart';
import 'package:quote_tiger/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:quote_tiger/views/popups/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("sent_ftm", false);

  await Firebase.initializeApp();
  initializeFirebaseMessaging();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider.initialize()),
      ChangeNotifierProxyProvider<AuthProvider, UserModel?>(
          create: (_) => null,
          update: (_, authProvider, userModel) => authProvider.model),
      ChangeNotifierProxyProvider<UserModel?, NotificationsProvider?>(
          create: (_) => NotificationsProvider(),
          update: (_, userModel, notificationsProvider) =>
              notificationsProvider?.initializeListener(userModel?.id)),
      ChangeNotifierProvider(
        create: (_) => GlobalsProvider.init(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    DynamicLinksService().initDynamicLinks();

    initializeLocalNotifications();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quote Tiger',
        initialRoute: '/',
        navigatorKey: NavigationSingleton().navigatorKey,
        onGenerateRoute: RouteGenerator.generateRoute,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.orange,
            ),
            textTheme: GoogleFonts.manropeTextTheme(),
            primarySwatch: Colors.orange,
            primaryColor: const Color(0XFFFCA205)),
      ),
    );
  }
}

class AppPagesController extends StatefulWidget {
  const AppPagesController({Key? key}) : super(key: key);

  @override
  State<AppPagesController> createState() => _AppPagesControllerState();
}

class _AppPagesControllerState extends State<AppPagesController> {
  var userModelPlaceholder = UserModelPlaceholder().instance;
  bool initializedNotificationSingleTon = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    GlobalsProvider globalsProvider = Provider.of<GlobalsProvider>(context);

    //TODO: think of a better way for this.

    //TODO: keep this one in mind. I removed the null option;
    if (globalsProvider.timesAppOpened == 0) {
      return const OnBoarding();
    }

    switch (authProvider.status) {
      case AuthStatus.uninitialized:
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      case AuthStatus.unauthenticated:
        return const AuthWrapper();
      case AuthStatus.authenticating:
        return const AuthWrapper();
      case AuthStatus.authenticated:
        if (authProvider.user != null &&
            authProvider.model != null &&
            authProvider.model!.id != userModelPlaceholder.id) {
          return WillPopScope(
            onWillPop: () async {
              return await showDialog<bool>(
                      context: context,
                      builder: (_) {
                        return QuoteTigerDialog(
                          acceptMessage: 'Yes. Exit',
                          declineMessage: 'No. Cancel',
                          title: 'Are you sure?',
                          message: 'Are you sure you want to exit QuoteTiger?',
                          onAccept: () {
                            Navigator.of(context).pop(true);
                          },
                          onDecline: () {
                            Navigator.of(context).pop(false);
                          },
                        );
                      }) ??
                  false;
            },
            child: NavigationWrapper(
              timesAppOpened: globalsProvider.timesAppOpened,
              localUserModel: authProvider.model!,
            ),
          );
        } else {
          return const ProfileCreationWrapper();
        }
      default:
        return const AuthWrapper();
    }
  }
}
