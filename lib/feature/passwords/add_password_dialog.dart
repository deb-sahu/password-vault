import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_vault/cache/hive_models/passwords_model.dart';
import 'package:password_vault/constants/common_exports.dart';
import 'package:password_vault/service/cache/cache_service.dart';
import 'package:password_vault/service/singletons/theme_change_manager.dart';
import 'package:uuid/uuid.dart';

class AddPasswordDialog extends ConsumerStatefulWidget {
  final PasswordModel? passwordModel;
  final Function onSuccess; // Callback function

  const AddPasswordDialog({super.key, this.passwordModel, required this.onSuccess});

  @override
  // ignore: library_private_types_in_public_api
  _AddPasswordDialogState createState() => _AddPasswordDialogState();
}

class _AddPasswordDialogState extends ConsumerState<AddPasswordDialog> {
  late TextEditingController _titleController;
  late TextEditingController _linkController;
  late TextEditingController _passwordController;
  late TextEditingController _descriptionController;
  late String _passwordId;
  late bool _isObscured = true;
  late bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.passwordModel?.passwordTitle ?? '');
    _linkController = TextEditingController(text: widget.passwordModel?.siteLink ?? '');
    _passwordController = TextEditingController(text: widget.passwordModel?.savedPassword ?? '');
    _descriptionController =
        TextEditingController(text: widget.passwordModel?.passwordDescription ?? '');
    _passwordId = widget.passwordModel?.passwordId ?? '';
    _isEditMode = widget.passwordModel != null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _linkController.dispose();
    _passwordController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _savePassword(BuildContext context) async {
    // Validate fields
    if (_titleController.text.isEmpty ||
        _linkController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      AppStyles.showError(context, 'Please fill all fields.');
      return;
    }
    var passwordId = '';

    // Check if passwordId exists
    var passwordExists = await CacheService().checkPasswordIdExists(_passwordId);
    if (passwordExists) {
      passwordId = _passwordId;
      _isEditMode = true;
    } else {
      passwordId = const Uuid().v4();
    }

    // Create a new PasswordModel instance
    var passwordModel = PasswordModel(
      passwordId: passwordId,
      passwordTitle: _titleController.text,
      siteLink: _linkController.text,
      savedPassword: _passwordController.text,
      passwordDescription: _descriptionController.text,
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    );

    // Save the PasswordModel instance using Hive
    CacheService().addEditPassword(passwordModel).then((success) {
      if (success) {
        _isEditMode
            ? AppStyles.showSuccess(context, 'Password updated successfully.')
            : AppStyles.showSuccess(context, 'Password added successfully.');
        widget.onSuccess(); // Callback function
        Navigator.pop(context);
      } else {
        AppStyles.showError(context, 'Failed to add password. Please try again.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = AppStyles.viewHeight(context);
    var isPortrait = AppStyles.isPortraitMode(context);

    return AlertDialog(
      backgroundColor: ThemeChangeService().getThemeChangeValue() ? AppColor.grey_800 : AppColor.grey_200,
      surfaceTintColor: ThemeChangeService().getThemeChangeValue() ? AppColor.grey_400 : AppColor.grey_100,
      iconColor: AppColor.primaryColor,
      icon: const Icon(Icons.lock),
      title: _isEditMode
          ? Text('Edit Password', style: AppStyles.primaryBoldText(context, isPortrait))
          : Text('Add New Password', style: AppStyles.primaryBoldText(context, isPortrait)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration:
                  InputDecoration(labelText: 'Title', labelStyle: AppStyles.customText(context, color: ThemeChangeService().getThemeChangeValue() ? AppColor.whiteColor : AppColor.blackColor)),
            ),
            SizedBox(height: height * 0.01),
            TextField(
              controller: _linkController,
              decoration: InputDecoration(
                  labelText: 'Website',
                  labelStyle: AppStyles.customText(context, color: ThemeChangeService().getThemeChangeValue() ? AppColor.whiteColor : AppColor.blackColor),
                  hintText: AutofillHints.url),
            ),
            SizedBox(height: height * 0.01),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: AppStyles.customText(context, color: ThemeChangeService().getThemeChangeValue() ? AppColor.whiteColor : AppColor.blackColor),
                suffixIcon: IconButton(
                  onPressed: _togglePasswordVisibility,
                  icon:
                      _isObscured ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                ),
              ),
              obscureText: _isObscured,
            ),
            SizedBox(height: height * 0.01),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  labelText: 'Description', labelStyle: AppStyles.customText(context, color: ThemeChangeService().getThemeChangeValue() ? AppColor.whiteColor : AppColor.blackColor)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: AppStyles.customText(context, color: AppColor.whiteColor),
          ),
        ),
        TextButton(
          onPressed: () async => _savePassword(context),
          child: _isEditMode
              ? Text(
                  'Update',
                  style: AppStyles.customText(context, color: AppColor.whiteColor),
                )
              : Text(
                  'Save',
                  style: AppStyles.customText(context, color: AppColor.whiteColor),
                ),
        ),
      ],
    );
  }
}
