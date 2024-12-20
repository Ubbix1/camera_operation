import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'command_handler.dart';
import 'api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp(this.cameras, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Control APK',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ControlPage(cameras: cameras),
    );
  }
}

class ControlPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const ControlPage({super.key, required this.cameras});

  @override
  ControlPageState createState() => ControlPageState();
}

class ControlPageState extends State<ControlPage> {
  final ApiService apiService = ApiService();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startPollingCommands();
  }

  void _startPollingCommands() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      CommandHandler(apiService).processCommand(context, widget.cameras);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Control APK'),
      ),
      body: const Center(
        child: Text(
          'Waiting for commands...',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
