import 'package:flutter_test/flutter_test.dart';
import 'package:trainerpro/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TrainerProApp());
    // Verify it launches without error
    expect(find.byType(TrainerProApp), findsOneWidget);
  });
}
