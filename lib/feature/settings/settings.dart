import 'package:flutter/cupertino.dart';
import 'package:password_vault/constants/common_exports.dart';
import 'package:password_vault/service/cache/cache_service.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    var height = AppStyles.viewHeight(context);
    var width = AppStyles.viewWidth(context);
    bool isPortrait = AppStyles.isPortraitMode(context);

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
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: isDarkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    isDarkModeEnabled = value;
                  });
                  // TODO: Implement dark mode toggle logic
                },
              ),
            ),
            SizedBox(height: height * 0.62),
            SizedBox(
              width: double.infinity,
              height: height * 0.06,
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.appColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppColor.grey_200,
                      surfaceTintColor: AppColor.grey_100,
                      title: Text('Clear All Data',
                          style: AppStyles.primaryBoldText(context, isPortrait)),
                      content: Text(
                        'Are you sure you want to clear all data? This action cannot be undone.',
                        style: AppStyles.customText(context),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: AppStyles.customText(
                              context,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            bool success = await CacheService().clearAllData();
                            if (success) {
                              // Data cleared successfully
                              if (context.mounted) {
                                AppStyles.showSuccess(context, 'Data cleared successfully');
                              }
                            } else {
                              // Failed to clear data
                              if (context.mounted) {
                                AppStyles.showError(context, 'Failed to clear data');
                              }
                            }
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            'Clear All',
                            style: AppStyles.customText(
                              context,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
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
