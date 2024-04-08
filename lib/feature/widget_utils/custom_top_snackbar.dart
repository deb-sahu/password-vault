import 'package:password_vault/constants/common_exports.dart';

class CustomTopSnackbar {
  static void show(BuildContext context, String message,
      {Color backgroundColor = const Color(0xFFb5e0f5),
      Color borderColor = const Color(0xFF42b0d5),
      Color textColor = Colors.black,
      IconData? leadingIcon,
      Duration duration = const Duration(seconds: 3)}) {
    final overlay = Overlay.of(context);
    var height = AppStyles.viewHeight(context);
    var width = AppStyles.viewWidth(context);
    final overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: 80,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: height * 0.08,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor, width: 0.5),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppColor.greyColor,
                  blurRadius: 10.0,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                if (leadingIcon != null)
                  Icon(
                    leadingIcon,
                    color: textColor,
                    size: height * 0.03,
                  ),
                if (leadingIcon != null) SizedBox(width: width * 0.02),
                Flexible(
                  child: Text(
                    message,
                    style: AppStyles.customText(context, color: textColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}
