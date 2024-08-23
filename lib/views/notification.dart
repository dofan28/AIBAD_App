import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/routes/routes.dart';
import 'package:final_project/services/fb_firestore_service.dart';
import 'package:final_project/services/user_preferences_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final NotificationService _notificationService = NotificationService();
  String? userId;
  Timestamp? scheduleTime;

  @override
  void initState() {
    super.initState();
    _initializeNotificationPlugin();
    _initializeUserId().then((userId) {
      if (userId != null) {
        FirebaseMessaging.instance.getToken().then((token) {
          if (token != null) {
            print("FCM Token: $token");
            print("User ID: $userId");
            _notificationService.sendTokenToServer(userId, token);
          }
        });
        _loadScheduleTime();
      }
    });
    _requestNotificationPermission();
    _setupFirebaseMessagingListener();
  }

  Future<void> _loadScheduleTime() async {
    DocumentSnapshot user =
        await FBFirestoreService.fbFirestoreService.getTime();
    setState(() {
      return scheduleTime = user['time'];
    });
  }

  Future<void> _initializeNotificationPlugin() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/logo');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          print('Notification payload: ${response.payload}');
        }
      },
    );
  }

  Future<void> _requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<String?> _initializeUserId() async {
    userId = await UserPreferences.getUserId();
    return userId;
  }

  void _setupFirebaseMessagingListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _showNotification(message.notification!.title ?? 'No Title',
            message.notification!.body ?? 'No Body');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _showNotification(message.notification!.title ?? 'No Title',
            message.notification!.body ?? 'No Body');
      }
    });
  }

  Future<void> _showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'reminders_channel',
      'Reminders',
      channelDescription: 'Notifications for reminders',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _scheduleNotification(TimeOfDay timeOfDay) async {
    final now = DateTime.now();
    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    if (userId != null) {
      // Menggunakan userId sebagai ID dokumen
      DocumentReference scheduleRef =
          FirebaseFirestore.instance.collection('schedules').doc(userId);

      await scheduleRef.set({
        'userId': userId,
        'message': 'This is a scheduled notification.',
        'time': Timestamp.fromDate(scheduledDate),
      });

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'reminders_channel',
        'Reminders',
        channelDescription: 'Notifications for reminders',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );
      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Scheduled Notification',
        'This is the notification body',
        tz.TZDateTime.from(scheduledDate, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } else {
      print("User ID is null, cannot schedule notification");
    }
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      useRootNavigator: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(Routes.home),
        backgroundColor: Colors.red,
        label: const Text(
          key: Key('btnAddQuote'),
          'Perbarui Notifikasi',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        icon: const Icon(Icons.notification_add_outlined, color: Colors.white),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
          size: MediaQuery.of(context).size.width * 0.05,
        ),
        backgroundColor: Colors.black,
        title: Text(
          'Atur Notifikasi',
          style: GoogleFonts.plusJakartaSans(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.06,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsetsDirectional.symmetric(
                      vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                          color: Colors.red, style: BorderStyle.solid)),
                  child: Text(
                    scheduleTime != null
                        ? 'Waktu Notifikasi: ${DateFormat.Hm().format(scheduleTime!.toDate())}'
                        : 'Waktu Notifikasi: Waktu tidak ditemukan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final time = await _selectTime(context);
                  if (time != null) {
                    _scheduleNotification(time);
                  }
                },
                child: Text(
                  'Pilih Waktu',
                  style: GoogleFonts.plusJakartaSans(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationService {
  final String serverUrl =
      'https://us-central1-fp-aibad-1d838.cloudfunctions.net/saveToken';

  Future<void> sendTokenToServer(String userId, String token) async {
    try {
      print("Sending token to server...");
      print("userId: $userId");
      print("token: $token");

      final response = await http.post(
        Uri.parse(serverUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userId': userId,
          'token': token,
        }),
      );

      if (response.statusCode == 200) {
        print('Token berhasil dikirim ke server');
      } else {
        print('Gagal mengirim token ke server: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }
}
