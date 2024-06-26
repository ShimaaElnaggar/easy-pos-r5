import 'package:animate_do/animate_do.dart';
import 'package:easy_pos_r5/views/home_view.dart';
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

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
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
      title: ' Welcome To\nEasy Pos',
      image: 'assets/images/deal.png',
      description:
          "This is a software solution used by businesses \n to manage sales transactions."),
  Onboard(
    title: ' Generate receipts',
    image: 'assets/images/receipt.png',
    description: 'You can Generate receipts any time and \nevery where..',
  ),
  Onboard(
    title: ' Analyze sales data',
    image: 'assets/images/analyse.png',
    description:
        'Easy Pos streamlines the checkout process and enhances overall efficiency. 🛒💼 ',
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
          style: TextStyle(fontWeight:FontWeight.w700,fontSize:30,color: Theme.of(context).primaryColor
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
