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
        title: const TDText('TDImage Test Page'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [

            Image.network(
              'assets/img/image.png',
              width: 335,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 20),

            const TDImage(
              imgUrl: 'assets/img/image.png',
              type: TDImageType.fitHeight,
              height: 144,
              fit: BoxFit.fitHeight,
            ),
          ],
        )
      ),
    );
  }
}
