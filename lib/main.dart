import 'package:flutter/cupertino.dart';
import 'package:glitch_receipt/app/clear_app.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClearApp();
  }
}
