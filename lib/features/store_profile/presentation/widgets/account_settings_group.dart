import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/core/resources/app_strings.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/widgets/settings_list_tile.dart';

class AccountSettingsGroup extends StatelessWidget {
  const AccountSettingsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'الحساب والربط التقني',
            style: AppStyles.text14DarkBold.copyWith(fontSize: 16.sp),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              SettingsListTile(
                icon: Icons.person_outlined,
                title: AppStrings.personalInfo,
                onTap: () {},
              ),
              _buildDivider(),
              SettingsListTile(
                icon: Icons.notifications_none_outlined,
                title: AppStrings.notifications,
                onTap: () {},
              ),
              _buildDivider(),
              SettingsListTile(
                icon: Icons.lock_outline,
                title: AppStrings.security,
                onTap: () {},
              ),
              _buildDivider(),
              SettingsListTile(
                icon: Icons.api_rounded,
                title: 'إعدادات مفتاح الـ API',
                onTap: () {
                  _showApiKeyDialog(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      color: AppColors.divider,
      indent: 56.w,
      endIndent: 16.w,
    );
  }

  void _showApiKeyDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مفتاح API المتجر'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('أدخل مفتاح الـ API الخاص بمتجرك لمزامنة الطلبات والبيانات.'),
            SizedBox(height: 16.h),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'قم بلصق المفتاح هنا...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('حفظ المفتاح', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
