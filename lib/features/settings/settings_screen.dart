import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(title: Text('settings.title'.tr())),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'settings.language'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          SegmentedButton<Locale>(
            segments: <ButtonSegment<Locale>>[
              ButtonSegment<Locale>(
                value: const Locale('en'),
                label: Text('language.en'.tr()),
              ),
              ButtonSegment<Locale>(
                value: const Locale('ar'),
                label: Text('language.ar'.tr()),
              ),
            ],
            selected: <Locale>{context.locale},
            onSelectionChanged: (selection) async {
              final Locale newLocale = selection.first;
              await context.setLocale(newLocale);
            },
          ),
          SizedBox(height: 24.h),
          Text(
            'settings.theme'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          SegmentedButton<ThemeMode>(
            segments: const <ButtonSegment<ThemeMode>>[
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text('System'),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text('Light'),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text('Dark'),
              ),
            ],
            selected: <ThemeMode>{themeMode},
            onSelectionChanged: (selection) {
              ref
                  .read(themeModeProvider.notifier)
                  .setThemeMode(selection.first);
            },
          ),
        ],
      ),
    );
  }
}
