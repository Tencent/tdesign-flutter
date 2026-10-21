import 'package:tdesign_flutter/src/components/text/t_text_resolve.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// Shared functional/Golden scene: custom content owns its local text theme.
class CustomContentThemeScene extends StatelessWidget {
  const CustomContentThemeScene({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: RepaintBoundary(
        key: const Key('custom-content-scene'),
        child: ColoredBox(
          color: Colors.white,
          child: Row(
            children: [
              for (final m3 in [false, true])
                Expanded(
                  child: Theme(
                    data: ThemeData(
                      useMaterial3: m3,
                      iconTheme: const IconThemeData(
                        color: Colors.green,
                        size: 64,
                      ),
                      textTheme: const TextTheme(
                        bodyMedium: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 28,
                          color: Colors.purple,
                        ),
                      ),
                      extensions: [TThemeData.defaultData()],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          m3 ? 'Material 3' : 'Material 2',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Builder(
                          builder: (context) {
                            // Capture caller defaults before Dialog supplies its slot style.
                            final customTextTheme = TTextThemeData(
                              textStyle: TTextResolve.resolve(context: context),
                            );
                            return TDialog(
                              content: Builder(
                                builder: (context) => Theme(
                                  data: Theme.of(
                                    context,
                                  ).mergeExtension(customTextTheme),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(TIcons.home),
                                      Builder(
                                        builder: (context) => Text(
                                          'Custom content',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const TIcon(TIcons.home),
                                      const TText('TD built-in style'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
