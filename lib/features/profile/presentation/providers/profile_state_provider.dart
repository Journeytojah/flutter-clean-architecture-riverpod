//
import 'package:flutter_project/features/profile/domain/providers/profile_providers.dart';
import 'package:flutter_project/features/profile/presentation/providers/state/profile_notifier.dart';
import 'package:flutter_project/features/profile/presentation/providers/state/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repository)..fetchProducts();
});
