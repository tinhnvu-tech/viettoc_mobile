import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/language_provider.dart';
import '../../donation/presentation/donation_screen.dart';
import '../controllers/post_controllers.dart';
import '../models/post_model.dart';

enum PostTheme { education, infrastructure, volunteer, general }

class PostDetailScreen extends ConsumerStatefulWidget {
  final PostModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _relatedSectionKey = GlobalKey();
  bool _showBottomBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Tự động kích hoạt thanh menu bar khi người dùng cuộn đến gần cuối bài
    final isNearBottom = (maxScroll - currentScroll <= 320) ||
        (maxScroll > 400 && (currentScroll / maxScroll) >= 0.75);

    if (isNearBottom != _showBottomBar) {
      setState(() {
        _showBottomBar = isNearBottom;
      });
    }
  }

  PostTheme _detectTheme(PostModel post) {
    final text = '${post.title} ${post.excerpt} ${post.slug}'.toLowerCase();
    if (text.contains('học bổng') ||
        text.contains('em đến trường') ||
        text.contains('học sinh') ||
        text.contains('bàn ghế') ||
        text.contains('lớp học') ||
        text.contains('giáo dục') ||
        text.contains('scholarship') ||
        text.contains('school') ||
        text.contains('student') ||
        text.contains('bursar')) {
      return PostTheme.education;
    }
    if (text.contains('nước sạch') ||
        text.contains('giếng') ||
        text.contains('tủ thuốc') ||
        text.contains('y tế') ||
        text.contains('bệnh phong') ||
        text.contains('công trình') ||
        text.contains('water') ||
        text.contains('well') ||
        text.contains('medical') ||
        text.contains('clinic')) {
      return PostTheme.infrastructure;
    }
    if (text.contains('tình nguyện') ||
        text.contains('phục vụ') ||
        text.contains('sinh viên') ||
        text.contains('cộng đồng') ||
        text.contains('volunteer') ||
        text.contains('youth') ||
        text.contains('service')) {
      return PostTheme.volunteer;
    }
    return PostTheme.general;
  }

  void _openDonation(BuildContext context) {
    final lang = ref.read(languageProvider);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              lang == AppLanguage.vi ? 'Ủng Hộ & Đóng Góp' : 'Donate & Support',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 28,
                    height: 28,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          body: const DonationScreen(),
        ),
      ),
    );
  }

  void _scrollToRelatedSection() {
    if (_relatedSectionKey.currentContext != null) {
      Scrollable.ensureVisible(
        _relatedSectionKey.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  String _getShortCtaLabel(PostTheme theme, AppLanguage lang) {
    switch (theme) {
      case PostTheme.education:
        return lang == AppLanguage.vi ? 'Bảo Trợ (\$60/Năm)' : 'Sponsor (\$60/Yr)';
      case PostTheme.infrastructure:
        return lang == AppLanguage.vi ? 'Hỗ Trợ Dự Án' : 'Support Project';
      case PostTheme.volunteer:
        return lang == AppLanguage.vi ? 'Tham Gia Phục Vụ' : 'Join Mission';
      case PostTheme.general:
        return lang == AppLanguage.vi ? 'Ủng Hộ Buôn Làng' : 'Donate Now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final theme = _detectTheme(widget.post);
    final activitiesAsync = ref.watch(activitiesProvider);

    return Scaffold(
      backgroundColor: ThoCamColors.mist,
      appBar: AppBar(
        title: Text(
          widget.post.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/images/logo.png',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Feature Photo
            if (widget.post.featureImageUrl != null && widget.post.featureImageUrl!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: widget.post.featureImageUrl!,
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
                        widget.post.authorName ?? (lang == AppLanguage.vi ? 'Việt Tộc' : 'Viet Toc'),
                        style: const TextStyle(
                          color: ThoCamColors.terracotta,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      if (widget.post.date.isNotEmpty)
                        Text(
                          widget.post.date.split('T').first,
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
                    widget.post.title,
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
                    widget.post.content.isNotEmpty ? widget.post.content : widget.post.excerpt,
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

                  const SizedBox(height: 24),

                  // 1. CTA THEO CHỦ ĐỀ BÀI VIẾT (Contextual Charity CTA Card)
                  _buildThematicCtaCard(context, theme, lang),

                  const SizedBox(height: 20),

                  // 2. KHỐI NÚT ĐIỀU HƯỚNG: TRỞ LẠI & ĐỌC THÊM
                  _buildNavigationActionRow(context, lang),

                  const SizedBox(height: 32),

                  // 3. DANH SÁCH BÀI VIẾT ĐỌC THÊM (Related Village Stories)
                  Container(
                    key: _relatedSectionKey,
                    child: _buildRelatedPostsSection(context, activitiesAsync, lang),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),

      // 4. BOTTOM MENU BAR TỰ ĐỘNG HIỂN THỊ KHI KÉO XUỐNG CUỐI BÀI
      bottomNavigationBar: _buildAnimatedBottomMenuBar(context, theme, lang),
    );
  }

  Widget _buildThematicCtaCard(BuildContext context, PostTheme theme, AppLanguage lang) {
    IconData icon;
    String badge;
    String title;
    String desc;
    String buttonText;

    switch (theme) {
      case PostTheme.education:
        icon = FontAwesomeIcons.bookOpen;
        badge = lang == AppLanguage.vi ? 'Học Bổng Buôn Làng' : 'Highland Bursary Mission';
        title = lang == AppLanguage.vi
            ? 'Tiếp Sức Tri Thức Cho Con Em Vùng Cao'
            : 'Empower Highland Children with Education';
        desc = lang == AppLanguage.vi
            ? 'Chỉ với 60\$/năm (khoảng 5\$/tháng), Quý Ân Nhân đã trao trọn cơ hội đến trường, bữa ăn bán trú và tương lai tươi sáng cho 1 em nhỏ nghèo.'
            : 'With just \$60/year (approx. \$5/month), you provide full school tuition, learning supplies, and nutritious boarding lunches for an underprivileged child.';
        buttonText = lang == AppLanguage.vi ? 'Bảo Trợ Học Sinh (\$60/Năm)' : 'Sponsor a Student (\$60/Yr)';
        break;

      case PostTheme.infrastructure:
        icon = FontAwesomeIcons.droplet;
        badge = lang == AppLanguage.vi ? 'Nước Sạch & Y Tế Buôn Làng' : 'Clean Water & Healthcare';
        title = lang == AppLanguage.vi
            ? 'Chung Tay Mang Nguồn Sống Đến Vùng Xa'
            : 'Bringing Clean Water & Medical Relief';
        desc = lang == AppLanguage.vi
            ? 'Mỗi giếng khoan và tủ thuốc buôn làng là nhịp cầu yêu thương che chở hàng trăm gia đình đồng bào trước bệnh tật và mùa khô hạn khắc nghiệt.'
            : 'Every clean water well and medical cabinet protects hundreds of ethnic families against chronic disease and severe highland droughts.';
        buttonText = lang == AppLanguage.vi ? 'Chung Tay Đóng Góp Dự Án' : 'Support Relief Projects';
        break;

      case PostTheme.volunteer:
        icon = FontAwesomeIcons.handsHoldingChild;
        badge = lang == AppLanguage.vi ? 'Kết Nối Đồng Hành & Tình Nguyện' : 'Volunteer & Partnership';
        title = lang == AppLanguage.vi
            ? 'Chung Tay Phục Vụ Cùng Hội Việt Tộc'
            : 'Join Our Mission of Love and Service';
        desc = lang == AppLanguage.vi
            ? 'Hội Việt Tộc luôn chào đón mọi sự cộng tác bằng lời cầu nguyện, công sức, kỹ năng hay tài chánh từ Quý Ân Nhân và anh chị em thiện nguyện.'
            : 'Viet Toc Foundation warmly welcomes your prayers, volunteer service, skills, and donations across communities.';
        buttonText = lang == AppLanguage.vi ? 'Tham Gia Hoạt Động & Đóng Góp' : 'Join Mission & Support';
        break;

      case PostTheme.general:
        icon = FontAwesomeIcons.shieldHeart;
        badge = lang == AppLanguage.vi ? 'Links of Love • 501(c)(3)' : 'Links of Love • 501(c)(3)';
        title = lang == AppLanguage.vi
            ? 'Nối Dài Nhịp Cầu Yêu Thương Đến Buôn Làng'
            : 'Extending Our Links of Love to Highland Villages';
        desc = lang == AppLanguage.vi
            ? 'Mọi đóng góp đều được miễn trừ thuế theo luật 501(c)(3) Hoa Kỳ (EIN: 52-2253456) và được chuyển trọn vẹn đến tận tay đồng bào buôn làng.'
            : 'All gifts are tax-deductible under US 501(c)(3) (EIN: 52-2253456) and delivered directly to ethnic families in need.';
        buttonText = lang == AppLanguage.vi ? 'Ủng Hộ Buôn Làng Ngay' : 'Donate to Village Relief';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF4ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThoCamColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0x1FB84A27),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FaIcon(icon, color: ThoCamColors.terracotta, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: ThoCamColors.sand,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: ThoCamColors.pineGreen,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: ThoCamColors.roast,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
              color: ThoCamColors.textMuted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openDonation(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThoCamColors.terracotta,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 1,
              ),
              icon: const FaIcon(FontAwesomeIcons.heart, size: 14),
              label: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  buttonText,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationActionRow(BuildContext context, AppLanguage lang) {
    return Row(
      children: [
        // Nút Trở Lại
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: ThoCamColors.pineGreen,
              side: const BorderSide(color: ThoCamColors.pineGreen, width: 1.2),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 13),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                lang == AppLanguage.vi ? 'Trở Lại' : 'Go Back',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Nút Đọc Thêm Bài Khác
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _scrollToRelatedSection,
            style: ElevatedButton.styleFrom(
              backgroundColor: ThoCamColors.pineGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            icon: const FaIcon(FontAwesomeIcons.bookOpen, size: 13),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                lang == AppLanguage.vi ? 'Đọc Thêm' : 'Read More',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedPostsSection(
    BuildContext context,
    AsyncValue<List<PostModel>> activitiesAsync,
    AppLanguage lang,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.newspaper, size: 16, color: ThoCamColors.pineGreen),
            const SizedBox(width: 8),
            Text(
              lang == AppLanguage.vi ? 'Bài Viết Buôn Làng Liên Quan' : 'Related Village Stories',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ThoCamColors.roast,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        activitiesAsync.when(
          data: (posts) {
            final related = posts.where((p) => p.id != widget.post.id).take(3).toList();
            if (related.isEmpty) {
              return Text(
                lang == AppLanguage.vi
                    ? 'Chưa có thêm bài viết liên quan.'
                    : 'No additional related stories yet.',
                style: const TextStyle(fontSize: 13, color: ThoCamColors.textMuted),
              );
            }
            return Column(
              children: related.map((p) => _buildRelatedCard(context, p, lang)).toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: ThoCamColors.pineGreen, strokeWidth: 2),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildRelatedCard(BuildContext context, PostModel post, AppLanguage lang) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThoCamColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(post: post),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              if (post.featureImageUrl != null && post.featureImageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: post.featureImageUrl!,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(width: 70, height: 70, color: ThoCamColors.sand),
                    errorWidget: (context, url, error) => Container(
                      width: 70,
                      height: 70,
                      color: ThoCamColors.sand,
                      child: const Center(
                        child: FaIcon(FontAwesomeIcons.handHoldingHeart, size: 20, color: ThoCamColors.pineGreen),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: ThoCamColors.sand,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: FaIcon(FontAwesomeIcons.handHoldingHeart, size: 22, color: ThoCamColors.pineGreen),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ThoCamColors.roast,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          post.date.split('T').first,
                          style: const TextStyle(fontSize: 11, color: ThoCamColors.textMuted),
                        ),
                        const Spacer(),
                        Text(
                          lang == AppLanguage.vi ? 'Đọc tiếp →' : 'Read →',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
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

  Widget? _buildAnimatedBottomMenuBar(BuildContext context, PostTheme theme, AppLanguage lang) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      height: _showBottomBar ? 68 : 0,
      child: _showBottomBar
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    offset: Offset(0, -3),
                    blurRadius: 10,
                  ),
                ],
                border: const Border(top: BorderSide(color: ThoCamColors.border)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Nút Trở Lại
                    Material(
                      color: ThoCamColors.sand,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.arrowLeft, size: 14, color: ThoCamColors.roast),
                              const SizedBox(width: 6),
                              Text(
                                lang == AppLanguage.vi ? 'Trở Lại' : 'Back',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: ThoCamColors.roast,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Nút CTA Kêu Gọi Nhanh
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openDonation(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThoCamColors.terracotta,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 1,
                        ),
                        icon: const FaIcon(FontAwesomeIcons.heart, size: 13),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _getShortCtaLabel(theme, lang),
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Nút Đọc Thêm / Lên đầu trang
                    Material(
                      color: ThoCamColors.sand,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: FaIcon(FontAwesomeIcons.arrowUp, size: 14, color: ThoCamColors.pineGreen),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
