import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:praying_app/app/helpers/colors.dart';
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

          if (qiblahDirection == null) {
            return const Center(child: CircularProgressIndicator());
          }
          print(qiblahDirection.direction);
          final temp = 360 - qiblahDirection.qiblah;
          isOnQibla = temp.abs() < 10;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: isOnQibla ? AppColors.mainColor.withOpacity(0.1) : Colors.transparent,
                        spreadRadius: 0.1,
                        blurRadius: 100,
                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Transform.rotate(
                      angle: (qiblahDirection.qiblah * (3.14159265359 / 180) * -1),
                      alignment: Alignment.center, // ✅ makes rotation pivot center
                      child: ClipOval(
                        child: Image.asset(
                          getAssetString(context),
                          // height: 200,
                          // width: 200,
                        ),
                      ),
                    ),
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
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : AppColors.mainColor,
                        ),
                      ),
                    ),
                    Text(
                      qiblahDirection.direction.floor().toString(),
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.mainColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String getAssetString(context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      if (isOnQibla) {
        return 'assets/dark_blue_compass.png';
      } else {
        return 'assets/dark_grey_compass.png';
      }
    } else {
      if (isOnQibla) {
        return 'assets/light_blue_compass.png';
      } else {
        return 'assets/light_gray_compass.png';
      }
    }
  }
}
