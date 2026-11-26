class PostModel {
  final int id;
  final String date;
  final String slug;
  final String title;
  final String excerpt;
  final String content;
  final String? featureImageUrl;
  final String? authorName;

  PostModel({
    required this.id,
    required this.date,
    required this.slug,
    required this.title,
    required this.excerpt,
    required this.content,
    this.featureImageUrl,
    this.authorName,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    String cleanTitle = '';
    if (json['title'] != null && json['title']['rendered'] != null) {
      cleanTitle = _cleanHtml(json['title']['rendered'].toString());
    }

    String cleanExcerpt = '';
    if (json['excerpt'] != null && json['excerpt']['rendered'] != null) {
      cleanExcerpt = _cleanHtml(json['excerpt']['rendered'].toString());
    }

    String rawContent = '';
    if (json['content'] != null && json['content']['rendered'] != null) {
      rawContent = json['content']['rendered'].toString();
    }

    // Trích xuất feature image từ _embedded['wp:featuredmedia']
    String? imageUrl;
    try {
      if (json['_embedded'] != null &&
          json['_embedded']['wp:featuredmedia'] != null &&
          (json['_embedded']['wp:featuredmedia'] as List).isNotEmpty) {
        imageUrl = json['_embedded']['wp:featuredmedia'][0]['source_url'] as String?;
      }
    } catch (_) {
      imageUrl = null;
    }

    // Trích xuất tác giả từ _embedded['author']
    String? author;
    try {
      if (json['_embedded'] != null &&
          json['_embedded']['author'] != null &&
          (json['_embedded']['author'] as List).isNotEmpty) {
        author = json['_embedded']['author'][0]['name'] as String?;
      }
    } catch (_) {
      author = null;
    }

    return PostModel(
      id: json['id'] as int? ?? 0,
      date: json['date'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      title: cleanTitle,
      excerpt: cleanExcerpt,
      content: rawContent,
      featureImageUrl: imageUrl,
      authorName: author ?? 'Hội Việt Tộc',
    );
  }

  static String _cleanHtml(String htmlString) {
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&#8211;', '-')
        .replaceAll('&#8212;', '--')
        .replaceAll('&#8216;', "'")
        .replaceAll('&#8217;', "'")
        .replaceAll('&#8220;', '"')
        .replaceAll('&#8221;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .trim();
  }
}
