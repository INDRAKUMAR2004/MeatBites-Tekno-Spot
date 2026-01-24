import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'About MeatBites',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    Color(0xFF8E1E1C),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.chefHat,
                        color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Freshness You Can Trust',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.1),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Delivering the finest cuts from farm to your fork,\nensuring quality and hygiene at every step.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.5),
                  ),
                ],
              ),
            ),

            // 2. Our Mission
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OUR MISSION',
                    style: TextStyle(
                        color: AppColors.primary.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Redefining the way you buy meat.',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'MeatBites was born from a simple idea: that everyone deserves access to fresh, chemical-free, and ethically sourced meat. We partner directly with local farmers who share our values for sustainable and humane farming practices. By cutting out the middlemen, we ensure that you get the freshest produce at the best prices.',
                    style: TextStyle(
                        color: Colors.grey[700], height: 1.6, fontSize: 15),
                  ),
                ],
              ),
            ),

            // 3. Why Choose Us Grid
            Container(
              color: const Color(0xFFFAFAFA),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                children: [
                  const Text(
                    'Why Choose MeatBites?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: const [
                      _FeatureCard(
                        icon: LucideIcons.shieldCheck,
                        title: '100% Antibiotic Free',
                        color: Colors.green,
                      ),
                      _FeatureCard(
                        icon: LucideIcons.thermometerSnowflake,
                        title: 'Cold Chain Supply',
                        color: Colors.blue,
                      ),
                      _FeatureCard(
                        icon: LucideIcons.truck,
                        title: 'Express Delivery',
                        color: Colors.orange,
                      ),
                      _FeatureCard(
                        icon: LucideIcons.award,
                        title: 'FSSAI Certified',
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 4. Team / Stats Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('50k+', 'Happy\nCustomers'),
                  Container(width: 1, height: 40, color: Colors.grey[200]),
                  _buildStat('25+', 'City\nPresence'),
                  Container(width: 1, height: 40, color: Colors.grey[200]),
                  _buildStat('4.8/5', 'App\nRating'),
                ],
              ),
            ),

            // 5. Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF1A1A1A),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialIcon(LucideIcons.instagram),
                      const SizedBox(width: 20),
                      _socialIcon(LucideIcons.twitter),
                      const SizedBox(width: 20),
                      _socialIcon(LucideIcons.facebook),
                      const SizedBox(width: 20),
                      _socialIcon(LucideIcons.linkedin),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '© 2026 MeatBites Pvt Ltd',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'v1.0.0',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.3), fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ],
      ),
    );
  }
}
