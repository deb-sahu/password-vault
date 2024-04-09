import 'package:google_fonts/google_fonts.dart';
import 'package:password_vault/constants/common_exports.dart';
import 'package:password_vault/feature/widget_utils/custom_top_snackbar.dart';
import 'package:flutter/cupertino.dart';

class AppStyles {
  // Responsive Text Styles
  
  static TextStyle headline1(BuildContext context, bool isPortrait) {
    return GoogleFonts.arsenal(
      fontSize: isPortrait ? MediaQuery.of(context).size.width * 0.06 : MediaQuery.of(context).size.height * 0.08,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle headline2(BuildContext context, bool isPortrait) {
    return GoogleFonts.coveredByYourGrace(
      fontSize: isPortrait ? MediaQuery.of(context).size.width * 0.09 : MediaQuery.of(context).size.height * 0.1,
      fontWeight: FontWeight.w500,
      color: AppColor.grey_700,
    );
  }

  static TextStyle greyText(BuildContext context, bool isPortrait) {
    return GoogleFonts.cabinCondensed(
      fontSize: isPortrait ? MediaQuery.of(context).size.width * 0.04 : MediaQuery.of(context).size.height * 0.06,
      fontWeight: FontWeight.w400,
      color: AppColor.ultraDarkGrey,
    );
  }

  static TextStyle primaryBoldText(BuildContext context, bool isPortrait) {
    return GoogleFonts.scada(
      fontSize: isPortrait ? MediaQuery.of(context).size.width * 0.05 : MediaQuery.of(context).size.height * 0.07,
      fontWeight: FontWeight.w700,
      color: AppColor.primaryColor,
    );
  }

  static TextStyle appHeaderTextStyle(BuildContext context, bool isPortrait) {
    return GoogleFonts.scada(
      fontSize: isPortrait ? MediaQuery.of(context).size.width * 0.05 : MediaQuery.of(context).size.height * 0.07,
      fontWeight: FontWeight.w800,
      color: AppColor.appColor,
    );
  }

  static TextStyle loginText(BuildContext context, bool isPortrait) {
    return TextStyle(
      fontSize: isPortrait ? MediaQuery.of(context).size.width * 0.04 : MediaQuery.of(context).size.height * 0.06,
    );
  }
    static TextStyle normalText(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.035,
    );
  }

  static TextStyle customText(
    BuildContext context, {
    Color? color,
    double? sizeFactor, // MediaQuery size factor
    String? family,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * (sizeFactor ?? 0.035),
      fontWeight: weight ?? FontWeight.w400,
      color: color ?? Colors.black,
    );
  }

  // Responsive Media Query functions
  static double viewHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double viewWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static bool isPortraitMode(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscapeMode(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static double iconSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.03;
  }

  static double appBarHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.06;
  }

  static double appIconSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.05;
  }

    static double fabSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.07;
  }

  // App header
  static const TextStyle headline16 = TextStyle(
    fontSize: 20,
  );

  // Table Text Styles
  static const TextStyle tableHeaderText18 = TextStyle(
    fontSize: 18,
    color: Colors.black,
  );

  static const TextStyle tableRowText16 = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

  // Bottom Navigation Text Styles
  static TextStyle bottomNavUnselectedText(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.03,
      fontWeight: FontWeight.w400,
      color: AppColor.blackColor,
    );
  }

  static TextStyle bottomNavSelectedText(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.03,
      fontWeight: FontWeight.w400,
      color: AppColor.appColor,
    );
  }

  // Color Button Styles
  static ButtonStyle buttonDisabled = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(AppColor.grey_600),
    backgroundColor: MaterialStateProperty.all(AppColor.whiteColor),
    side: MaterialStateProperty.all(BorderSide(
      color: AppColor.grey_600,
    )),
  );

  static ButtonStyle buttonPrimary = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(AppColor.whiteColor),
    backgroundColor: MaterialStateProperty.all(AppColor.blue_900),
  );

  static ButtonStyle buttonSecondary = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(AppColor.blue_900),
    backgroundColor: MaterialStateProperty.all(AppColor.whiteColor),
    side: MaterialStateProperty.all(BorderSide(
      color: AppColor.blue_900,
    )),
  );

  static ButtonStyle buttonFinal = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(AppColor.whiteColor),
    backgroundColor: MaterialStateProperty.all(
      AppColor.red_400,
    ),
  );

  static ButtonStyle onlyTextButton = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(AppColor.blue_900),
    backgroundColor: MaterialStateProperty.all(AppColor.grey_200),
    side: MaterialStateProperty.all(BorderSide(
      color: AppColor.lightGrey,
    )),
  );

  // Elevated Button Styles
  static ButtonStyle buttonPrimaryElevated = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), 
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0), 
      minimumSize: const Size(double.infinity, 48.0), 
      textStyle: const TextStyle(fontSize: 16.0),
      backgroundColor: AppColor.appColor,
      foregroundColor: AppColor.whiteColor);

  // Top Snackbars Styles
  static void showInfo(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    CustomTopSnackbar.show(
      context,
      message,
      leadingIcon: CupertinoIcons.info_circle_fill,
      duration: duration,
    );
  }

  static void showSuccess(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    CustomTopSnackbar.show(
      context,
      message,
      backgroundColor: AppColor.primaryColor,
      textColor: AppColor.whiteColor,
      leadingIcon: CupertinoIcons.checkmark_alt_circle_fill,
      duration: duration,
    );
  }

  static void showError(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    CustomTopSnackbar.show(
      context,
      message,
      backgroundColor: AppColor.primaryColor,
      textColor: AppColor.whiteColor,
      leadingIcon: CupertinoIcons.exclamationmark_triangle_fill,
      duration: duration,
    );
  }
}
