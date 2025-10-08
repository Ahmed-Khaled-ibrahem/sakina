import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../app/providers/all_app_provider.dart';
import '../../app/routes/routes.dart';
import '../../app/theme/theme_provider.dart';

class AzkarScreen extends ConsumerStatefulWidget {
  const AzkarScreen({super.key});
  @override
  AzkarScreenState createState() => AzkarScreenState();
}

class AzkarScreenState extends ConsumerState<AzkarScreen> {
  @override
  Widget build(BuildContext context) {
    final refreshValue = ref.watch(refreshProvider);


    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 0.05.sh),
            Row(
              children: [
                SizedBox(width: 0.1.sw),
                Text("azkar".tr(), style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  SizedBox(
                    height: 0.5.sw,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            context.push(AppRoutes.azkharEvening);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            margin: EdgeInsets.all(10),
                            color: Color(0xffEAEEFB),
                            child: SizedBox.square(
                              dimension: 0.4.sw,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            'evening'.tr(),
                                            style: TextStyle(
                                              color: Color(0xff3551F2),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .end,
                                        children: [
                                          Image.asset(
                                              'assets/icons/azkar/1.png'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.push(AppRoutes.azkharMorning);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            margin: EdgeInsets.all(10),
                            color: Color(0xff3551F2),
                            child: SizedBox.square(
                              dimension: 0.4.sw,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .end,
                                          children: [
                                            Image.asset(
                                                'assets/icons/azkar/2.png'),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              'morning'.tr(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.4.sw,
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        context.push(AppRoutes.azkharPraying);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.all(10),
                        color: Color(0xffFFEBC2),
                        child: Column(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'after_salah'.tr(),
                                      style: TextStyle(
                                        color: Color(0xffF9BF29),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -15,
                                    left: -8,
                                    child: Image.asset(
                                      'assets/icons/azkar/3.png',
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

