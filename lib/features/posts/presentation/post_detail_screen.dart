import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../models/post_model.dart';

class PostDetailScreen extends StatelessWidget {
  final PostModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThoCamColors.mist,
      appBar: AppBar(
        title: Text(
          post.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Feature Photo
            if (post.featureImageUrl != null && post.featureImageUrl!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: post.featureImageUrl!,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 240,
                  color: ThoCamColors.sand,
                  child: const Center(
                    child: CircularProgressIndicator(color: ThoCamColors.pineGreen),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 240,
                  color: ThoCamColors.sand,
                  child: const Center(
                    child: FaIcon(FontAwesomeIcons.handHoldingHeart, size: 48, color: ThoCamColors.terracotta),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta info: Date & Author
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.handHoldingHeart, size: 14, color: ThoCamColors.terracotta),
                      const SizedBox(width: 8),
                      Text(
                        post.authorName ?? 'Hội Việt Tộc',
                        style: const TextStyle(
                          color: ThoCamColors.terracotta,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      if (post.date.isNotEmpty)
                        Text(
                          post.date.split('T').first,
                          style: const TextStyle(
                            color: ThoCamColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Title
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: ThoCamColors.roast,
                      height: 1.3,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: ThoCamColors.border, height: 1),
                  ),

                  // Content HTML
                  HtmlWidget(
                    post.content.isNotEmpty ? post.content : post.excerpt,
                    textStyle: const TextStyle(
                      fontSize: 15.0,
                      height: 1.6,
                      color: ThoCamColors.roast,
                    ),
                    customStylesBuilder: (element) {
                      if (element.localName == 'p') {
                        return {'text-align': 'justify', 'margin-bottom': '14px'};
                      }
                      if (element.localName == 'a') {
                        return {'color': '#B84A27', 'text-decoration': 'none'};
                      }
                      return null;
                    },
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
