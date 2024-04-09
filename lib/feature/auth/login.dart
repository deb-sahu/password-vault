import 'package:password_vault/constants/common_exports.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = AppStyles.viewHeight(context);
    var width = AppStyles.viewWidth(context);
    bool isPortrait = AppStyles.isPortraitMode(context);

    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(isPortrait ? 0.9 : 0.2),
                BlendMode.dstIn,
              ),
              child: SvgPicture.asset(
                'assets/images/svg/illustration2.svg',
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false, // Commented to go back to main content without login
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
            minimum: EdgeInsets.all(width * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Password Vault',
                      style: AppStyles.headline1(context, isPortrait),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'All your passwords in one place',
                      style: AppStyles.greyText(context, isPortrait),
                    ),
                  ],
                ),
                Flexible(
                  child: SizedBox(height: height * 0.8),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: AppStyles.buttonPrimaryElevated,
                      onPressed: () {
                        GoRouter.of(context).go('/homePage');
                      },
                      child: Text(
                        'Continue',
                        style: AppStyles.loginText(context, isPortrait),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Let\'s get started!',
                  style: AppStyles.customText(context, sizeFactor: 0.039, family: 'OpenSans'),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
