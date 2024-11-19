import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/data/dummy_data.dart';
import 'package:news_app/provider/onBoarding_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  ConsumerState<OnBoardingScreen> createState() {
    return _OnBoardingState();
  }
}

class _OnBoardingState extends ConsumerState<OnBoardingScreen> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  void _navigateToSlide(int index) async {
    if (index > data.length) {
      return;
    }

    if (index == data.length) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final wasLogin = ref.read(OnBoardProvider.notifier).onBoard();
      prefs.setBool('isFirstTimeUser', wasLogin);
    }

    await _carouselController.animateToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'NewsTren.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 30,
          ),
          CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                  height: 400,
                  viewportFraction: 1,
                  autoPlayCurve: Curves.easeInOut,
                  onPageChanged: (index, value) {
                    setState(() {
                      _currentIndex = index;
                    });
                  }),
              items: data.map((item) {
                return Builder(builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.asset(item['image']!),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          item['title']!,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 20),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          item['content']!,
                          softWrap: true,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  );
                });
              }).toList()),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: data.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  _navigateToSlide(entry.key);
                },
                child: Container(
                  width: 20,
                  height: 7,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: _currentIndex == entry.key
                        ? Colors.orange
                        : Colors.grey,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 70,
          ),
          Container(
            width: 150,
            decoration: BoxDecoration(
                color: Colors.orange, borderRadius: BorderRadius.circular(5)),
            child: TextButton(
                onPressed: () {
                  _currentIndex += 1;
                  _navigateToSlide(_currentIndex);
                },
                child: Text(
                  _currentIndex == data.length - 1 ? 'Get Started' : 'Next',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
          )
        ],
      )),
    );
  }
}
