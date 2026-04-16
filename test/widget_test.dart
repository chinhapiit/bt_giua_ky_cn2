import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/main.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const NewsApp());
    expect(find.text('Bắt đầu đọc tin'), findsOneWidget);
  });
}
