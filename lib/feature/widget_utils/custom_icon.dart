import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:password_vault/constants/common_exports.dart';
import 'package:password_vault/service/singletons/theme_change_manager.dart';

class CustomIcon extends ConsumerWidget {
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
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedAssetPath != null && unselectedAssetPath != null) {
      return SvgPicture.asset(
        isSelected ? selectedAssetPath! : unselectedAssetPath!,
        height: AppStyles.iconSize(context),
        width: AppStyles.iconSize(context),
        color: isSelected ? AppColor.appColor : ThemeChangeService().getThemeChangeValue() ? AppColor.grey_100 : AppColor.blackColor,
      );
    } else if (selectedIcon != null && unselectedIcon != null) {
      return Icon(
        isSelected ? selectedIcon : unselectedIcon,
        size: AppStyles.iconSize(context),
        color: isSelected ? AppColor.appColor : ThemeChangeService().getThemeChangeValue() ? AppColor.grey_100 : AppColor.blackColor,
      );
    } else {
      // Handle invalid input or return a default widget
      return Container();
    }
  }
}
