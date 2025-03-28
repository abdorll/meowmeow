import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thaipan_test/src/auth/data/auth_repository.dart';

class ResendOtpController extends StateNotifier<AsyncValue> {
  ResendOtpController(this.ref) : super(AsyncValue.data(null));
  Ref ref;
  Future<void> resendOtp({required String phone}) async {
    state = AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).resendOtp(phone: phone);
      state = AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final resendOtpControllerProvider =
    StateNotifierProvider<ResendOtpController, AsyncValue>(
      (ref) => ResendOtpController(ref),
    );

class VerifyOtpController extends StateNotifier<AsyncValue> {
  VerifyOtpController(this.ref) : super(AsyncValue.data(null));
  Ref ref;
  Future<void> verifyOtp({required String phone, required String otp}) async {
    state = AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).verifyOtp(phone: phone, otp: otp);
      state = AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void restoreState(AsyncValue value) {
    state = value;
  }
}

final verifyOtpControllerProvider =
    StateNotifierProvider<VerifyOtpController, AsyncValue>(
      (ref) => VerifyOtpController(ref),
    );
