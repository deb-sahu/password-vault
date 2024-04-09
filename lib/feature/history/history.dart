import 'package:flutter/material.dart';
import 'package:password_vault/feature/widget_utils/custom_empty_state_illustartion.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const EmptyStateIllustration(
      svgAsset: 'assets/images/svg/illustration5.svg',
      text: 'Oops! Work in progress',
    );
  }
}
