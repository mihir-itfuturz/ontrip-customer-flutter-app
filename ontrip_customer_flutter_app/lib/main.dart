import 'dart:async';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:ontrip_customer_flutter_app/src/screens/dashboard/pages/home/home_controller.dart';

import 'app_export.dart';

Future<void> main() async {
  await initializeApp();
  runApp(MyApp());
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Constant.instance.primary, statusBarIconBrightness: Brightness.light));
  await GetStorage.init();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  // terminatedNotification();
}

String? lastHandledMessageId;

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   if (message.messageId != null && message.messageId != lastHandledMessageId) {
//     lastHandledMessageId = message.messageId;
//     await notificationService.init();
//     notificationService.showRemoteNotificationAndroid(message);
//   }
// }

// void terminatedNotification() async {
//   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//   if (initialMessage != null && initialMessage.messageId != lastHandledMessageId) {
//     lastHandledMessageId = initialMessage.messageId;
//     notificationService.showRemoteNotificationAndroid(initialMessage);
//   }
// }

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
