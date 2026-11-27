import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage { vi, en }

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier() : super(AppLanguage.vi);

  void toggleLanguage() {
    state = state == AppLanguage.vi ? AppLanguage.en : AppLanguage.vi;
  }

  void setLanguage(AppLanguage language) {
    state = language;
  }

  bool get isVietnamese => state == AppLanguage.vi;
}

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((ref) {
  return LanguageNotifier();
});

class AppStrings {
  static String tr(String key, AppLanguage lang) {
    final Map<String, Map<String, String>> dict = {
      'app_title': {
        'vi': 'Việt Tộc',
        'en': 'Viet Toc Foundation',
      },
      'app_subtitle': {
        'vi': 'Nhịp Cầu Yêu Thương',
        'en': 'Links of Love',
      },
      'nav_home': {
        'vi': 'Trang Nhà',
        'en': 'Home',
      },
      'nav_activities': {
        'vi': 'Hoạt Động',
        'en': 'Activities',
      },
      'nav_stories': {
        'vi': 'Tâm Tình',
        'en': 'Stories',
      },
      'nav_donate': {
        'vi': 'Đóng Góp',
        'en': 'Donate',
      },
      'hero_title': {
        'vi': 'Nâng Bước Em Đến Trường',
        'en': 'Empowering Highland Children',
      },
      'hero_desc': {
        'vi': 'Chung tay trao học bổng, đem nước sạch và niềm vui đến 32 vùng với hơn 100 buôn làng Tây Nguyên.',
        'en': 'Bringing student bursaries, clean water, and hope across 32 regions with over 100 villages.',
      },
      'giving_tier_title': {
        'vi': 'Chọn Gói Bảo Trợ Nhanh',
        'en': 'Select Giving Tier',
      },
      'tier_60': {
        'vi': '60\$ / Năm',
        'en': '\$60 / Year',
      },
      'tier_60_desc': {
        'vi': 'Bảo trợ 1 em học sinh suốt cả niên khóa',
        'en': 'Sponsor 1 student for a whole school year',
      },
      'tier_100': {
        'vi': '100\$',
        'en': '\$100',
      },
      'tier_100_desc': {
        'vi': 'Góp phần giếng nước sạch & dinh dưỡng',
        'en': 'Contribute to clean water & nutrition',
      },
      'tier_250': {
        'vi': '250\$',
        'en': '\$250',
      },
      'tier_250_desc': {
        'vi': 'Bảo trợ y tế & trường lớp buôn làng',
        'en': 'Support medical relief & village classes',
      },
      'btn_sponsor_now': {
        'vi': 'Bảo Trợ Ngay',
        'en': 'Sponsor Now',
      },
      'latest_news': {
        'vi': 'Tin Buôn Làng Mới Nhất',
        'en': 'Latest Village News',
      },
      'activities_heading': {
        'vi': 'Dự Án & Sinh Hoạt Phục Vụ',
        'en': 'Activities & Relief Projects',
      },
      'stories_heading': {
        'vi': 'Chia Sẻ Tâm Tình & Cảm Nghiệm',
        'en': 'Heartfelt Reflections & Stories',
      },
      'donation_heading': {
        'vi': 'Đóng Góp Trực Tuyến',
        'en': 'Online Giving',
      },
      'donation_tax_exempt': {
        'vi': 'Được miễn trừ thuế theo luật 501(c)(3) Hoa Kỳ (EIN: 52-2253456)',
        'en': 'Tax-deductible under US 501(c)(3) (EIN: 52-2253456)',
      },
      'btn_paypal': {
        'vi': 'Ủng Hộ Trực Tuyến Qua PayPal',
        'en': 'Donate via PayPal',
      },
      'btn_zelle': {
        'vi': 'Sao Chép Số Zelle',
        'en': 'Copy Zelle Number',
      },
      'zelle_copied': {
        'vi': 'Đã sao chép số Zelle 904-476-5761 (Viet Toc Foundation Inc)',
        'en': 'Copied Zelle 904-476-5761 (Viet Toc Foundation Inc)',
      },
      'check_title': {
        'vi': 'Ngân Phiếu (Check / Money Order)',
        'en': 'Check / Money Order',
      },
      'check_payable_to': {
        'vi': 'Đơn vị thụ hưởng:',
        'en': 'Payable to:',
      },
      'check_mailing_address': {
        'vi': 'Địa chỉ nhận thư:',
        'en': 'Mailing address:',
      },
      'memo_label': {
        'vi': 'Ghi chú (Memo):',
        'en': 'Memo:',
      },
      'memo_content': {
        'vi': 'Giúp đồng bào buôn làng Tây Nguyên',
        'en': 'Highland Village Relief',
      },
      'copy_address': {
        'vi': 'Sao Chép Địa Chỉ',
        'en': 'Copy Address',
      },
      'address_copied': {
        'vi': 'Đã sao chép địa chỉ nhận ngân phiếu',
        'en': 'Copied donation mailing address',
      },
      'check_guidance': {
        'vi': 'Gửi ngân phiếu (Check / Money Order) về:\nViet Toc Foundation Inc\nP.O. Box 10061, Silver Spring, MD 20914',
        'en': 'Send check or money order payable to:\nViet Toc Foundation Inc\nP.O. Box 10061, Silver Spring, MD 20914',
      },
      'read_more': {
        'vi': 'Xem chi tiết',
        'en': 'Read more',
      },
      'loading': {
        'vi': 'Đang tải dữ liệu buôn làng...',
        'en': 'Loading village stories...',
      },
      'error': {
        'vi': 'Không thể kết nối máy chủ. Vui lòng thử lại sau.',
        'en': 'Unable to connect to server. Please try again later.',
      },
    };

    final langKey = lang == AppLanguage.vi ? 'vi' : 'en';
    return dict[key]?[langKey] ?? key;
  }
}
