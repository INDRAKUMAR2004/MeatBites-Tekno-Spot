import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Text('Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
             const SizedBox(height: 16),
             Container(
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(16),
                 boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                 ],
               ),
               child: Row(
                 children: [
                   Container(
                     width: 52,
                     height: 52,
                     decoration: const BoxDecoration(
                       color: AppColors.primary,
                       shape: BoxShape.circle,
                     ),
                     child: const Icon(LucideIcons.user, color: Colors.white, size: 32),
                   ),
                   const SizedBox(width: 14),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       const Text('Indrakumar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                       const SizedBox(height: 2),
                       Text('+91 98765 43210', style: TextStyle(color: Colors.grey[600])),
                     ],
                   ),
                 ],
               ),
             ),
             const SizedBox(height: 20),
             Container(
               padding: const EdgeInsets.symmetric(vertical: 6),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(16),
                 border: Border.all(color: Colors.grey[100]!),
                 boxShadow: const [
                   BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
                 ],
               ),
               child: Column(
                 children: const [
                   _ProfileItem(icon: LucideIcons.receipt, label: 'My Orders'),
                   Divider(height: 1),
                   _ProfileItem(icon: LucideIcons.mapPin, label: 'Saved Addresses'),
                   Divider(height: 1),
                   _ProfileItem(icon: LucideIcons.helpCircle, label: 'Help & Support'),
                   Divider(height: 1),
                   _ProfileItem(icon: LucideIcons.info, label: 'About MeatBites'),
                 ],
               ),
             ),
             const SizedBox(height: 30),
             Container(
               padding: const EdgeInsets.all(14),
               decoration: BoxDecoration(
                 color: AppColors.primary,
                 borderRadius: BorderRadius.circular(14),
               ),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: const [
                    Icon(LucideIcons.logOut, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                 ],
               ),
             ),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ProfileItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xFF444444)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
            const Icon(LucideIcons.chevronRight, size: 18, color: Color(0xFF999999)),
          ],
        ),
      ),
    );
  }
}
