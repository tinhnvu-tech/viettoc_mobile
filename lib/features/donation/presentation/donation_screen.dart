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

  void _copyAddress(BuildContext context, AppLanguage lang) {
    Clipboard.setData(const ClipboardData(
      text: "Viet Toc Foundation Inc\nP.O. Box 10061, Silver Spring, MD 20914",
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.tr('address_copied', lang)),
        backgroundColor: ThoCamColors.pineGreen,
        duration: const Duration(seconds: 3),
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
            Row(
              children: [
                Text(
                  lang == AppLanguage.vi ? 'Email tài khoản: ' : 'Account email: ',
                  style: const TextStyle(
                    fontSize: 13,
                    color: ThoCamColors.roast,
                  ),
                ),
                const Text(
                  ApiConstants.paypalEmail,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: ThoCamColors.pineGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              lang == AppLanguage.vi
                  ? 'Hỗ trợ thẻ tín dụng Visa, MasterCard, Discover, Amex toàn cầu.'
                  : 'Supports Visa, MasterCard, Discover, Amex cards worldwide.',
              style: const TextStyle(
                fontSize: 12,
                color: ThoCamColors.textMuted,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _launchPayPal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003087),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.arrowUpRightFromSquare, size: 14),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.tr('btn_paypal', lang),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
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
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.mobileScreenButton, color: Color(0xFF7414CA), size: 24),
                const SizedBox(width: 12),
                Text(
                  lang == AppLanguage.vi ? 'Zelle (Chuyển khoản nhanh)' : 'Zelle (Quick Transfer)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7414CA),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ThoCamColors.sand,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    ApiConstants.zellePhone,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: ThoCamColors.pineGreen,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: ThoCamColors.border),
                    ),
                    child: Text(
                      lang == AppLanguage.vi
                          ? 'Tên tài khoản: ${ApiConstants.zelleAccountName}'
                          : 'Account name: ${ApiConstants.zelleAccountName}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: ThoCamColors.roast,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              lang == AppLanguage.vi
                  ? 'Miễn phí chuyển khoản từ hầu hết các ngân hàng tại Hoa Kỳ (Chase, BoA, Wells Fargo, Citi...).'
                  : 'No transfer fees from most US banking apps (Chase, BoA, Wells Fargo, Citi...).',
              style: const TextStyle(fontSize: 12, color: ThoCamColors.textMuted),
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
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.envelopeOpenText, color: ThoCamColors.terracotta, size: 22),
                const SizedBox(width: 12),
                Text(
                  AppStrings.tr('check_title', lang),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: ThoCamColors.roast,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ThoCamColors.sand,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tr('check_payable_to', lang),
                    style: const TextStyle(
                      fontSize: 12,
                      color: ThoCamColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: ThoCamColors.border),
                    ),
                    child: const Text(
                      'Viet Toc Foundation Inc',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: ThoCamColors.pineGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.tr('check_mailing_address', lang),
                    style: const TextStyle(
                      fontSize: 12,
                      color: ThoCamColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: ThoCamColors.border),
                    ),
                    child: const Text(
                      'P.O. Box 10061, Silver Spring, MD 20914',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: ThoCamColors.roast,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  AppStrings.tr('memo_label', lang),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ThoCamColors.roast,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    AppStrings.tr('memo_content', lang),
                    style: const TextStyle(
                      fontSize: 12,
                      color: ThoCamColors.terracotta,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _copyAddress(context, lang),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ThoCamColors.pineGreen,
                  side: const BorderSide(color: ThoCamColors.pineGreen),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.copy, size: 13),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.tr('copy_address', lang),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang == AppLanguage.vi
                ? ApiConstants.organizationNameVi
                : '${ApiConstants.organizationNameEn} – Links of Love',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: ThoCamColors.roast,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            lang == AppLanguage.vi
                ? 'Linh hướng & Sáng lập: ${ApiConstants.founderVi}'
                : 'Founder & Spiritual Director: ${ApiConstants.founderEn}',
            style: const TextStyle(fontSize: 12, color: ThoCamColors.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            lang == AppLanguage.vi
                ? 'Trụ sở: ${ApiConstants.usAddressAnnapolis}'
                : 'Headquarters: ${ApiConstants.usAddressAnnapolis}',
            style: const TextStyle(fontSize: 12, color: ThoCamColors.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            'Điện thoại / Tel: ${ApiConstants.phone}',
            style: const TextStyle(fontSize: 12, color: ThoCamColors.textMuted),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Text(
                'Email: ',
                style: TextStyle(fontSize: 12, color: ThoCamColors.textMuted),
              ),
              Text(
                ApiConstants.paypalEmail,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: ThoCamColors.pineGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
