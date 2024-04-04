import 'package:flutter/material.dart';
import 'package:todo_app/core/theme/app_text_style.dart';
import 'package:todo_app/core/utils/app_images.dart';
import 'package:todo_app/core/utils/shared_preferences.dart';
import 'package:todo_app/presentation/home/home_layout.dart';
import 'package:todo_app/presentation/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) => navigate());
  }

  void navigate() {
    if (getLoginResponse != null && getIsLoggedIn()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeLayout(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.appLogo,
              height: 240,
              width: 240,
            ),
            Text(
              "Todo App",
              style: AppTextStyle.boldText20,
            ),
          ],
        ),
      ),
    );
  }
}
