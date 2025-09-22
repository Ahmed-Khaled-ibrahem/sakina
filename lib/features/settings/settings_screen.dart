import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:praying_app/features/settings/provider/device_id_provider.dart';
import '../../app/theme/theme_provider.dart';
import '../auth/auth_provider/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authProvider);
    ref.watch(textValueProvider);
    final notifier = ref.read(textValueProvider.notifier);
    controller.text = ref.read(textValueProvider) ?? '';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text('settings.title'.tr())),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              'settings.language'.tr(),
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
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
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
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
            SizedBox(height: 35.h),

            TextField(
              controller: controller,
              onChanged: (value) {
                notifier.setValue(value);
              },
              decoration: InputDecoration(
                labelText: 'Device ID'.tr(),
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 24.h),
            FilledButton(
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: authState.isLoading ? CircularProgressIndicator() : Text(
                  'Logout'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

