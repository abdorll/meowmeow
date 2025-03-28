import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thaipan_test/src/auth/data/auth_repository.dart';

class SignupController extends StateNotifier<AsyncValue> {
  SignupController(this.ref) : super(AsyncValue.data(null));
  Ref ref;
  Future<void> signup({required String phone, required String password}) async {
    state = AsyncLoading();
    try {
      await ref
          .read(authRepositoryProvider)
          .signup(phone: phone, password: password);
      state = AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final signupControllerProvider =
    StateNotifierProvider<SignupController, AsyncValue>(
      (ref) => SignupController(ref),
    );
