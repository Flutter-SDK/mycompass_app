import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblahScreen extends StatefulWidget {
  const QiblahScreen({super.key});

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

Animation<double>? needleAnimation;
AnimationController? _animationController;
double needleBegin = 0.0;

class _QiblahScreenState extends State<QiblahScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    needleAnimation =
        Tween(begin: 0.0, end: 0.0).animate(_animationController!);
    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qiblah'),
      ),
      body: StreamBuilder(
        stream: FlutterQiblah.qiblahStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }

          final qiblahDirection = snapshot.data;
          // Rotate the needle to show the Qiblah direction
          needleAnimation = Tween(
            begin: needleBegin,
            end: (qiblahDirection!.qiblah * (pi / 180) * -1),
          ).animate(_animationController!);
          needleBegin = (qiblahDirection.qiblah * (pi / 180) * -1);
          _animationController!.forward(from: 0);

          return Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: StreamBuilder<CompassEvent>(
                stream: FlutterCompass.events,
                builder: (context, compassSnapshot) {
                  if (compassSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final heading = compassSnapshot.data!.heading ?? 0.0;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rotating compass based on the heading
                      Transform.rotate(
                        angle: (heading * (pi / 180) * -1),
                        child: Image.asset('assets/images/compass.png'),
                      ),
                      // Rotating needle to show Qiblah direction
                      AnimatedBuilder(
                        animation: needleAnimation!,
                        builder: (context, child) => Transform.rotate(
                          angle: needleAnimation!.value,
                          child: Image.asset('assets/images/needle.png'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
