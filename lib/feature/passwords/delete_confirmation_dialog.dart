import 'package:password_vault/constants/common_exports.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String passwordId;
  final VoidCallback onDelete;

  const DeleteConfirmationDialog({
    required this.passwordId,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isPortrait = AppStyles.isPortraitMode(context);
    return AlertDialog(
      backgroundColor: AppColor.grey_200,
      surfaceTintColor: AppColor.grey_100,
      title: Text('Delete Password', style: AppStyles.primaryBoldText(context, isPortrait)),
      content: Text('Are you sure you want to delete this password?',
          style: AppStyles.customText(context)),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel',
              style: AppStyles.customText(
                context,
                color: AppColor.whiteColor,
              )),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            onDelete(); // Proceed with deleting the password
          },
          child: Text(
            'Delete',
            style: AppStyles.customText(
              context,
              color: AppColor.whiteColor,
            ),
          ),
        ),
      ],
    );
  }
}
