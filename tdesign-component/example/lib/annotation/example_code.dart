/// Marks a function, method, or standalone example Widget for the code viewer.
///
/// A standalone `*_example.dart` or `*_demo.dart` class exports its complete
/// source file so top-level data, helpers, models and extensions stay copyable.
class ExampleCode {
  /// The generated snippet group. It must match the page's example code group.
  final String group;

  /// Relative helper files whose declarations are part of this copyable demo.
  final List<String> includes;

  /// Independent guide route, instead of a component page ExampleItem.
  ///
  /// Must be a unique literal route registered to this standalone Widget.
  /// Null keeps the component ExampleItem registration contract.
  final String? route;

  const ExampleCode({
    required this.group,
    this.includes = const [],
    this.route,
  });
}

/// Marks a migrated Example page whose public code order is manifest-driven.
///
/// Every non-ignored `ExampleItem` on the page must declare a literal
/// `methodName` and directly build the same standalone Widget class.
class ExampleCodeManifest {
  const ExampleCodeManifest();
}
