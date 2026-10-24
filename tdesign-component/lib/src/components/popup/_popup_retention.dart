part of 't_popup.dart';

// A mounted parking slot belongs to the Navigator overlay, not to a popped
// route. A GlobalKey moves the live subtree within the same frame.
class _PopupRetention {
  _PopupRetention(this.navigator, this.onReleased) {
    _entry = OverlayEntry(maintainState: true, builder: _build);
    navigator.overlay!.insert(_entry);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!navigator.mounted) {
        release();
      }
    });
  }

  final NavigatorState navigator;
  final VoidCallback onReleased;
  final GlobalKey _key = GlobalKey();
  late final OverlayEntry _entry;
  _PopupNavigatorRoute<dynamic>? _active;
  Widget? _content;
  bool _released = false;

  void activate(_PopupNavigatorRoute<dynamic> route) {
    _active = route;
    _entry.markNeedsBuild();
  }

  Widget visible(_PopupNavigatorRoute<dynamic> route, Widget content) {
    if (_released || !identical(_active, route)) {
      return const SizedBox.shrink();
    }
    _content = Semantics(
      container: true,
      explicitChildNodes: true,
      child: content,
    );
    return _PopupRetainedTree(
      key: _key,
      child: _PopupRetainedScope(child: _content!),
    );
  }

  void park(_PopupNavigatorRoute<dynamic> route) {
    if (_released || !identical(_active, route)) {
      return;
    }
    _active = null;
    _entry.markNeedsBuild();
  }

  Widget _build(BuildContext context) => _PopupRetentionSlot(
    retention: this,
    child: _active != null || _content == null
        ? const SizedBox.shrink()
        : Offstage(
            child: TickerMode(
              enabled: false,
              child: ExcludeFocus(
                child: ExcludeSemantics(
                  child: _PopupRetainedTree(
                    key: _key,
                    child: _PopupRetainedScope(child: _content!),
                  ),
                ),
              ),
            ),
          ),
  );

  void release() {
    if (_released) {
      return;
    }
    _released = true;
    _active = null;
    _content = null;
    onReleased();
    // Slot disposal can happen while the Overlay itself is unmounting.
    scheduleMicrotask(() {
      _entry.remove();
      _entry.dispose();
    });
  }
}

class _PopupRetentionSlot extends StatefulWidget {
  const _PopupRetentionSlot({required this.retention, required this.child});
  final _PopupRetention retention;
  final Widget child;

  @override
  State<_PopupRetentionSlot> createState() => _PopupRetentionSlotState();
}

class _PopupRetentionSlotState extends State<_PopupRetentionSlot> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    widget.retention.release();
    super.dispose();
  }
}

// Reparenting a live tree changes its semantic ancestry. Clear the detached
// render root's cached semantic tree before it is attached to the parking slot.
class _PopupRetainedTree extends SingleChildRenderObjectWidget {
  const _PopupRetainedTree({super.key, required super.child});

  @override
  RenderProxyBox createRenderObject(BuildContext context) =>
      _PopupRetainedRenderBox();
}

class _PopupRetainedRenderBox extends RenderProxyBox {
  @override
  void detach() {
    super.detach();
    if (parent == null) {
      clearSemantics();
    }
  }
}

// Route-owned scroll controllers and PageStorage disappear on pop. Their
// replacements belong to the retained content so implicit scrollables survive.
class _PopupRetainedScope extends StatefulWidget {
  const _PopupRetainedScope({required this.child});
  final Widget child;

  @override
  State<_PopupRetainedScope> createState() => _PopupRetainedScopeState();
}

class _PopupRetainedScopeState extends State<_PopupRetainedScope> {
  final ScrollController _scroll = ScrollController();
  final PageStorageBucket _storage = PageStorageBucket();

  @override
  Widget build(BuildContext context) => PageStorage(
    bucket: _storage,
    child: PrimaryScrollController(controller: _scroll, child: widget.child),
  );

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }
}
