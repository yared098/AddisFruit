import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';  // Add this package

class HeaderAnimationWidget extends StatefulWidget {
  final List<String> sliderImages;
  final List<String> topText;

  const HeaderAnimationWidget({
    Key? key,
    required this.sliderImages,
    required this.topText,
  }) : super(key: key);

  @override
  _HeaderAnimationWidgetState createState() => _HeaderAnimationWidgetState();
}

class _HeaderAnimationWidgetState extends State<HeaderAnimationWidget> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: 0,
    );

    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.18;

    return Column(
      children: [
        SizedBox(
          height: height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.sliderImages.length,
            itemBuilder: (context, index) {
              bool active = index == _currentPage;
              return _buildPageItem(widget.sliderImages[index], widget.topText[index], active);
            },
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.sliderImages.length,
          effect: ExpandingDotsEffect(
            activeDotColor: Colors.green,
            dotColor: Colors.grey.shade400,
            dotHeight: 8,
            dotWidth: 8,
            spacing: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildPageItem(String imageUrl, String text, bool active) {
    final double blur = active ? 15 : 5;
    final double offset = active ? 10 : 5;
    final double top = active ? 0 : 20;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 10, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: blur,
            offset: Offset(0, offset),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.error)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  "🔥 $text 🛒",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 4,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
