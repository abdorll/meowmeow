import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thaipan_test/src/auth/data/auth_repository.dart';

class SigninController extends StateNotifier<AsyncValue> {
  SigninController(this.ref) : super(AsyncValue.data(null));
  Ref ref;
  Future<void> signup({required String phone, required String password}) async {
    state = AsyncLoading();
    try {
      await ref
          .read(authRepositoryProvider)
          .signin(phone: phone, password: password);
      state = AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final signinControllerProvider =
    StateNotifierProvider<SigninController, AsyncValue>(
      (ref) => SigninController(ref),
    );
