import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:meatbites_flutter/screens/about_screen.dart';
import 'package:meatbites_flutter/screens/help_screen.dart';
import 'package:meatbites_flutter/screens/order_screen.dart';
import 'package:meatbites_flutter/screens/saved_address_screen.dart';
import '../constants/colors.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);
    final userProfileAsync = ref.watch(userProfileProvider);

    final currentUser = authStateAsync.asData?.value;
    final userModel = userProfileAsync.asData?.value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Profile',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),

            // Auth State Banner
            if (currentUser != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2))
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.user,
                          color: Colors.white, size: 36),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  userModel?.displayName ??
                                      currentUser.displayName ??
                                      'MeatBites User',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (userModel != null) {
                                    context.push('/edit-profile',
                                        extra: userModel);
                                  } else {
                                    // Fallback if model isn't loaded but auth is (rare)
                                    // Create a temporary model from auth data
                                    // But best to wait for model.
                                  }
                                },
                                icon: const Icon(LucideIcons.edit3,
                                    size: 20, color: AppColors.primary),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (userModel?.phoneNumber.isNotEmpty == true)
                            Text(userModel!.phoneNumber,
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                          Text(currentUser.email ?? '',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13)),
                          if (userModel?.address.isNotEmpty == true)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(userModel!.address,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12)),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.1))),
                child: Column(
                  children: [
                    const Text("You are not logged in",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => context.push('/login'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white),
                            child: const Text("Login"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.push('/signup'),
                            style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side:
                                    const BorderSide(color: AppColors.primary)),
                            child: const Text("Sign Up"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

            // ... (rest of the menu)
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[100]!),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1))
                ],
              ),
              child: const Column(
                children: [
                  _ProfileItem(
                      icon: LucideIcons.receipt,
                      label: 'My Orders',
                      destination: OrderScreen()),
                  Divider(height: 1),
                  _ProfileItem(
                      icon: LucideIcons.mapPin,
                      label: 'Saved Addresses',
                      destination: SavedAddressScreen()),
                  Divider(height: 1),
                  _ProfileItem(
                      icon: LucideIcons.helpCircle,
                      label: 'Help & Support',
                      destination: HelpScreen()),
                  Divider(height: 1),
                  _ProfileItem(
                      icon: LucideIcons.info,
                      label: 'About MeatBites',
                      destination: AboutScreen()),
                ],
              ),
            ),
            if (currentUser != null) ...[
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  ref.read(authServiceProvider).signOut(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.logOut, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text('Logout',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
// ... (rest remains same)
  final IconData icon;
  final String label;
  // Optionally, add a destination widget for navigation
  final Widget? destination;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: destination != null
          ? () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => destination!));
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xFF444444)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
            ),
            const Icon(LucideIcons.chevronRight,
                size: 18, color: Color(0xFF999999)),
          ],
        ),
      ),
    );
  }
}
