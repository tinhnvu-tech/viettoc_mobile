import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/providers/language_provider.dart';

class DonationScreen extends ConsumerWidget {
  const DonationScreen({super.key});

  Future<void> _launchPayPal() async {
    final uri = Uri.parse(
      'https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=tcvnam%40viettoc.org&item_name=Hoi+Viet+Toc+Highland+Relief&currency_code=USD',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Không thể mở ứng dụng PayPal');
    }
  }

  void _copyZelle(BuildContext context, AppLanguage lang) {
    Clipboard.setData(const ClipboardData(text: '9044765761'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.tr('zelle_copied', lang)),
        backgroundColor: ThoCamColors.pineGreen,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _copyAddress(BuildContext context) {
    Clipboard.setData(const ClipboardData(
      text: "VIET TOC FOUNDATION INC\nP.O. Box 10061, Silver Spring, MD 20914",
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép địa chỉ nhận ngân phiếu / Copied address'),
        backgroundColor: ThoCamColors.pineGreen,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: ThoCamColors.mist,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. BANNER PHÁP NHÂN & MIỄN TRỪ THUẾ
            _buildTaxBanner(context, lang),

            const SizedBox(height: 18),

            // 2. KÊNH 1: PAYPAL TRỰC TUYẾN
            _buildPayPalCard(context, lang),

            const SizedBox(height: 16),

            // 3. KÊNH 2: CHUYỂN KHOẢN ZELLE (1 CHẠM SAO CHÉP)
            _buildZelleCard(context, lang),

            const SizedBox(height: 16),

            // 4. KÊNH 3: GỬI NGÂN PHIẾU (CHECK / MONEY ORDER)
            _buildCheckCard(context, lang),

            const SizedBox(height: 16),

            // 5. THÔNG TIN TRỤ SỞ & LIÊN LẠC
            _buildContactInfo(context, lang),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxBanner(BuildContext context, AppLanguage lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF4ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ThoCamColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.shieldHeart, color: ThoCamColors.terracotta, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppStrings.tr('donation_heading', lang),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: ThoCamColors.roast,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.tr('donation_tax_exempt', lang),
            style: const TextStyle(
              fontSize: 13,
              color: ThoCamColors.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayPalCard(BuildContext context, AppLanguage lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                FaIcon(FontAwesomeIcons.paypal, color: Color(0xFF003087), size: 26),
                SizedBox(width: 12),
                Text(
                  'PayPal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF003087),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Tài khoản thụ hưởng: ${ApiConstants.paypalEmail}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ThoCamColors.roast,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Hỗ trợ thẻ tín dụng Visa, MasterCard, Discover, Amex toàn cầu.',
              style: TextStyle(
                fontSize: 12,
                color: ThoCamColors.textMuted,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _launchPayPal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003087),
                ),
                icon: const FaIcon(FontAwesomeIcons.arrowUpRightFromSquare, size: 14),
                label: Text(AppStrings.tr('btn_paypal', lang)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZelleCard(BuildContext context, AppLanguage lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                FaIcon(FontAwesomeIcons.mobileScreenButton, color: Color(0xFF7414CA), size: 24),
                SizedBox(width: 12),
                Text(
                  'Zelle (Chuyển khoản nhanh)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7414CA),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: ThoCamColors.sand,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Text(
                    ApiConstants.zellePhone,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: ThoCamColors.pineGreen,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Spacer(),
                  Text(
                    ApiConstants.zelleAccountName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: ThoCamColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Miễn phí chuyển khoản từ hầu hết các ngân hàng tại Hoa Kỳ (Chase, BoA, Wells Fargo, Citi...).',
              style: TextStyle(fontSize: 12, color: ThoCamColors.textMuted),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _copyZelle(context, lang),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThoCamColors.pineGreen,
                ),
                icon: const FaIcon(FontAwesomeIcons.copy, size: 14),
                label: Text(AppStrings.tr('btn_zelle', lang)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckCard(BuildContext context, AppLanguage lang) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                FaIcon(FontAwesomeIcons.envelopeOpenText, color: ThoCamColors.terracotta, size: 22),
                SizedBox(width: 12),
                Text(
                  'Ngân Phiếu (Check / Money Order)',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: ThoCamColors.roast,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              AppStrings.tr('check_guidance', lang),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ThoCamColors.roast,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Ghi chú (Memo): Giúp đồng bào buôn làng Tây Nguyên',
              style: TextStyle(fontSize: 12, color: ThoCamColors.terracotta, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _copyAddress(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: ThoCamColors.pineGreen,
                side: const BorderSide(color: ThoCamColors.pineGreen),
              ),
              icon: const FaIcon(FontAwesomeIcons.copy, size: 13),
              label: const Text('Sao chép địa chỉ / Copy Address'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, AppLanguage lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThoCamColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ApiConstants.organizationNameVi,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: ThoCamColors.roast,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Linh hướng & Sáng lập: ${ApiConstants.founderVi}',
            style: TextStyle(fontSize: 12, color: ThoCamColors.textMuted),
          ),
          SizedBox(height: 4),
          Text(
            'Địa chỉ: ${ApiConstants.usAddressAnnapolis}',
            style: TextStyle(fontSize: 12, color: ThoCamColors.textMuted),
          ),
          SizedBox(height: 4),
          Text(
            'Điện thoại: ${ApiConstants.phone} | Email: ${ApiConstants.paypalEmail}',
            style: TextStyle(fontSize: 12, color: ThoCamColors.textMuted),
          ),
        ],
      ),
    );
  }
}
