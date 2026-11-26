import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/language_provider.dart';
import '../../posts/controllers/post_controllers.dart';
import '../../posts/presentation/post_detail_screen.dart';

class StoriesScreen extends ConsumerWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final storiesAsync = ref.watch(storiesProvider);

    return Scaffold(
      backgroundColor: ThoCamColors.mist,
      body: RefreshIndicator(
        color: ThoCamColors.pineGreen,
        onRefresh: () async {
          ref.invalidate(storiesProvider);
        },
        child: storiesAsync.when(
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
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final post = posts[index];
                return _buildStoryCard(context, post, lang);
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
                    onPressed: () => ref.invalidate(storiesProvider),
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

  Widget _buildStoryCard(BuildContext context, dynamic post, AppLanguage lang) {
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar hoặc Ảnh đại diện nhỏ bo góc tròn nhẹ
              if (post.featureImageUrl != null && post.featureImageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: post.featureImageUrl,
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 85,
                      height: 85,
                      color: ThoCamColors.sand,
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 85,
                      height: 85,
                      color: ThoCamColors.sand,
                      child: const Center(
                        child: FaIcon(FontAwesomeIcons.heart, size: 22, color: ThoCamColors.terracotta),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    color: ThoCamColors.sand,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: FaIcon(FontAwesomeIcons.handHoldingHeart, size: 26, color: ThoCamColors.terracotta),
                  ),
                ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 15,
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
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.heart, size: 11, color: ThoCamColors.terracotta),
                        const SizedBox(width: 5),
                        Text(
                          post.authorName ?? 'Hội Việt Tộc',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: ThoCamColors.terracotta,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
