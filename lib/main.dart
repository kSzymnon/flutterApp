import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_zakupowa/pages/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_info_plus/device_info_plus.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<String> deviceIdFuture = getDeviceId();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: deviceIdFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final String deviceId = snapshot.data!;
          return MaterialApp(
            title: 'My App',
            home: MyHomePage(deviceId: deviceId),
               debugShowCheckedModeBanner: false
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  static Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = '';
    try {
      if (Platform.isAndroid) {
        var androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.androidId!;
      } else if (Platform.isIOS) {
        var iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor!;
      }
    } catch (e) {
      print('Error getting device ID: $e');
    }
    return deviceId;
  }
}

class MyHomePage extends StatelessWidget {
  final String deviceId;

  const MyHomePage({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(deviceId: deviceId,),
      debugShowCheckedModeBanner: false,
    );
  }
}
