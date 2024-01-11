import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

final _localNotifications = FlutterLocalNotificationsPlugin();




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeBackgroundService();


  runApp(const MyApp());
}

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,
        // auto start service
        autoStart: true,
        isForegroundMode: true,
      ),

    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}


@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async{


 /*  final wsUrl = Uri.parse('ws://0.tcp.ap.ngrok.io:15496');
  var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((data) async{
      Map<String, dynamic> message = json.decode(data);
      if (kDebugMode) {
        print('Received data from Node.js: ${message['message']}');
      }
        await showNotification(message['message']);

      channel.sink.add('received!');

      // channel.sink.close(status.goingAway);
    },
    // onDone: () {
    //   if (kDebugMode) {
    //     print('WebSocket channel closed');
    //   }
    // },
    onError: (error) {
      if (kDebugMode) {
        print('Error in WebSocket channel: $error');
      }
    },
  ); */

  return ;
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}


Future<void> showNotification(String message) async {

  await _localNotifications.initialize(
    InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'), // Replace with your app icon
    ),
  );

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'your_channel_id',
    'Your Channel Name',
    importance: Importance.max,
    ticker: 'ticker',
    playSound: true,
    priority: Priority.max,
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await _localNotifications.show(
    0, // Notification ID
    'Notification Title',
    message,
    platformChannelSpecifics,
  );
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            ElevatedButton(
                onPressed: () async {
                  await showNotification("Hello");
                }, child: Text("Show Notification")
              )
          ],
        ),
      ),
     
    );
  }
}
// 0518463091