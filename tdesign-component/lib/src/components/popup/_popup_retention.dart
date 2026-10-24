part of 't_popup.dart';

// The owner-managed parking route stays outside Navigator history. A GlobalKey
// moves the live subtree between visible and offstage modal scopes in one frame.
class _PopupRetention {
  _PopupRetention(this.navigator, this.onReleased) {
    _parkingRoute = _PopupParkingRoute(this);
    _parkingRoute.mount();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!navigator.mounted) {
        release();
      }
    });
  }

  final NavigatorState navigator;
  final VoidCallback onReleased;
  final GlobalKey _key = GlobalKey();
  late final _PopupParkingRoute _parkingRoute;
  _PopupNavigatorRoute<dynamic>? _active;
  Widget? _content;
  TOverlayThemes? _themes;
  Size? _parkedSize;
  bool _released = false;

  void activate(_PopupNavigatorRoute<dynamic> route) {
    _active = route;
    _parkingRoute.refresh();
  }

  Widget visible(_PopupNavigatorRoute<dynamic> route, Widget content) {
    if (_released || !identical(_active, route)) {
      return const SizedBox.shrink();
    }
    _themes = route.capturedThemes;
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
    final renderObject = _key.currentContext?.findRenderObject();
    if (renderObject is _PopupRetainedRenderBox && renderObject.hasSize) {
      _parkedSize = renderObject.size;
    }
    _active = null;
    _parkingRoute.refresh();
  }

  Widget _build(BuildContext context) => _PopupRetentionSlot(
    retention: this,
    child: _active != null || _content == null
        ? const SizedBox.shrink()
        : Offstage(
            child: TickerMode(
              enabled: false,
              child: ExcludeFocus(
                child: ExcludeSemantics(child: _parkedContent(context)),
              ),
            ),
          ),
  );

  Widget _parkedContent(BuildContext context) {
    final content = _PopupRetainedTree(
      key: _key,
      parkedSize: _parkedSize,
      child: _PopupRetainedScope(child: _content!),
    );
    return _themes?.wrap(context, content) ?? content;
  }

  void release() {
    if (_released) {
      return;
    }
    _released = true;
    _active = null;
    _content = null;
    _themes = null;
    _parkedSize = null;
    onReleased();
    // Slot disposal can happen while the Overlay itself is unmounting.
    scheduleMicrotask(_parkingRoute.unmount);
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
  const _PopupRetainedTree({super.key, this.parkedSize, required super.child});
  final Size? parkedSize;

  BoxConstraints get _constraints => parkedSize == null
      ? const BoxConstraints()
      : BoxConstraints.tight(parkedSize!);

  @override
  RenderConstrainedBox createRenderObject(BuildContext context) =>
      _PopupRetainedRenderBox(additionalConstraints: _constraints);

  @override
  void updateRenderObject(
    BuildContext context,
    _PopupRetainedRenderBox renderObject,
  ) {
    renderObject.additionalConstraints = _constraints;
  }
}

class _PopupRetainedRenderBox extends RenderConstrainedBox {
  _PopupRetainedRenderBox({required super.additionalConstraints});

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isSemanticBoundary = true;
    config.explicitChildNodes = true;
  }

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

// A private owner-managed route supplies ModalRoute dependencies while parked.
// It never enters Navigator history and therefore cannot intercept system back.
class _PopupParkingRoute extends PopupRoute<void> {
  _PopupParkingRoute(this.retention) : super(requestFocus: false);
  final _PopupRetention retention;
  final ValueNotifier<int> _revision = ValueNotifier<int>(0);

  @override
  NavigatorState get navigator => retention.navigator;
  @override
  bool get isCurrent => false;
  @override
  bool get isFirst => false;
  @override
  bool get offstage => true;
  @override
  bool get hasActiveRouteBelow => false;
  @override
  Duration get transitionDuration => Duration.zero;
  @override
  bool get barrierDismissible => false;
  @override
  Color? get barrierColor => null;
  @override
  String? get barrierLabel => null;
  @override
  bool get maintainState => true;

  @override
  Widget buildModalBarrier() => const SizedBox.shrink();

  void mount() {
    install();
    navigator.overlay!.insertAll(overlayEntries);
  }

  void refresh() {
    _revision.value++;
  }

  void unmount() {
    for (final entry in overlayEntries) {
      entry.remove();
    }
    didComplete(null);
    dispose();
    _revision.dispose();
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => const SizedBox.shrink();

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => NotificationListener<NavigationNotification>(
    onNotification: (_) => true,
    child: Stack(
      children: [
        child,
        ValueListenableBuilder<int>(
          valueListenable: _revision,
          builder: (context, _, __) => retention._build(context),
        ),
      ],
    ),
  );
}
