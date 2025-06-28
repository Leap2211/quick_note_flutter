import 'package:flutter/material.dart';
import 'package:quick_app/Widget/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final Gradient _gradient = const LinearGradient(
    colors: [
      Color(0xFF42A5F5),
      Color(0xFF1E88E5),
      Color(0xFF5C6BC0),
      Color(0xFF7E57C2),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final List<Map<String, dynamic>> onboardingData = [
    {
      "title": "Welcome to QuickNotes",
      "description": "Easily create, edit, and manage your notes anytime, anywhere.",
      "icon": Icons.note_alt_outlined,
    },
    {
      "title": "Organize Your Thoughts",
      "description": "Filter, search, and sort notes with powerful tools.",
      "icon": Icons.search_outlined,
    },
    {
      "title": "Stay Productive",
      "description": "Add new notes quickly and never forget important ideas.",
      "icon": Icons.check_circle_outline,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.animateToPage(_currentPage + 1,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  Paint _createGradientPaint(Rect bounds) {
    return Paint()..shader = _gradient.createShader(bounds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (_, index) {
                  final data = onboardingData[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Gradient Icon
                        ShaderMask(
                          shaderCallback: (bounds) => _gradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: Icon(data["icon"], size: 140, color: Colors.white),
                        ),
                        const SizedBox(height: 50),

                        // Gradient Title Text
                        LayoutBuilder(builder: (context, constraints) {
                          return Text(
                            data["title"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..shader = _gradient.createShader(
                                  Rect.fromLTWH(
                                    0,
                                    0,
                                    constraints.maxWidth,
                                    50,
                                  ),
                                ),
                            ),
                          );
                        }),
                        const SizedBox(height: 20),

                        // Gradient Description Text (with opacity)
                        LayoutBuilder(builder: (context, constraints) {
                          return Text(
                            data["description"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              foreground: Paint()
                                ..shader = _gradient.createShader(
                                  Rect.fromLTWH(
                                    0,
                                    0,
                                    constraints.maxWidth,
                                    20,
                                  ),
                                ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildIndicator(),
            const SizedBox(height: 20),
            _buildNextButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingData.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: _currentPage == index ? 24 : 12,
          height: 12,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color(0xFF42A5F5)
                : Colors.blue[100],
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: InkWell(
        onTap: _nextPage,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: _gradient,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.4),
                offset: const Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            "Get Started",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
