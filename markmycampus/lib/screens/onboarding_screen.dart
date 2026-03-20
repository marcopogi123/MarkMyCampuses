import 'package:flutter/material.dart';
import 'mark_my_campus_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Map<String, String>> _data = [
    {
      "title": "Are you lost?",
      "desc":
          "This learning app is designed to help locate your rooms, buildings and labs.",
      "image": "assets/onboarding1.png",
    },
    {
      "title": "Navigate with ease",
      "desc":
          "This learning app is designed to help locate your rooms, buildings and labs.",
      "image": "assets/onboarding2.png",
    },
    {
      "title": "Find your way around",
      "desc":
          "This learning app is designed to help locate your rooms, buildings and labs.",
      "image": "assets/onboarding3.png",
    },
  ];

  // Helper to navigate to the landing screen
  void _navigateToLanding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (c) => const MarkMyCampusScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemCount: _data.length,
                  itemBuilder: (context, index) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Image.asset(
                          _data[index]["image"]!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 60),
                      Text(
                        _data[index]["title"]!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 45,
                          vertical: 20,
                        ),
                        child: Text(
                          _data[index]["desc"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 60),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _data.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? const Color(0xFFFFD54F)
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage == _data.length - 1) {
                          _navigateToLanding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOutQuart,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD54F),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 58),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        _currentPage == _data.length - 1
                            ? "Get Started"
                            : "Next",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _navigateToLanding,
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
