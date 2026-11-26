import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/language_provider.dart';
import '../../posts/controllers/post_controllers.dart';
import '../../posts/presentation/post_detail_screen.dart';

class ActivitiesScreen extends ConsumerWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final activitiesAsync = ref.watch(activitiesProvider);

    return Scaffold(
      backgroundColor: ThoCamColors.mist,
      body: RefreshIndicator(
        color: ThoCamColors.pineGreen,
        onRefresh: () async {
          ref.invalidate(activitiesProvider);
        },
        child: activitiesAsync.when(
          data: (posts) {
            if (posts.isEmpty) {
              return Center(
                child: Text(
                  AppStrings.tr('loading', lang),
                  style: const TextStyle(color: ThoCamColors.textMuted),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final post = posts[index];
                return _buildActivityCard(context, post, lang);
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: ThoCamColors.pineGreen),
          ),
          error: (err, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(FontAwesomeIcons.circleExclamation, size: 36, color: ThoCamColors.terracotta),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.tr('error', lang),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: ThoCamColors.roast),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(activitiesProvider),
                    child: const Text('Thử lại / Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, dynamic post, AppLanguage lang) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Feature Photo lớn (tỷ lệ 16:9)
            if (post.featureImageUrl != null && post.featureImageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: post.featureImageUrl,
                height: 190,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 190,
                  color: ThoCamColors.sand,
                  child: const Center(
                    child: CircularProgressIndicator(color: ThoCamColors.pineGreen),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 190,
                  color: ThoCamColors.sand,
                  child: const Center(
                    child: FaIcon(FontAwesomeIcons.droplet, size: 40, color: ThoCamColors.pineGreen),
                  ),
                ),
              )
            else
              Container(
                height: 160,
                color: ThoCamColors.sand,
                child: const Center(
                  child: FaIcon(FontAwesomeIcons.handHoldingHeart, size: 40, color: ThoCamColors.pineGreen),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: ThoCamColors.sand,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          post.authorName ?? 'Hội Việt Tộc',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: ThoCamColors.pineGreen,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (post.date.isNotEmpty)
                        Text(
                          post.date.split('T').first,
                          style: const TextStyle(
                            fontSize: 12,
                            color: ThoCamColors.textMuted,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: ThoCamColors.roast,
                      height: 1.3,
                    ),
                  ),
                  if (post.excerpt.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      post.excerpt,
                      style: const TextStyle(
                        fontSize: 13,
                        color: ThoCamColors.textMuted,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        AppStrings.tr('read_more', lang),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: ThoCamColors.terracotta,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const FaIcon(
                        FontAwesomeIcons.arrowRight,
                        size: 11,
                        color: ThoCamColors.terracotta,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
