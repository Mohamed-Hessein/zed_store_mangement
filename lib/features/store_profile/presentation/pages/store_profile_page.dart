import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/core/resources/app_strings.dart';
import 'package:zed_store_mangent/di.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/bloc/profile_bloc.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/bloc/profile_event.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/bloc/profile_state.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/widgets/account_settings_group.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/widgets/profile_footer.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/widgets/quick_stats_row.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/widgets/store_header_card.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/widgets/store_settings_group.dart';

class StoreProfilePage extends StatelessWidget {
  const StoreProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileBloc>()..add(const FetchStoreProfile()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          title: Text(
        'الحساب الشخصي للمتجر',
            style: AppStyles.text16PurpleBold,
          ),
          centerTitle: false,

          actions: [
           ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (previous, current) =>
          previous.status != current.status ||
              previous.storeProfile != current.storeProfile,
          builder: (context, state) {
            return _buildBody(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    if (state.status == ProfileStatus.loading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryPurple,
        ),
      );
    }

    if (state.status == ProfileStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(AppStrings.errorOccurred, style: AppStyles.text14DarkBold),
            SizedBox(height: 8.h),
            Text(
              state.errorMessage ?? AppStrings.unknownError,
              style: AppStyles.text12DarkMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () => context.read<ProfileBloc>().add(const FetchStoreProfile()),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  AppStrings.retry,
                  style: AppStyles.text13bold.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state.status == ProfileStatus.success && state.storeProfile != null) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StoreHeaderCard(storeProfile: state.storeProfile!),
            SizedBox(height: 16.h),
            QuickStatsRow(storeProfile: state.storeProfile!),
            SizedBox(height: 24.h),
            const StoreSettingsGroup(),
            SizedBox(height: 24.h),
            const AccountSettingsGroup(),
            ProfileFooter(
              onLogoutPressed: () {
                context.read<ProfileBloc>().add(const LogoutPressed());
              },
            ),
          ],
        ),
      );
    }

    return const SizedBox();
  }
}
