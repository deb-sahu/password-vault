import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:password_vault/feature/widget_utils/custom_top_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/common_exports.dart';

class Passwords extends StatefulWidget {
  const Passwords({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PasswordsState createState() => _PasswordsState();
}

class _PasswordsState extends State<Passwords> {
  bool _isObscured = true;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _passwordController.text));
    CustomTopSnackbar.show(
      context, 'Password copied to clipboard', leadingIcon: Icons.check_circle_rounded, textColor: AppColor.whiteColor, backgroundColor: AppColor.primaryColor,
    );
  }

void _openWebPage() async {
  final Uri url = Uri.parse('https://www.google.com');
      if(await canLaunchUrl(url)){
        await launchUrl(url,mode: LaunchMode.inAppWebView, webViewConfiguration: const WebViewConfiguration(enableJavaScript: true));
      }else {
        throw 'Could not launch $url';
      }
}

  @override
  Widget build(BuildContext context) {
    var height = AppStyles.viewHeight(context);
    var width = AppStyles.viewWidth(context);
    bool isPortrait = AppStyles.isPortraitMode(context);

    // Sample data for icons and titles
    List<Map<String, dynamic>> items = [
      {'icon': CupertinoIcons.shield_lefthalf_fill, 'title': 'Password 1'},
      {'icon': CupertinoIcons.shield_lefthalf_fill, 'title': 'Password 2'},
      {'icon': CupertinoIcons.shield_lefthalf_fill, 'title': 'Password 3'},
      {'icon': CupertinoIcons.shield_lefthalf_fill, 'title': 'Password 4'},
      {'icon': CupertinoIcons.shield_lefthalf_fill, 'title': 'Password 5'},
    ];

    return Scaffold(
      //backgroundColor: AppColor.lightGrey,
      appBar: AppBar(
        toolbarHeight: AppStyles.appBarHeight(context),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to notification page
              GoRouter.of(context).go('/notifications');
            },
            icon: Icon(
              CupertinoIcons.heart_solid,
              size: AppStyles.appIconSize(context),
              color: AppColor.appColor,
            ),
          )
        ],
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
            // Action dialog to add new inspection or risk
          },
          backgroundColor: AppColor.appColor,
          splashColor: AppColor.themeBlueLight,
          isExtended: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Icon(
            CupertinoIcons.add,
            size: AppStyles.iconSize(context), // Increasing icon size
          ),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(width * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ExpansionTile(
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      leading: Icon(items[index]['icon'], size: width * 0.05,),
                      title: Text(
                        items[index]['title'],
                        style: AppStyles.customText(
                          context,
                          sizeFactor: 0.038,
                          color: AppColor.grey_800,
                          weight: FontWeight.w600,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(width * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: _openWebPage,
                                child: Text(
                                  'Site: Sample Site',
                                  style: AppStyles.customText(
                                    context,
                                    sizeFactor: 0.038,
                                    weight: FontWeight.w600,
                                    color: AppColor.themeBlueMid, // Change color to indicate it's a link
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              TextField(
                                style: AppStyles.customText(context, sizeFactor: 0.03),
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: _copyToClipboard,
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
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                style: AppStyles.customText(context, sizeFactor: 0.03),
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  border: OutlineInputBorder(),
                                ),
                              ),
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
