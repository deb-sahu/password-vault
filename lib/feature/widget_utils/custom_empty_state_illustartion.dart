
import 'package:password_vault/constants/common_exports.dart';

class EmptyStateIllustration extends StatelessWidget {
  final String svgAsset;
  final String text;

  const EmptyStateIllustration({
    required this.svgAsset,
    required this.text,
    Key? key,
  }) : super(key: key);

@override
Widget build(BuildContext context) {
  var height = AppStyles.viewHeight(context);
  var isPortrait = AppStyles.isPortraitMode(context);
  return Center(
    child: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(isPortrait ? 0.9 : 0.2),
            BlendMode.dstIn,
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                svgAsset,
              ),
              SizedBox(height: height * 0.01), // Adjust spacing between SVG and text as needed
              Text(
                text,
                style: AppStyles.headline2(context, isPortrait),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}

