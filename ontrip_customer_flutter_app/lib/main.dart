import 'dart:async';
import 'dart:convert';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:ontrip_customer_flutter_app/firebase_options.dart';

import 'app_export.dart';

Future<void> main() async {
  await initializeApp();
  runApp(MyApp());
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      Firebase.app();
    } else {
      rethrow;
    }
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Constant.instance.primary, statusBarIconBrightness: Brightness.light));

  await GetStorage.init();
  await notificationService.init();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  terminatedNotification();
}

String? lastHandledMessageId;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }
  } catch (e) {
    // Ignore duplicate init error
  }

  await GetStorage.init();

  if (message.messageId != null && message.messageId != lastHandledMessageId) {
    lastHandledMessageId = message.messageId;
    await notificationService.init();
    notificationService.showRemoteNotificationAndroid(message);
  }
}

void terminatedNotification() async {
  // 1. Handle FCM Initial Message
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null && initialMessage.messageId != lastHandledMessageId) {
    lastHandledMessageId = initialMessage.messageId;
    notificationService.showRemoteNotificationAndroid(initialMessage);
  }

  // 2. Handle Local Notification Launch
  final NotificationAppLaunchDetails? notificationAppLaunchDetails = await notificationService.flutterLocalNotificationsPlugin
      .getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails != null &&
      notificationAppLaunchDetails.didNotificationLaunchApp &&
      notificationAppLaunchDetails.notificationResponse?.payload != null) {
    final String? payload = notificationAppLaunchDetails.notificationResponse?.payload;
    if (payload != null && payload.isNotEmpty) {
      try {
        final Map<String, dynamic> data = json.decode(payload);
        final String? packageId = data["community"] ?? data["packageId"];
        if (packageId != null) {
          // Add a longer delay to ensure Splash screen has finished navigating
          // (SplashCtrl usually takes 3 seconds)
          Future.delayed(const Duration(milliseconds: 4000), () {
            debugPrint("Terminated Launch: Navigating to Chat for $packageId");
            Get.toNamed(RouteNames.communityChat, arguments: {"packageId": packageId, "coverImage": data["coverImage"]});
          });
        }
      } catch (e) {
        debugPrint("Error handling terminated launch notification: $e");
      }
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool wasOffline = false;

  void handleConnectivityChange(bool isOffline) {
    if (wasOffline && !isOffline) {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().initialize();
      }
    }
    wasOffline = isOffline;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "On Trip",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: RouteNames.splash,
      initialBinding: PreBinder(),
      getPages: RouteMethods.pages,
      builder: (context, child) {
        return OfflineBuilder(
          connectivityBuilder: (BuildContext context, List<ConnectivityResult> connectivity, Widget _) {
            final bool isOffline = connectivity.contains(ConnectivityResult.none);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              handleConnectivityChange(isOffline);
            });

            if (isOffline) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Card(
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('No Internet Connection', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('Please check your internet connection and try again', textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return child ?? const SizedBox();
          },
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
