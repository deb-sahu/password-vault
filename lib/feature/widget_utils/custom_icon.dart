import 'package:password_vault/constants/common_exports.dart';

class CustomIcon extends StatelessWidget {
  final String? selectedAssetPath;
  final String? unselectedAssetPath;
  final IconData? selectedIcon;
  final IconData? unselectedIcon;
  final bool isSelected;

  const CustomIcon({
   this.selectedAssetPath,
   this.unselectedAssetPath,
   this.selectedIcon,
   this.unselectedIcon,
   required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedAssetPath != null && unselectedAssetPath != null) {
      return SvgPicture.asset(
        isSelected ? selectedAssetPath! : unselectedAssetPath!,
        height: AppStyles.iconSize(context),
        width: AppStyles.iconSize(context),
        color: isSelected ? AppColor.appColor : AppColor.blackColor,
      );
    } else if (selectedIcon != null && unselectedIcon != null) {
      return Icon(
        isSelected ? selectedIcon : unselectedIcon,
        size: AppStyles.iconSize(context),
        color: isSelected ? AppColor.appColor : AppColor.blackColor,
      );
    } else {
      // Handle invalid input or return a default widget
      return Container();
    }
  }
}
