import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() async {
  runApp(const ImageTestApp());
}

class ImageTestApp extends StatelessWidget {
  const ImageTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Image Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestPage(),
    );
  }
}

class TestPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TestPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const TText('TImage Test Page'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [

            Image.network(
              'assets/img/image.png',
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 20),

            const TImage(
              src: 'assets/img/image.png',
              variant: TImageVariant.fitHeight,
              fit: BoxFit.fitHeight,
            ),
          ],
        )
      ),
    );
  }
}
