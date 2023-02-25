import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/buttons/filled_button.dart';
import 'package:quote_tiger/provider/globals_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  final bool fromDrawer;
  const OnBoarding({Key? key, this.fromDrawer = false}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    GlobalsProvider globalsProvider = Provider.of<GlobalsProvider>(context);
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SmoothPageIndicator(
              controller: pageController,
              count: 3,
              effect: const WormEffect(
                  activeDotColor: Color(0xFFFCA205),
                  dotColor: Colors.black,
                  dotWidth: 8,
                  dotHeight: 8),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        children: [
          _OnboardingPage(
              descripton: 'Worlds first request based marketplace',
              buttonText: 'Continue',
              onPressed: () {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              }),
          _OnboardingPage(
              descripton: 'Create and post your requests within minutes',
              buttonText: 'Continue',
              onPressed: () {
                pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
              }),
          _OnboardingPage(
              descripton: 'Collect all your quotes in one place.',
              buttonText: 'Get started',
              onPressed: () {
                globalsProvider.incrementTimesAppOpened();
                if (widget.fromDrawer) {
                  Navigator.pop(context);
                }
              }),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String descripton;
  final String buttonText;
  final VoidCallback onPressed;

  const _OnboardingPage(
      {Key? key,
      required this.descripton,
      required this.buttonText,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          SizedBox(
            child: Image.asset(
              'assets/logo/banner.png',
            ),
          ),
          SizedBox(
            height: 140,
            child: Text(descripton,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                    letterSpacing: -0.02)),
          ),
          FilledTextButton(
            onPressed: onPressed,
            message: buttonText,
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox()
        ],
      ),
    );
  }
}
