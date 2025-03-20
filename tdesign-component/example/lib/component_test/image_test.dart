import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() async {
  runApp(ImageTestApp());
}

class ImageTestApp extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: TDText('TDImage Test Page'),
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
            SizedBox(height: 20),

            TDImage(
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
