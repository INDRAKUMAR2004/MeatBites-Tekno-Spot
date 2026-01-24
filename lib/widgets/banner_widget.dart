import 'package:flutter/material.dart';
import '../constants/colors.dart';

class BannerModel {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<Color> gradientColors;
  final String? badge;

  BannerModel({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.gradientColors,
    this.badge,
  });
}

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentIndex = 0;

  final List<BannerModel> _banners = [
    // Banner 1: Offer
    BannerModel(
      title: "FLAT 50% OFF",
      subtitle: "On your first order | \n Code: WELCOME50",
      imagePath: 'assets/products/curry-cut-chicken.png',
      // Gradient: Brand Red to Deep Maroon (Classic Brand Look)
      gradientColors: [const Color(0xFFB32624), const Color(0xFF5A1212)],
      badge: "LIMITED DEAL",
    ),
    // Banner 2: Chicken
    BannerModel(
      title: "FARM FRESH\nCHICKEN",
      subtitle: "Antibiotic Free & 100% Halal",
      imagePath: 'assets/category_icons/chicken.png',
      // Gradient: Burnt Orange to Brand Red (Fresh & Warm)
      gradientColors: [const Color(0xFFE55D87), const Color(0xFFB32624)],
      badge: "MOST LOVED",
    ),
    // Banner 3: Mutton
    BannerModel(
      title: "PREMIUM\nGOAT CUTS",
      subtitle: "Fresh tender cuts for Biryani",
      imagePath: 'assets/category_icons/mutton.png',
      // Gradient: Rich Gold/Amber (Premium/Royal for Mutton) avoiding dull brown
      gradientColors: [const Color(0xFFF2994A), const Color(0xFFF2C94C)],
      badge: "FRESH ARRIVAL",
    ),
    // Banner 4: Fish
    BannerModel(
      title: "CATCH OF\nTHE DAY",
      subtitle: "Fresh seawater fish delivered",
      imagePath: 'assets/category_icons/fish.png',
      // Gradient: Deep Ocean Blue (Kept for semantic clarity but richer)
      gradientColors: [const Color(0xFF141E30), const Color(0xFF243B55)],
      badge: "JUST IN",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 210, // Increased to Prevent Overflow
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildBannerCard(_banners[index], index == _currentIndex);
            },
          ),
        ),
        const SizedBox(height: 12),
        // Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _banners.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentIndex == entry.key ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentIndex == entry.key
                    ? AppColors.primary
                    : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBannerCard(BannerModel banner, bool isActive) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: isActive ? 0 : 8),
      child: Stack(
        clipBehavior: Clip
            .none, // Allow slight overlap effects if possible context allows
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: banner.gradientColors,
              ),
              boxShadow: [
                BoxShadow(
                  color: banner.gradientColors[0].withOpacity(0.4),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // 1. Subtle Radial Glow Pattern behind image
                Positioned(
                  right: -40,
                  bottom: -40,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. Decorative Top Circle
                Positioned(
                  right: -20,
                  top: -60,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // 3. Text Content (Left Side)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20,
                      top: 20,
                      bottom: 20,
                      right: 140), // Right padding makes room for image
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (banner.badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color:
                                Colors.black.withOpacity(0.2), // Darker glass
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 0.5),
                          ),
                          child: Text(
                            banner.badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      Text(
                        banner.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22, // Slightly smaller for better fit
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            letterSpacing: -0.5,
                            shadows: [
                              Shadow(
                                  color: Colors.black38,
                                  offset: Offset(0, 2),
                                  blurRadius: 4)
                            ]),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        banner.subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 1),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4))
                            ]),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Shop Now",
                              style: TextStyle(
                                color: banner.gradientColors[0],
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded,
                                size: 12, color: banner.gradientColors[0])
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                // 4. Hero Image (Right Side - Popping Out)
                Positioned(
                  right:
                      -25, // Negative margin to cut off slightly or look impactful
                  bottom: -15,
                  child: Hero(
                    tag: 'banner_${banner.title}',
                    child: Transform.rotate(
                      angle: 0.05, // Slight tilt for dynamism
                      child: Image.asset(
                        banner.imagePath,
                        height: 170, // Larger
                        width: 170,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
