import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:healthandwellness/features/test/repository/counter_provider.dart';

class CountUi extends ConsumerWidget {
  const CountUi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    return Scaffold(
      body: Column(
        children: [
          Text(counter.count.toString()),
          ElevatedButton(
            onPressed: () {
              ref.read(counterProvider.notifier).increment();
            },
            child: Text("Increment"),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(counterProvider.notifier).decrement();
            },
            child: Text("Decrement"),
          ),
        ],
      ),
    );
  }
}
