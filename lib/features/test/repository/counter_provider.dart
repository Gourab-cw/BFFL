import 'package:healthandwellness/features/test/data/counter.dart';
import 'package:riverpod/riverpod.dart';

final counterProvider = NotifierProvider<CounterProvider, CounterModel>(() => CounterProvider());

class CounterProvider extends Notifier<CounterModel> {
  @override
  CounterModel build() {
    return CounterModel(count: 0);
  }

  void increment() {
    state = CounterModel(count: state.count + 1);
  }

  void decrement() {
    state = CounterModel(count: state.count - 1);
  }
}
