import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gameder/constants/app_colors.dart';
import 'package:gameder/app/data/services/locale_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppBackgroundColor,
      appBar: AppBar(
        title: Text('settings_title'.tr),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            const _LanguageTile(),
            const Divider(color: Colors.white24, height: 24),
            _SettingsTile(
              icon: Icons.volume_up_outlined,
              title: 'settings_soundEffects'.tr,
              onTap: () => Get.snackbar(
                'common_comingSoonTitle'.tr,
                'settings_soundNotAvailable'.tr,
              ),
            ),
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'settings_about'.tr,
              onTap: () =>
                  Get.snackbar('Gameder', 'settings_aboutVersion'.tr),
            ),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'settings_privacyPolicy'.tr,
              onTap: () => Get.snackbar(
                'common_comingSoonTitle'.tr,
                'settings_notAvailableYet'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatefulWidget {
  const _LanguageTile();

  @override
  State<_LanguageTile> createState() => _LanguageTileState();
}

class _LanguageTileState extends State<_LanguageTile> {
  @override
  Widget build(BuildContext context) {
    final currentCode = Get.locale?.languageCode ?? 'en';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.language_outlined, color: Colors.white),
              const SizedBox(width: 16),
              Text(
                'settings_language'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _LanguageOption(
                  label: 'settings_languageEnglish'.tr,
                  selected: currentCode == 'en',
                  onTap: () => _changeLocale('en'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LanguageOption(
                  label: 'settings_languageThai'.tr,
                  selected: currentCode == 'th',
                  onTap: () => _changeLocale('th'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _changeLocale(String code) async {
    final locale = LocaleService.supportedLocales[code];
    if (locale == null) return;
    await LocaleService.saveLocale(code);
    Get.updateLocale(locale);
    setState(() {});
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.16) : Colors.transparent,
          border: Border.all(
            color: selected ? Colors.white : Colors.white24,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
      onTap: onTap,
    );
  }
}
