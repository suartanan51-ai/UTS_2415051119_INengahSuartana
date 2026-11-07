
import 'package:flutter_test/flutter_test.dart';
import 'package:taskmate/main.dart';

void main() {
  testWidgets(
    'TaskMate dapat ditampilkan',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const TaskMateApp(
          databaseConfigured: false,
        ),
      );

      expect(find.text('TaskMate'), findsOneWidget);
    },
  );
}
