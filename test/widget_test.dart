import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_tugas2/main.dart';

void main() {
  testWidgets('EduMate app berjalan', (WidgetTester tester) async {
    await tester.pumpWidget(const EduMateApp());

    expect(find.text('Selamat Datang di EduMate'), findsOneWidget);
  });
}
