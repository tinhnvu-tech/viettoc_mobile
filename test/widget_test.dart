import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viettoc_mobile/main.dart';
import 'package:viettoc_mobile/features/posts/controllers/post_controllers.dart';
import 'package:viettoc_mobile/features/posts/models/post_model.dart';

void main() {
  testWidgets('VietTocApp initial load smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          latestNewsProvider.overrideWith((ref) => Future.value(<PostModel>[])),
          activitiesProvider.overrideWith((ref) => Future.value(<PostModel>[])),
          storiesProvider.overrideWith((ref) => Future.value(<PostModel>[])),
        ],
        child: const VietTocApp(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(VietTocApp), findsOneWidget);
  });
}
