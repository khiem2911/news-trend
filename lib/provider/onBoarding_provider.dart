import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(true);

  bool onBoard() {
    state = false;
    return state;
  }
}

final OnBoardProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});
