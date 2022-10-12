import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

// ignore: use_key_in_widget_constructors
class TDIconPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TDIconPageState();
}

class _TDIconPageState extends State<TDIconPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('icon图标'),
        ),
        body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Wrap(
            children: [
              for (var iconData in TDIcons.all.values) Icon(iconData)
            ],
          ),
        ));
  }
}
