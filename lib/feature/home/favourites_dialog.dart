// ignore_for_file: use_build_context_synchronously

import 'package:password_vault/cache/hive_models/passwords_model.dart';
import 'package:password_vault/constants/common_exports.dart';
import 'package:password_vault/feature/widget_utils/custom_empty_state_illustartion.dart';
import 'package:password_vault/service/cache/cache_service.dart';
import 'package:password_vault/service/route/bottom_nav_route.dart';

class FavoritesDialog extends StatefulWidget {
  const FavoritesDialog({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FavoritesDialogState createState() => _FavoritesDialogState();
}

class _FavoritesDialogState extends State<FavoritesDialog> {
  List<PasswordModel> passwords = [];
  List<bool> isPasswordInFavorites = [];

  @override
  void initState() {
    super.initState();
    loadPasswordsData();
  }

  void loadPasswordsData() async {
    List<PasswordModel> loadedPasswords = await CacheService().getPasswordsData();
    //List<PasswordModel> favorites = await CacheService().getFavouritesData();
    List<bool> initialIsPasswordInFavorites = List.filled(loadedPasswords.length, false);

    await Future.forEach(loadedPasswords, (password) async {
      bool isFavorite = await CacheService().isPasswordInFavoritesByPasswordId(password.passwordId);
      int index = loadedPasswords.indexOf(password);
      initialIsPasswordInFavorites[index] = isFavorite;
    });

    setState(() {
      passwords = loadedPasswords;
      isPasswordInFavorites = initialIsPasswordInFavorites;
    });
  }

  void toggleFavorite(PasswordModel password, bool newValue) async {
    if (newValue) {
      // Add password to favorites
      bool success = await CacheService().addPasswordsToFavourites(password);
      if (success) {
        // Password added to favorites successfully
        AppStyles.showSuccess(context, 'Password added to favorites');
      } else {
        // Failed to add password to favorites
        AppStyles.showError(context, 'Failed to add password to favorites');
      }
    } else {
      // Remove password from favorites
      bool success =
          await CacheService().removePasswordFromFavouritesByPasswordId(password.passwordId);
      if (success) {
        // Password removed from favorites successfully
        AppStyles.showSuccess(context, 'Password removed from favorites');
      } else {
        // Failed to remove password from favorites
        AppStyles.showError(context, 'Failed to remove password from favorites');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = AppStyles.viewHeight(context);
    var width = AppStyles.viewWidth(context);
    var isPortrait = AppStyles.isPortraitMode(context);

    return AlertDialog(
      backgroundColor: AppColor.grey_200,
      surfaceTintColor: AppColor.grey_100,
      title: Text('Add Favourites', style: AppStyles.primaryBoldText(context, isPortrait)),
      content: passwords.isEmpty
          ? const EmptyStateIllustration(
              svgAsset: 'assets/images/svg/illustration1.svg',
              text: 'Did you add any passwords?',
            )
          : SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: passwords.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: height * 0.008, horizontal: width * 0.03),
                          decoration: BoxDecoration(
                            color: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(width * 0.02),
                          ),
                          child: Text(
                            passwords[index].passwordTitle,
                            style: AppStyles.customText(context, sizeFactor: 0.04),
                          ),
                        ),
                      ),
                      Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 0.01),
                        ),
                        value: isPasswordInFavorites[index],
                        onChanged: (newValue) {
                          setState(() {
                            isPasswordInFavorites[index] = newValue!;
                          });
                          toggleFavorite(passwords[index], newValue!);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NavRoute(
                  selectedIndex: 0,
                ),
              ),
            ),
          },
          child: Text(
            'Close',
            style: AppStyles.customText(context, color: AppColor.whiteColor),
          ),
        ),
      ],
    );
  }
}