import 'package:flutter/material.dart';
import 'package:flutter_shimmer_effects/flutter_shimmer_effects.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShimmerLoading', () {
    testWidgets('uses default light colors in light mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const ShimmerLoading(
            isLoading: true,
            placeholder: SizedBox(width: 100, height: 100),
            child: SizedBox(),
          ),
        ),
      );

      final shimmerFinder = find.byType(Shimmer);
      expect(shimmerFinder, findsOneWidget);

      final shimmer = tester.widget<Shimmer>(shimmerFinder);
      final gradient = shimmer.gradient as LinearGradient;

      // Default Light: Base grey[300], Highlight grey[100]
      expect(gradient.colors[0], Colors.grey.shade300); // base
      expect(gradient.colors[2], Colors.grey.shade100); // highlight
    });

    testWidgets('uses default dark colors in dark mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const ShimmerLoading(
            isLoading: true,
            placeholder: SizedBox(width: 100, height: 100),
            child: SizedBox(),
          ),
        ),
      );

      final shimmerFinder = find.byType(Shimmer);
      expect(shimmerFinder, findsOneWidget);

      final shimmer = tester.widget<Shimmer>(shimmerFinder);
      final gradient = shimmer.gradient as LinearGradient;

      // Default Dark: Base grey[800], Highlight grey[700]
      expect(gradient.colors[0], Colors.grey.shade800); // base
      expect(gradient.colors[2], Colors.grey.shade700); // highlight
    });

    testWidgets('respects user provided colors regardless of theme', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const ShimmerLoading(
            isLoading: true,
            baseColor: Colors.red,
            highlightColor: Colors.blue,
            placeholder: SizedBox(width: 100, height: 100),
            child: SizedBox(),
          ),
        ),
      );

      final shimmerFinder = find.byType(Shimmer);
      final shimmer = tester.widget<Shimmer>(shimmerFinder);
      final gradient = shimmer.gradient as LinearGradient;

      expect(gradient.colors[0], Colors.red);
      expect(gradient.colors[2], Colors.blue);
    });
  });
}
