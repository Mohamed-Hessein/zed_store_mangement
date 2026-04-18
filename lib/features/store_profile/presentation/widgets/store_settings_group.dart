import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/core/resources/app_strings.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/bloc/profile_bloc.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/bloc/profile_event.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/widgets/settings_list_tile.dart';

class StoreSettingsGroup extends StatelessWidget {
  const StoreSettingsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'إعدادات المتجر',
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
                icon: Icons.store_outlined,
                title: 'تعديل بيانات المتجر',
                onTap: () => context.read<ProfileBloc>().add(
                  const LaunchZedSection(
                    url: 'https://web.zid.sa/settings/store-settings',
                  ),
                ),
              ),
              Divider(
                height: 1.h,
                color: AppColors.divider,
                indent: 56.w,
                endIndent: 16.w,
              ),
              SettingsListTile(
                icon: Icons.local_shipping_outlined,
                title: 'إعدادات الشحن والتوصيل',
                onTap: () => context.read<ProfileBloc>().add(
                  const LaunchZedSection(
                    url: 'https://web.zid.sa/settings/shipping',
                  ),
                ),
              ),
              Divider(
                height: 1.h,
                color: AppColors.divider,
                indent: 56.w,
                endIndent: 16.w,
              ),
              SettingsListTile(
                icon: Icons.payment_outlined,
                title: 'وسائل الدفع',
                onTap: () => context.read<ProfileBloc>().add(
                  const LaunchZedSection(
                    url: 'https://web.zid.sa/settings/payment',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
