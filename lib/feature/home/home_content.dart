import 'package:password_vault/constants/common_exports.dart';
import 'package:flutter/cupertino.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = AppStyles.viewHeight(context);
    var width = AppStyles.viewWidth(context);
    bool isPortrait = AppStyles.isPortraitMode(context);

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
          'Home',
          style: AppStyles.appHeaderTextStyle(context, isPortrait),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(width * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'In Progress',
                      style: AppStyles.customText(
                        context,
                        sizeFactor: 0.038,
                        weight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    SizedBox(
                      height: height * 0.025,
                      width: width * 0.055,
                      child: Badge.count(
                        count: 4,
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
                TextButton(
                  onPressed: () => {
                    // Navigate to Inspection List
                    GoRouter.of(context).go('/viewInProgress'),
                  },
                  style: AppStyles.onlyTextButton,
                  child: Text(
                    'View All',
                    style: AppStyles.customText( context,
                      family: 'OpenSans',
                      sizeFactor: 0.035,
                      weight: FontWeight.w500,
                      color: AppColor.blue_900,
                    ),
                  ),
                )
              ],
            ),

            /// Add a list of inspection in progress - Horizontal List
         SizedBox(
              width: width,
              height: isPortrait ? height * 0.14 : height * 0.4,
              child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                controller: ScrollController(),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(right: width * 0.04),
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
                            blurStyle: BlurStyle.solid),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Item $index', style: AppStyles.customText(context, weight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Description of item $index', style: AppStyles.customText(context),),
                        ],
                      ),
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
