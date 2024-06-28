import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:easy_pos_r5/views/Home/home_view.dart';

import 'package:easy_pos_r5/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late PageController _pageController;
  int _pageIndex = 0;
  late Timer _timer;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageIndex < demoData.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        timer.cancel();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemCount: demoData.length,
                  itemBuilder: (context, index) => OnBoardingContent(
                    title: demoData[index].title,
                    image: demoData[index].image,
                    description: demoData[index].description,
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    demoData.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: DotIndicator(
                        isActive: index == _pageIndex,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 45,
                    width: 159,
                    child: FadeInRight(
                      child: CustomElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeView()),
                          );
                        },
                        title: 'Continue',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).primaryColor : Colors.blue.shade100,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }
}

class Onboard {
  final String title, image, description;

  Onboard({
    required this.title,
    required this.image,
    required this.description,
  });
}

final List<Onboard> demoData = [
  Onboard(
      title: ' Welcome To \n Easy Pos',
      image: 'assets/images/welcome.jpg',
      description:
          "Software solution tool used by businesses \n to manage sales transactions."),
  Onboard(
    title: ' Create Invoices',
    image: 'assets/images/invoices.jpg',
    description: 'Create Professional invoices in a minute!',
  ),

  Onboard(
    title: ' Manage Clients',
    image: 'assets/images/clients.jpg',
    description: 'Manage clients in a flexible way!',
  ),
  Onboard(
    title: ' Build Orders',
    image: 'assets/images/orders.jpg',
    description: 'Build your selling items!',
  ),

];

class OnBoardingContent extends StatelessWidget {
  const OnBoardingContent({
    super.key,
    required this.title,
    required this.image,
    required this.description,
  });

  final String title, image, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:30,
            color: Theme.of(context).primaryColor,
          ),
              ),
        const Spacer(),
        Image.asset(
          image,
          height: 200,
        ),
        const Spacer(),
        Text(
          description,
          textAlign: TextAlign.center,
         style: TextStyle(fontSize:20,color: Colors.blue.shade300),
        ),
        const Spacer(),
      ],
    );
  }
}
