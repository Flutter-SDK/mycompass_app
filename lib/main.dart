import 'package:flutter/material.dart';
import 'package:mycompass_app/features/qiblah_compass/presentation/pages/qiblah_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasPermission = false;

  Future getPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        hasPermission = true;
      } else {
        Permission.location.request().then(
          (value) {
            setState(() {
              hasPermission = (value == PermissionStatus.granted);
            });
          },
        );
      }
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: getPermission(),
        builder: (context, snapshot) {
          if (hasPermission) {
            return const QiblahScreen();
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('data'),
              ),
              body: const Center(
                child: Text('qibla not working'),
              ),
            );
          }
        },
      ),
    );
  }
}
