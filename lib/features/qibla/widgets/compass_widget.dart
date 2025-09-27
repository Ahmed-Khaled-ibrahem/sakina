import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../navigation_layout/provider/navigation_provider.dart';

class QiblahCompass extends ConsumerWidget {
  QiblahCompass({super.key});

  bool isOnQibla = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navigationIndexProvider);
    return Visibility(
      visible: index == 1,
      child: StreamBuilder<QiblahDirection>(
        stream: FlutterQiblah.qiblahStream,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          final qiblahDirection = snapshot.data;

          if(qiblahDirection == null){ return const Center(child: CircularProgressIndicator()); }
          print(qiblahDirection.direction);
          final temp = 360 - qiblahDirection.qiblah;
          isOnQibla = temp.abs() < 10;

          return Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle:
                        (qiblahDirection.qiblah * (3.14159265359 / 180) * -1),
                    child: Image.asset(
                      isOnQibla? 'assets/compass.png' : 'assets/compass2.png',
                      height: 300,
                      width: 300,
                    ),
                  ),
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      Positioned(
                        top: -10,
                        right: 0,
                        child: Text(
                          'o',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Text(
                        qiblahDirection.direction.floor().toString(),
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
