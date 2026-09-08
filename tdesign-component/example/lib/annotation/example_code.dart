/// Marks a function, method, or standalone example Widget for the code viewer.
///
/// An annotated class includes its imports and directly associated same-file
/// `State<Widget>` class. Other helpers must be self-contained in these classes.
class ExampleCode {
  /// The generated snippet group. It must match the page's example code group.
  final String group;

  const ExampleCode({required this.group});
}
