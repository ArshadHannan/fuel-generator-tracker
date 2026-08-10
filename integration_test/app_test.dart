import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:my_flutter_app1/firebase_options.dart';
import 'package:my_flutter_app1/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'app boots and switches between Runtime and Fuel tabs',
    (tester) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Fuel Tracker Generator'), findsOneWidget);
      expect(find.text('Number of Hours'), findsOneWidget);

      await tester.tap(find.text('Fuel'));
      await tester.pumpAndSettle();

      expect(find.text('Number of Liters'), findsOneWidget);
      expect(find.text('Price per Liter'), findsOneWidget);
    },
  );
}
