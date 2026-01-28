import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLoaderState {
  final bool loading;

  const AppLoaderState({this.loading = false});

  AppLoaderState copyWith({bool? loading}) {
    return AppLoaderState(
      loading: loading ?? this.loading,
    );
  }
}

final appLoaderProvider =
NotifierProvider<AppLoaderNotifier, AppLoaderState>(
  AppLoaderNotifier.new,
);

class AppLoaderNotifier extends Notifier<AppLoaderState> {
  Timer? _timer;


  @override
  AppLoaderState build() {
    return const AppLoaderState();
  }


  void startLoading({Duration timeout = const Duration(seconds: 100)}) {
    if (state.loading) return;


    state = state.copyWith(loading: true);


    _timer?.cancel();
    _timer = Timer(timeout, () {
      stopLoading();
    });
  }


  void stopLoading() {
    if (!state.loading) return;


    _timer?.cancel();
    _timer = null;
    state = state.copyWith(loading: false);
  }


  @override
  void dispose() {
    _timer?.cancel();
  }
}


class AppLoader extends ConsumerWidget {
  final Widget child;
  const AppLoader({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loaderState = ref.watch(appLoaderProvider);

    return PopScope(
      canPop: !loaderState.loading,
      child: Stack(
        children: [
          child,
          if (loaderState.loading)
            Positioned.fill(
              child: Container(
                color: Colors.white54,
                child: const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(color: Colors.blue),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}