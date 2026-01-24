import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:uuid/uuid.dart';

import '../../firebase_options.dart';

abstract class FirebaseBaseService {
  // Firebase app
  FirebaseApp? _firebaseApp;

  Future<FirebaseApp> getApp() async {
    if (_firebaseApp == null) {
      await initialize();
      return _firebaseApp!;
    }
    return _firebaseApp!;
  }

  // FCM Token
  String? token;

  // Firebase Messaging Instance
  late FirebaseMessaging _firebaseMessaging;

  // Notification instance for showing notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Constructor to initialize Firebase
  Future<void> initialize({bool getFCMToken = true}) async {
    try {
      // if(GetPlatform.isAndroid){
      // flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
      // }
      debugPrint(">>>>>>>>>>>>>>>> coming for firebase initialize <<<<<<<<<<<<<");
      _firebaseApp = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      if (GetPlatform.isMobile || GetPlatform.isWeb) {
        _firebaseMessaging = FirebaseMessaging.instance;
        // Request for iOS notification permissions
        await _firebaseMessaging.requestPermission();

        // Configure Firebase Messaging
        _configureFirebaseMessaging();

        // Initialize Local Notifications (for background and terminated state)
        _initializeLocalNotifications();

        // Get the FCM token (to send push notifications)
        if (getFCMToken) {
          token = await _firebaseMessaging.getToken();
          debugPrint("================= > FCM Token: $token <=========================");
        }
      }
    } catch (e) {
      debugPrint("================= > Firebase Error: $e <=========================");
    }
    // Optionally, save this token to your server if you want to target specific devices
  }

  // Configure foreground and background message handlers
  void _configureFirebaseMessaging() {
    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("================= > Received message in foreground: ${message.notification?.title} <=========================");
      _showNotification(message);
    });

    // Handle when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("================= > Opened app from notification: ${message.notification?.title} <=========================");
      _handleNotification(message);
    });

    // Handle background notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Initialize Local Notifications for background and terminated states
  @pragma('vm:entry-point')
  void _initializeLocalNotifications() {
    // const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    // final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings);

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    Future<void> initializeNotifications() async {
      // Android
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS
      const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // macOS
      const DarwinInitializationSettings initializationSettingsMacOS = DarwinInitializationSettings();

      // Linux
      final LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(
        defaultActionName: 'Open notification',
        defaultIcon: AssetsLinuxIcon('icons/app_icon.png'), // Use a valid icon
      );

      // Windows
      WindowsInitializationSettings initializationSettingsWindows = WindowsInitializationSettings(
        appName: 'SalesZing',
        appUserModelId: 'com.circuitworldin', // Required if you want toast notifications
        guid: Uuid().v4(), // A valid UUID for your app instance
      );

      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS,
        linux: initializationSettingsLinux,
        windows: initializationSettingsWindows,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // Handle notification tap here
        },
      );
    }
  }

  // Show notification locally (for foreground messages)
  @pragma('vm:entry-point')
  Future<void> _showNotification(RemoteMessage message) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'firebaseNotification',
        'firebaseNotificationSalesZingApp',
        channelDescription: 'Firebase notification for CW SalesZing App',
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.social,
        icon: '@mipmap/ic_launcher',
        enableLights: true,
      );
      const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        0, // notification id
        message.notification?.title,
        message.notification?.body,
        platformDetails,
        payload: message.data.toString(),
      );
    } catch (e) {
      print("DEBUG ERROR: $e");
    }
  }

  // Handle background messages
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint("================= > Handling background message: ${message.messageId}} <=========================");
    // You can perform background tasks here, such as updating your app data
  }

  // Handle notification when the app is opened (from background/terminated state)
  void _handleNotification(RemoteMessage message) {
    // You can handle navigation or other actions here based on the message data
    debugPrint("================= > Notification data: ${message.data} <=========================");
  }

  // Subscribe to a topic for push notifications
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print("Subscribed to topic: $topic");
  }

  // Unsubscribe from a topic for push notifications
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print("Unsubscribed from topic: $topic");
  }
}

enum AuthType { google, facebook, twitter }

class FirebaseLogInService extends FirebaseBaseService {
  FirebaseAuth? _auth;

  FirebaseLogInService() {
    authInit();
  }

  Future<void> authInit() async {
    _auth ??= FirebaseAuth.instanceFor(app: await getApp());
  }

  Future<FirebaseAuth> getAuth() async {
    if (_auth == null) {
      await authInit();
      return _auth!;
    }
    return _auth!;
  }

  Future<void> makeProviderLogin(AuthType type) async {
    FirebaseApp firebaseApp = await getApp();
    final auth = await getAuth();
    AuthProvider provider = GoogleAuthProvider();
    if (type == AuthType.google) {
      provider = GoogleAuthProvider();
    }
    if (type == AuthType.facebook) {
      provider = FacebookAuthProvider();
    }
    if (type == AuthType.twitter) {
      provider = TwitterAuthProvider();
    }
    UserCredential cred = await auth.signInWithProvider(provider);
    logG(cred.user?.uid);
  }

  Future<void> makeEmailLogin({required String email, required String password}) async {
    if (!GetUtils.isEmail(email)) {
      return showAlert('Give a valid mail', AlertType.error);
    }
    if (password.length < 6) {
      return showAlert("Password length should be more then 5", AlertType.error);
    }
    final auth = await getAuth();
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("issuee----- ${e.code} ${e.message}");
      switch (e.code) {
        case 'user-not-found':
          showAlert("User not found", AlertType.error);
          break;
        case 'wrong-password':
          showAlert("Wrong password", AlertType.error);
          break;
        case 'invalid-email':
          showAlert("Invalid email", AlertType.error);
          break;
        default:
          showAlert(e.message ?? "Login failed", AlertType.error);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> createNewUser({required String name, required String email, required String password}) async {
    if (name.trim().length < 3) {
      return showAlert("Give a valid name!", AlertType.error);
    }
    final auth = await getAuth();
    try {
      UserCredential cred = await auth.createUserWithEmailAndPassword(email: email, password: password);
      await cred.user?.updateDisplayName(name);
      await cred.user?.reload();
      logG(cred.user?.uid);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

class FirebaseG extends FirebaseLogInService {
  FirebaseG() {
    if (getApp() == null) {
      initialize();
    }
  }
}
