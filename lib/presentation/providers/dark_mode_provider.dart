

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dark_mode_provider.g.dart';

@riverpod
class DarkMode extends _$DarkMode {
  @override
  bool build() {
    return false;
  }

  void toggleDarkMode() {
    state = !state;
  }

}