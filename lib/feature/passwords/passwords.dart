import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_vault/app_container.dart';
import 'package:password_vault/feature/passwords/add_password_dialog.dart';
import 'package:password_vault/cache/hive_models/passwords_model.dart';
import 'package:password_vault/feature/passwords/delete_confirmation_dialog.dart';
import 'package:password_vault/feature/settings/clear_data_dialog.dart';
import 'package:password_vault/feature/settings/settings.dart';
import 'package:password_vault/feature/widget_utils/custom_empty_state_illustartion.dart';
import 'package:password_vault/service/cache/cache_service.dart';
import 'package:password_vault/service/singletons/theme_change_manager.dart';
import 'package:password_vault/theme/app_style.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/common_exports.dart';

final deletePasswordNotifierProvider = StateProvider<bool>((ref) {
  return false;
});

class Passwords extends ConsumerStatefulWidget {
  const Passwords({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordsState createState() => _PasswordsState();
}

class _PasswordsState extends ConsumerState<Passwords> {
  late TextEditingController _passwordController;
  late TextEditingController _titleController;
  late TextEditingController _linkController;
  late TextEditingController _descriptionController;
  late bool _isObscured = true;
  late List<PasswordModel> _passwords = [];

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _titleController = TextEditingController();
    _linkController = TextEditingController();
    _descriptionController = TextEditingController();
    _loadPasswords();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _titleController.dispose();
    _linkController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadPasswords() async {
    try {
      _passwords = await CacheService().getPasswordsData();
      ref.read(clearAllDataNotifierProvider.notifier).update((state) => false);
      ref.read(importChangeProvider.notifier).update((state) => false);
    } catch (e) {
      _passwords = [];
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _deletePassword(String passwordId) {
    CacheService().deletePasswordRecord(passwordId).then((success) {
      if (success) {
        setState(() {
          _passwords.removeWhere((password) => password.passwordId == passwordId);
          ref.read(deletePasswordNotifierProvider.notifier).update((state) => true);
        });
        AppStyles.showSuccess(context, 'Password deleted successfully');
      } else {
        AppStyles.showError(context, 'Error deleting password');
      }
    });
  }

  void _showDeleteConfirmation(String passwordId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          passwordId: passwordId,
          onDelete: () => _deletePassword(passwordId),
        );
      },
    );
  }

  void _editPassword(PasswordModel password) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddPasswordDialog(
          passwordModel: password,
          onSuccess: _reloadPasswords,
        );
      },
    );
  }

  void _reloadPasswords() {
    _loadPasswords();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  bool _copyToClipboard(String password) {
    try {
      Clipboard.setData(ClipboardData(text: password));
      return true;
    } catch (e) {
      return false;
    }
  }

  void _openWebPage(String url) async {
    String formattedUrl = url.startsWith('http') ? url : 'https://$url';
    var uri = Uri.parse(formattedUrl); // Convert string to Uri
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(enableJavaScript: true));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = AppStyles.viewHeight(context);
    var width = AppStyles.viewWidth(context);
    bool isPortrait = AppStyles.isPortraitMode(context);
    if (ref.watch(clearAllDataNotifierProvider) || ref.watch(importChangeProvider)) {
      _loadPasswords();
    }
    var themeChange = ref.watch(themeChangeProvider);
    ThemeChangeService().initializeThemeChange(ref, themeChange);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: AppStyles.appBarHeight(context),
        automaticallyImplyLeading: false,
        title: Text(
          'Passwords',
          style: AppStyles.appHeaderTextStyle(context, isPortrait),
        ),
      ),
      floatingActionButton: SizedBox(
        height: AppStyles.fabSize(context),
        width: AppStyles.fabSize(context),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isDismissible: false,
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return AddPasswordDialog(
                  onSuccess: _reloadPasswords,
                );
              },
            );
          },
          backgroundColor: AppColor.appColor,
          splashColor: AppColor.themeBlueLight,
          isExtended: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Icon(
            CupertinoIcons.add,
            size: AppStyles.iconSize(context),
          ),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(width * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.015),
            Expanded(
              child: _passwords.isEmpty
                  ? const EmptyStateIllustration(
                      svgAsset: 'assets/images/svg/illustration3.svg',
                      text: 'Uh oh! No passwords saved yet',
                    )
                  : ListView.builder(
                      itemCount: _passwords.length,
                      itemBuilder: (context, index) {
                        var password = _passwords[index];
                        return Card(
                          child: ExpansionTile(
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            leading: Icon(
                              CupertinoIcons.shield_lefthalf_fill,
                              size: width * 0.05,
                            ),
                            title: Text(
                              password.passwordTitle,
                              style: AppStyles.customText(
                                context,
                                sizeFactor: 0.04,
                                color: ThemeChangeService().getThemeChangeValue()
                                    ? AppColor.whiteColor
                                    : AppColor.grey_800,
                                weight: FontWeight.w600,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(width * 0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (password.siteLink != null &&
                                        password.siteLink!.isNotEmpty) ...{
                                      GestureDetector(
                                        onTap: () => _openWebPage(password.siteLink ?? ''),
                                        child: Text(
                                          password.siteLink ?? '',
                                          style: AppStyles.customText(
                                            context,
                                            sizeFactor: 0.038,
                                            weight: FontWeight.w600,
                                            color: ThemeChangeService().getThemeChangeValue()
                                                ? AppColor.primaryColor
                                                : AppColor
                                                    .themeBlueMid, // Color to indicate it's a link
                                          ),
                                        ),
                                      ),
                                    } else ...{
                                      const SizedBox(),
                                    },
                                    SizedBox(height: height * 0.02),
                                    TextField(
                                      style: AppStyles.customText(context,
                                          sizeFactor: 0.03,
                                          color: ThemeChangeService().getThemeChangeValue()
                                              ? AppColor.whiteColor
                                              : AppColor.blackColor),
                                      controller:
                                          TextEditingController(text: password.savedPassword),
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        border: const OutlineInputBorder(),
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                bool res = _copyToClipboard(password.savedPassword);
                                                if (res) {
                                                  AppStyles.showSuccess(
                                                      context, 'Password copied to clipboard');
                                                } else {
                                                  AppStyles.showError(context,
                                                      'Error copying password to clipboard');
                                                }
                                              },
                                              icon: const Icon(Icons.copy),
                                            ),
                                            IconButton(
                                              onPressed: _togglePasswordVisibility,
                                              icon: _isObscured
                                                  ? const Icon(Icons.visibility)
                                                  : const Icon(Icons.visibility_off),
                                            ),
                                          ],
                                        ),
                                      ),
                                      obscureText: _isObscured,
                                      readOnly: true,
                                    ),
                                    SizedBox(height: height * 0.02),
                                    TextField(
                                      controller:
                                          TextEditingController(text: password.passwordDescription),
                                      style: AppStyles.customText(context,
                                          sizeFactor: 0.03,
                                          color: ThemeChangeService().getThemeChangeValue()
                                              ? AppColor.whiteColor
                                              : AppColor.blackColor),
                                      decoration: InputDecoration(
                                        labelText: 'Description',
                                        labelStyle: AppStyles.customText(context,
                                            sizeFactor: 0.03, color: AppColor.grey_600),
                                        border: const OutlineInputBorder(),
                                      ),
                                      readOnly: true,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            size: width * 0.051,
                                          ),
                                          onPressed: () => _showDeleteConfirmation(password
                                              .passwordId), // Show confirmation before deleting
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            size: width * 0.05,
                                          ),
                                          onPressed: () => _editPassword(password),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
