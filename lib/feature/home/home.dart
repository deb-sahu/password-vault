import 'package:password_vault/cache/hive_models/passwords_model.dart';
import 'package:password_vault/constants/common_exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:password_vault/feature/home/favourites_dialog.dart';
import 'package:password_vault/feature/widget_utils/custom_empty_state_illustartion.dart';
import 'package:password_vault/service/cache/cache_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PasswordModel> favoritePasswords = [];

  @override
  void initState() {
    super.initState();
    loadFavoritePasswords();
  }

  void loadFavoritePasswords() async {
    List<PasswordModel> passwords = await CacheService().getFavouritesData();
    setState(() {
      favoritePasswords = passwords;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = AppStyles.viewHeight(context);
    var width = AppStyles.viewWidth(context);
    bool isPortrait = AppStyles.isPortraitMode(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: AppStyles.appBarHeight(context),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => const FavoritesDialog(),
              );
            },
            icon: Icon(
              CupertinoIcons.heart_solid,
              size: AppStyles.appIconSize(context),
              color: AppColor.appColor,
            ),
          )
        ],
        title: Text(
          'Home',
          style: AppStyles.appHeaderTextStyle(context, isPortrait),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(width * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (favoritePasswords.isNotEmpty) ...{
              SizedBox(height: height * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Favorites',
                        style: AppStyles.customText(
                          context,
                          sizeFactor: 0.038,
                          weight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      SizedBox(
                        height: height * 0.025,
                        width: width * 0.055,
                        child: Badge.count(
                          count: favoritePasswords.length,
                          backgroundColor: AppColor.darkBlue,
                          textColor: AppColor.whiteColor,
                          textStyle: AppStyles.customText(
                            context,
                            sizeFactor: 0.025,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*  TextButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NavRoute(
                            selectedIndex: 1,
                          ),
                        ),
                      ),
                    },
                    style: AppStyles.onlyTextButton,
                    child: Text(
                      'View All',
                      style: AppStyles.customText(
                        context,
                        sizeFactor: 0.035,
                        weight: FontWeight.w500,
                        color: AppColor.blue_900,
                      ),
                    ),
                  ) */
                ],
              ),
            },
            SizedBox(height: height * 0.015),
            if (favoritePasswords.isNotEmpty) ...{
              SizedBox(
                width: width,
                height: isPortrait ? height * 0.5 : height * 0.2,
                child: ListView.builder(
                  itemCount: favoritePasswords.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: height * 0.01),
                      width: width * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color of the container
                        borderRadius: BorderRadius.circular(8.0),
                        backgroundBlendMode: BlendMode.srcOver,
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.midGrey.withOpacity(0.5), // Color of the shadow
                            spreadRadius: 0.5,
                            blurRadius: 1.5,
                            offset: Offset.fromDirection(2, 1),
                            blurStyle: BlurStyle.solid,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              favoritePasswords[index].passwordTitle,
                              style: AppStyles.customText(context, weight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              favoritePasswords[index].passwordDescription,
                              style: AppStyles.customText(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            },
            if (favoritePasswords.isEmpty) ...{
              const Expanded(
                child: Center(
                  child: EmptyStateIllustration(
                    svgAsset: 'assets/images/svg/illustration4.svg',
                    text: 'Add some favorites, eh?',
                  ),
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}
