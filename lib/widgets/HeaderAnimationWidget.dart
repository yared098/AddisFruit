import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
    _pageController = PageController(viewportFraction: 0.85);
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() => _currentPage = next);
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
    final double height = MediaQuery.of(context).size.height * 0.25;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SizedBox(
          height: height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.sliderImages.length,
            itemBuilder: (context, index) {
              bool active = index == _currentPage;
              return _buildPageItem(
                context,
                widget.sliderImages[index],
                widget.topText[index],
                active,
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.sliderImages.length,
          effect: ExpandingDotsEffect(
            activeDotColor: isDark ? Colors.tealAccent : Colors.green,
            dotColor: isDark ? Colors.white30 : Colors.grey.shade400,
            dotHeight: 8,
            dotWidth: 8,
            spacing: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildPageItem(BuildContext context, String imageUrl, String text, bool active) {
    final theme = Theme.of(context);
    final double blur = active ? 16 : 5;
    final double offset = active ? 10 : 5;
    final double top = active ? 0 : 20;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 10, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.2),
            blurRadius: blur,
            offset: Offset(0, offset),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator(color: theme.primaryColor));
              },
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.redAccent)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Text(
                  "🔥 $text 🛒",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    shadows: const [
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
