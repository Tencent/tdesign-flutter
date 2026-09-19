part of 'popover_page.dart';

extension _PopoverStyleModule on _TPopoverPage {
  ExampleModule get _popoverStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(
        ignoreCode: true,
        builder: (context) {
          return Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(child: CodeWrapper(builder: _buildDarkPopover)),
                    Expanded(child: CodeWrapper(builder: _buildLightPopover)),
                    Expanded(child: CodeWrapper(builder: _buildPrimaryPopover)),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(child: CodeWrapper(builder: _buildSuccessPopover)),
                    Expanded(child: CodeWrapper(builder: _buildWarningPopover)),
                    Expanded(child: CodeWrapper(builder: _buildDangerPopover)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      ExampleItem(
        desc: '顶部弹出气泡',
        ignoreCode: true,
        builder: (context) {
          return Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(child: CodeWrapper(builder: _buildTopLeftPopover)),
                Expanded(child: CodeWrapper(builder: _buildTopPopover)),
                Expanded(child: CodeWrapper(builder: _buildTopRightPopover)),
              ],
            ),
          );
        },
      ),
      ExampleItem(
        desc: '底部弹出气泡',
        ignoreCode: true,
        builder: (context) {
          return Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(child: CodeWrapper(builder: _buildBottomLeftPopover)),
                Expanded(child: CodeWrapper(builder: _buildBottomPopover)),
                Expanded(child: CodeWrapper(builder: _buildBottomRightPopover)),
              ],
            ),
          );
        },
      ),
      ExampleItem(
        desc: '右侧弹出气泡',
        ignoreCode: true,
        builder: (context) {
          return Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CodeWrapper(builder: _buildRightTopPopover),
                CodeWrapper(builder: _buildRightPopover),
                CodeWrapper(builder: _buildRightBottomPopover),
              ],
            ),
          );
        },
      ),
      ExampleItem(
        desc: '左侧弹出气泡',
        ignoreCode: true,
        builder: (context) {
          return Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CodeWrapper(builder: _buildLeftTopPopover),
                CodeWrapper(builder: _buildLeftPopover),
                CodeWrapper(builder: _buildLeftBottomPopover),
              ],
            ),
          );
        },
      ),
    ],
  );
}
