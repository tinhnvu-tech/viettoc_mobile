import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/language_provider.dart';
import '../../posts/controllers/post_controllers.dart';
import '../../posts/presentation/post_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback onNavigateToDonation;

  const HomeScreen({super.key, required this.onNavigateToDonation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final newsAsync = ref.watch(latestNewsProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. HERO BANNER
          _buildHeroBanner(context, lang),

          // 2. GÓI BẢO TRỢ NHANH ($60/NĂM)
          _buildGivingTierSection(context, lang),

          // 3. TIN BUÔN LÀNG MỚI NHẤT
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.handHoldingHeart, color: ThoCamColors.terracotta, size: 18),
                const SizedBox(width: 8),
                Text(
                  AppStrings.tr('latest_news', lang),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: ThoCamColors.roast,
                  ),
                ),
              ],
            ),
          ),

          newsAsync.when(
            data: (posts) {
              if (posts.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      AppStrings.tr('loading', lang),
                      style: const TextStyle(color: ThoCamColors.textMuted),
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: posts.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return _buildNewsCard(context, post, lang);
                },
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(color: ThoCamColors.pineGreen),
              ),
            ),
            error: (err, stack) => Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  AppStrings.tr('error', lang),
                  style: const TextStyle(color: ThoCamColors.terracotta),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context, AppLanguage lang) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ThoCamColors.pineGreen,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: ThoCamColors.terracotta,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '501(c)(3) EIN: 52-2253456',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.tr('hero_title', lang),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.tr('hero_desc', lang),
            style: const TextStyle(
              fontSize: 14,
              color: ThoCamColors.sand,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGivingTierSection(BuildContext context, AppLanguage lang) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tr('giving_tier_title', lang),
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: ThoCamColors.roast,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTierCard(
                  amount: AppStrings.tr('tier_60', lang),
                  desc: AppStrings.tr('tier_60_desc', lang),
                  isHighlight: true,
                  onTap: onNavigateToDonation,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTierCard(
                  amount: AppStrings.tr('tier_100', lang),
                  desc: AppStrings.tr('tier_100_desc', lang),
                  isHighlight: false,
                  onTap: onNavigateToDonation,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTierCard({
    required String amount,
    required String desc,
    required bool isHighlight,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isHighlight ? const Color(0xFFFBF4ED) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlight ? ThoCamColors.terracotta : ThoCamColors.border,
            width: isHighlight ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.handHoldingHeart,
                  size: 15,
                  color: isHighlight ? ThoCamColors.terracotta : ThoCamColors.pineGreen,
                ),
                const SizedBox(width: 6),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isHighlight ? ThoCamColors.terracotta : ThoCamColors.pineGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              desc,
              style: const TextStyle(
                fontSize: 12,
                color: ThoCamColors.textMuted,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, dynamic post, AppLanguage lang) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: ThoCamColors.border),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(post: post),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.featureImageUrl != null && post.featureImageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: post.featureImageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 100,
                  height: 100,
                  color: ThoCamColors.sand,
                ),
                errorWidget: (context, url, error) => Container(
                  width: 100,
                  height: 100,
                  color: ThoCamColors.sand,
                  child: const Center(
                    child: FaIcon(FontAwesomeIcons.heart, size: 24, color: ThoCamColors.terracotta),
                  ),
                ),
              )
            else
              Container(
                width: 100,
                height: 100,
                color: ThoCamColors.sand,
                child: const Center(
                  child: FaIcon(FontAwesomeIcons.handHoldingHeart, size: 28, color: ThoCamColors.pineGreen),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ThoCamColors.roast,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      post.excerpt,
                      style: const TextStyle(
                        fontSize: 12,
                        color: ThoCamColors.textMuted,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
