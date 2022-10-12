import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';


class TDIconPage extends StatefulWidget {
  const TDIconPage({Key? key}) : super(key: key);

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
