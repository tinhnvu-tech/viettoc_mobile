import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'core/theme/app_colors.dart';
import 'core/providers/language_provider.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/activities/presentation/activities_screen.dart';
import 'features/stories/presentation/stories_screen.dart';
import 'features/donation/presentation/donation_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  void _navigateToDonation() {
    setState(() {
      _currentIndex = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    final screens = [
      HomeScreen(onNavigateToDonation: _navigateToDonation),
      const ActivitiesScreen(),
      const StoriesScreen(),
      const DonationScreen(),
    ];

    final titles = [
      AppStrings.tr('app_title', lang),
      AppStrings.tr('nav_activities', lang),
      AppStrings.tr('nav_stories', lang),
      AppStrings.tr('nav_donate', lang),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 32,
                  height: 32,
                  color: Colors.white,
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.handHoldingHeart,
                      color: ThoCamColors.pineGreen,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titles[_currentIndex],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  AppStrings.tr('app_subtitle', lang),
                  style: const TextStyle(
                    fontSize: 11,
                    color: ThoCamColors.sand,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Nút chuyển đổi ngôn ngữ (VI ⇄ EN)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton.icon(
              onPressed: () {
                ref.read(languageProvider.notifier).toggleLanguage();
              },
              style: TextButton.styleFrom(
                backgroundColor: ThoCamColors.terracotta,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              icon: const FaIcon(FontAwesomeIcons.globe, size: 12, color: Colors.white),
              label: Text(
                lang == AppLanguage.vi ? 'EN' : 'VI',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.house, size: 18),
            label: AppStrings.tr('nav_home', lang),
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.handHoldingHeart, size: 18),
            label: AppStrings.tr('nav_activities', lang),
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.bookOpen, size: 18),
            label: AppStrings.tr('nav_stories', lang),
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.shieldHeart, size: 18),
            label: AppStrings.tr('nav_donate', lang),
          ),
        ],
      ),
    );
  }
}
