import 'dart:async';
import 'dart:developer' as developer;
import 'package:password_vault/constants/common_exports.dart';
import 'package:password_vault/service/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _streamSubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _streamSubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
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
                      onPressed: () async {
                        if (_connectionStatus == ConnectivityResult.none) {
                          AppStyles.showError(context, 'No internet connection',
                              duration: const Duration(seconds: 5));
                          return;
                        }
                        final result = await DataApiService().getData();
                        if (result.isNotEmpty && context.mounted) {
                          //AppStyles.showSuccess(context, 'Logged in successfully');
                          // Navigate to the main app content (Home page)
                          GoRouter.of(context).go('/homePage');
                        }
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
