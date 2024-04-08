import 'package:password_vault/constants/common_exports.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void onLogoutPress(BuildContext context) async {
   
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      //child: Text('Settings'),
      child: TextButton(
        onPressed: () async {
       
        },
        style: AppStyles.buttonPrimary,
        child: const Text('Logout'),
      ),
    );
  }
}
