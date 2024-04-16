extension ListChunk<T> on List<T> {
  List<List<T>> chunk(int size) {
    return [
      for (int i = 0; i < length; i += size)
        sublist(i, i + size > length ? length : i + size)
    ];
  }
}
