import 'dart:math';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato/constants/common_size.dart';
import 'package:tomato/states/user_provider.dart';
import 'package:tomato/utils/logger.dart';

class IntroPage extends StatelessWidget {
  PageController controller;

  IntroPage(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<UserProvider>().setUserAuth(true);
    logger.d('current user state: ${context.read<UserProvider>().userState}');
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size size = MediaQuery.of(context).size;

        final imgSize = size.width - 32;
        final sizeOfPosImg = imgSize * 0.1;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: common_padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '토마토마켓',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                Stack(
                  children: [
                    ExtendedImage.asset('assets/imgs/carrot_intro.png'),
                    Positioned(
                      width: sizeOfPosImg,
                      left: imgSize * 0.45,
                      top: imgSize * 0.45,
                      height: sizeOfPosImg,
                      child: ExtendedImage.asset(
                          'assets/imgs/carrot_intro_pos.png'),
                    ),
                  ],
                ),
                Text(
                  '서울여자대학교 중고 직거래마켓',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  '''토마토마켓은 교내 직거래 마켓이에요.
내 전공이나 관심 전공을 설정하고 시작해보세요.''',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: () async {
                        controller.animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                        logger.d('on thext button clicked!!!');
                      },
                      child: Text('내 동네 설정하고 시작하기',
                          style: Theme.of(context).textTheme.button),
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
