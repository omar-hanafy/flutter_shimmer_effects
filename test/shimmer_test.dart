import 'package:flutter/material.dart';
import 'package:flutter_shimmer_effects/flutter_shimmer_effects.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Shimmer.fromColors() can be constructed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      Shimmer.fromColors(
        child: Container(width: 100.0, height: 100.0),
        baseColor: Colors.red,
        highlightColor: Colors.yellow,
      ),
    );
  });
}
