import 'dart:async';
import 'dart:math';

import 'package:fb_task/images.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final int squareSpeed = 1;
  final double squareSize = 160;
  final int reoccurTime = 100;
  int imageIndex = 0;
  late AnimationController tweenController;
  late double _bottomPosition =
      (MediaQuery.of(context).size.height / 2) - (squareSize / 2);
  late double _rightPosition =
      (MediaQuery.of(context).size.width / 2) - (squareSize / 2);
  late int _screenHeight;
  late int _screenWidth;
  late String squareDirection;

  @override
  void initState() {
    super.initState();

    tweenController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() {
        Timer.periodic(
          Duration(milliseconds: reoccurTime),
          (timer) {
            switch (squareDirection) {
              case 'bottom':
                if (_bottomPosition >= 0) {
                  setState(() {
                    _bottomPosition -= squareSpeed;
                  });
                  if (_bottomPosition.toInt() == 0) {
                    squareDirection = 'up';
                  }
                }
                break;
              case 'up':
                if (_bottomPosition <= _screenHeight - squareSize) {
                  setState(() {
                    _bottomPosition += squareSpeed;
                  });
                  if (_bottomPosition.toInt() == _screenHeight - squareSize) {
                    squareDirection = 'bottom';
                  }
                }
                break;

              case 'right':
                if (_rightPosition >= 0) {
                  setState(() {
                    _rightPosition -= squareSpeed;
                  });
                  if (_rightPosition.toInt() == 0) {
                    squareDirection = 'left';
                  }
                }
                break;
              case 'left':
                if (_rightPosition <= _screenWidth) {
                  setState(() {
                    _rightPosition += squareSpeed;
                  });
                  if (_rightPosition.toInt() == _screenWidth - squareSize) {
                    squareDirection = 'right';
                  }
                }
                break;

              default:
            }
          },
        );
      });
  }

  @override
  void dispose() {
    tweenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    _screenHeight = mediaSize.height.toInt();
    _screenWidth = mediaSize.width.toInt();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              bottom: _bottomPosition,
              left: _rightPosition,
              child: GestureDetector(
                onHorizontalDragEnd: (deg) {
                  if (deg.primaryVelocity! > 0) {
                    squareDirection = 'left';
                  } else if (deg.primaryVelocity! < 0) {
                    squareDirection = 'right';
                  }
                  tweenController.forward();
                },
                onVerticalDragEnd: ((deg) {
                  if (deg.primaryVelocity! > 0) {
                    squareDirection = 'bottom';
                  } else if (deg.primaryVelocity! < 0) {
                    squareDirection = 'up';
                  }
                  tweenController.forward();
                }),
                onTap: () {
                  final random = Random();
                  setState(() {
                    imageIndex = random.nextInt(Images.images.length);
                  });
                },
                child: Container(
                  width: squareSize,
                  height: squareSize,
                  decoration: BoxDecoration(
                    color: const Color(0xff28c5cc),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(Images.images[imageIndex]),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
