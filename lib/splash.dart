import 'package:flutter/material.dart';
import 'package:new_web/my_web_view.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 5),
          () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyWebView(),
            ));
      },
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/locked_in_photo-removebg-preview.png'),
          ],
        ),
      ),
    );
  }
}
