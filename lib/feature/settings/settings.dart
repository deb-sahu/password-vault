import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_vault/app_container.dart';
import 'package:password_vault/constants/common_exports.dart';
import 'package:password_vault/feature/settings/clear_data_dialog.dart';
import 'package:password_vault/service/cache/cache_service.dart';
import 'package:password_vault/service/singletons/theme_change_manager.dart';

final importChangeProvider = StateProvider<bool>((ref) {
  return false;
});

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var height = AppStyles.viewHeight(context);
    var width = AppStyles.viewWidth(context);
    bool isPortrait = AppStyles.isPortraitMode(context);
    final themeChange = ref.watch(themeChangeProvider);
    ThemeChangeService().initializeThemeChange(ref, themeChange);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: AppStyles.appBarHeight(context),
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style: AppStyles.appHeaderTextStyle(context, isPortrait),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(width * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.02),
            ListTile(
              tileColor: ThemeChangeService().getThemeChangeValue()
                  ? AppColor.grey_800
                  : AppColor.grey_200,
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: ThemeChangeService().getThemeChangeValue(),
                onChanged: (value) async {
                  await CacheService().updateThemeMode(value);
                  ref.read(themeChangeProvider.notifier).state = value;
                },
              ),
            ),
            SizedBox(height: height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ThemeChangeService().getThemeChangeValue()
                      ? AppStyles.onlyTextButtonDark
                      : AppStyles.onlyTextButtonLight,
                  onPressed: () async {
                    var bool = await CacheService().exportAllData();
                    if (context.mounted) {
                      if (bool) {
                        AppStyles.showSuccess(context, 'Data exported successfully');
                      } else {
                        AppStyles.showError(context, 'Error in exporting data');
                      }
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        'Export Data',
                        style: AppStyles.customText(
                          context,
                          color: ThemeChangeService().getThemeChangeValue()
                              ? AppColor.whiteColor
                              : AppColor.blackColor,
                          sizeFactor: 0.04,
                        ),
                      ),
                      SizedBox(width: width * 0.6),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ThemeChangeService().getThemeChangeValue()
                      ? AppStyles.onlyTextButtonDark
                      : AppStyles.onlyTextButtonLight,
                  onPressed: () async {
                     // Import data from file
                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      String filePath = result.files.single.path!;
                      var bool = await CacheService().importDataFromFile(filePath);
                      if (context.mounted) {
                        if (bool) {
                          ref.read(importChangeProvider.notifier).update((state) => true);
                          AppStyles.showSuccess(context, 'Data imported successfully');
                        } else {
                          AppStyles.showError(context, 'Error in importing data');
                        }
                      }
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        'Import Data',
                        style: AppStyles.customText(
                          context,
                          color: ThemeChangeService().getThemeChangeValue()
                              ? AppColor.whiteColor
                              : AppColor.blackColor,
                          sizeFactor: 0.04,
                        ),
                      ),
                      SizedBox(width: width * 0.6),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.5),
            SizedBox(
              width: double.infinity,
              height: height * 0.06,
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.appColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ClearDataDialog(),
                  );
                },
                child: Text(
                  'Clear All Data',
                  style: AppStyles.customText(
                    context,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
