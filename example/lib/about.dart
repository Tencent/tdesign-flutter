import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/td_export.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  String? version;

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  Future<void> _getVersion() async {
    try {
      version = await rootBundle.loadString('assets/version');
      print("zflyTest version:$version");
    } catch (e) {
      print('zflyTest error: $e');
    }
    setState(()  {
    });
  }
  
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TDTheme.of(context).grayColor1,
      appBar: AppBar(title: TDText('关于我们', textColor: TDTheme.of(context).whiteColor1,),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            demoRow(context, '版本号：',desc: version)
          ],
        ),
      ),
    );
  }

  Widget demoRow(
      BuildContext context,
      String? title, {
        String? desc,
        bool on = true,
        bool enable = true,
        Color? onColor,
        Color? offColor,
      }) {
    final theme = TDTheme.of(context);
    Widget current = Row(
      children: [
        Expanded(
            child: TDText(
              title,
              textColor: theme.fontGyColor1,
            )),
        TDText(
          desc ?? '',
          textColor: theme.grayColor6,
        ),
      ],
    );
    current = Container(
      color: TDTheme.of(context).whiteColor1,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 1, top: 1),
      child: current,
      height: 44,
    );
    return current;
  }
}
