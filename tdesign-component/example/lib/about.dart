import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String? version;

  String? publishTime;

  @override
  void initState() {
    super.initState();
    _getVersion();
    _getPublishTime();
  }

  Future<void> _getVersion() async {
    version = await rootBundle.loadString('assets/version');
    setState(() {});
  }

  Future<void> _getPublishTime() async {
    var timeStamp = await rootBundle.loadString('assets/publish_time');
    var exactTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp.trim()));
    publishTime = '${exactTime.year}-${exactTime.month}-${exactTime.day}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于我们')),
      body: TDCellGroup(
        title: 'TDesign Flutter',
        theme: TDCellGroupTheme.cardTheme,
        cells: [
          TDCell(title: '版本号', note: version),
          TDCell(title: '发版日期', note: publishTime),
        ],
      ),
    );
  }
}
