import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zed_store_mangent/features/store_profile/domain/usecase/get_store_profile_usecase.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/bloc/profile_event.dart';
import 'package:zed_store_mangent/features/store_profile/presentation/bloc/profile_state.dart';

import '../../../../core/api/prefs_helper.dart';
import '../../../../core/resources/internet_checker.dart';
import '../../../../di.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetStoreProfileUseCase getStoreProfileUseCase;

  ProfileBloc(this.getStoreProfileUseCase) : super(const ProfileState()) {
    on<FetchStoreProfile>(_onFetchStoreProfile);
    on<LaunchZedSection>(_onLaunchZedSection);
    on<LogoutPressed>((event, emit) async {
      // 1. مسح البيانات
      await getIt<PrefsHelper>().clearData();

      // 2. إرسال حالة النجاح أو الخروج (حسب الـ States اللي عندك)
      emit(state.copyWith(status: ProfileStatus.success,storeProfile: null));
    });
  }

  Future<void> _onFetchStoreProfile(
      FetchStoreProfile event,
      Emitter<ProfileState> emit,
      ) async {

    emit(state.copyWith(status: ProfileStatus.loading));

    final isConnected = getIt<InternetConnectivity>().isConnected;

    if (!isConnected) {
      if (state.storeProfile != null) {
        emit(state.copyWith(status: ProfileStatus.success));
      } else {
        emit(state.copyWith(
            status: ProfileStatus.error,
            errorMessage: "لا يتوفر اتصال بالإنترنت حالياً"
        ));
      }
      return;
    }

    final result = await getStoreProfileUseCase.call();

    result.fold(
          (failure) => emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      )),
          (storeProfile) => emit(state.copyWith(
        status: ProfileStatus.success,
        storeProfile: storeProfile,
      )),
    );
  }

  Future<void> _onLaunchZedSection(
    LaunchZedSection event,
    Emitter<ProfileState> emit,
  ) async {
    final Uri url = Uri.parse(event.url);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Could not open URL',
      ));
    }
  }
}


