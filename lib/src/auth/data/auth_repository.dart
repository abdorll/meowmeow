import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thaipan_test/src/infra/supabase_provider.dart';
import 'package:thaipan_test/src/services/auth_service.dart';
import 'package:thaipan_test/src/util/app_exception.dart';

abstract class AuthRepository {
  Future<void> signup({required String phone, required String password});

  Future<void> signin({required String phone, required String password});

  Future<void> logout();

  Future<void> deleteAccount({required Ref ref});
}

final authRepositoryProvider = Provider<SupabaseAuthRepository>((ref) {
  final supabase = ref.read(supabaseProvider());
  return SupabaseAuthRepository(supabase, ref);
});

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient supabase;
  final Ref ref;
  SupabaseAuthRepository(this.supabase, this.ref);
  @override
  Future<void> signin({required String phone, required String password}) async {
    try {
      await AuthService.service(
        ref,
        authFunction: supabase.auth.signInWithPassword(
          phone: phone,
          password: password,
        ),
      );
    } catch (e, _) {
      rethrow;
    }
  }

  @override
  Future<void> signup({required String phone, required String password}) async {
    try {
      await AuthService.service(
        ref,
        authFunction: supabase.auth.signUp(
          phone: phone,
          password: password,
          channel: OtpChannel.sms,
        ),
      );
    } catch (e, _) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } on AuthApiException catch (e) {
      throw AppException(message: e.message, statusCode: e.statusCode!);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<void> deleteAccount({required Ref ref}) async {
    try {
      await ref
          .read(supabaseProvider(allowAdmin: true))
          .auth
          .admin
          .deleteUser(ref.read(userSessionProvider).user!.id);

      ///[exception will be thrown if {id} is null]
    } on AuthException catch (e) {
      throw AppException(message: e.message, statusCode: e.statusCode!);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  Future<void> resendOtp({required String phone}) async {
    try {
      await supabase.auth.resend(type: OtpType.sms, phone: phone);
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } on AuthApiException catch (e) {
      throw AppException(message: e.message, statusCode: e.statusCode!);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  Future<void> verifyOtp({required String phone, required String otp}) async {
    try {
      await AuthService.service(
        ref,
        authFunction: supabase.auth.verifyOTP(
          type: OtpType.sms,
          token: otp,
          phone: phone,
        ),
      );
    } catch (e, _) {
      rethrow;
    }
  }
}
