import 'package:flutter/material.dart';
import 'package:tomato/screen/home_screen.dart';
import 'package:tomato/screen/start/address_page.dart';
import 'package:tomato/screen/start/auth_page.dart';
import 'package:tomato/screen/start/intro_page.dart';

class startScreen extends StatelessWidget {
  startScreen({Key? key}) : super(key: key);

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        HomeScreen(),

    );
  }
}
