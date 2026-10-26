// documentation:quick-start:start
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() => runApp(const MaterialApp(home: CounterPage()));

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const TNavBar(title: Text('TDesign Flutter')),
    body: Center(
      child: TButton(
        colorPreset: TButtonColorPreset.primary,
        onPressed: () => setState(() => _count += 1),
        child: Text('点击次数：$_count'),
      ),
    ),
  );
}

// documentation:quick-start:end
