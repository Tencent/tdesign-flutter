// 辅助库：网络图缓存测试使用的最小 HTTP mock（无 main，仅被 part 引用）。
part of 't_image_test.dart';

/// 返回 200 与固定字节的测试 HttpClient，用于让网络图真正进入 ImageCache。
class _OkHttpClient implements HttpClient {
  final Uint8List bytes;

  _OkHttpClient(this.bytes);

  @override
  bool autoUncompress = true;

  @override
  Duration? connectionTimeout;

  @override
  Duration idleTimeout = const Duration(seconds: 15);

  @override
  int? maxConnectionsPerHost;

  @override
  String? userAgent;

  @override
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {}

  @override
  void addProxyCredentials(
    String host,
    int port,
    String realm,
    HttpClientCredentials credentials,
  ) {}

  @override
  Future<ConnectionTask<Socket>> Function(Uri url, String? proxyHost, int? proxyPort)?
  connectionFactory;

  @override
  Future<bool> Function(Uri url, String scheme, String realm)? authenticate;

  @override
  Future<bool> Function(String host, int port, String scheme, String realm)?
  authenticateProxy;

  @override
  bool Function(X509Certificate cert, String host, int port)? badCertificateCallback;

  @override
  void Function(String line)? keyLog;

  @override
  void close({bool force = false}) {}

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      _request();

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) => _request();

  @override
  String Function(Uri url)? findProxy;

  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      _request();

  @override
  Future<HttpClientRequest> getUrl(Uri url) => _request();

  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      _request();

  @override
  Future<HttpClientRequest> headUrl(Uri url) => _request();

  @override
  Future<HttpClientRequest> open(
    String method,
    String host,
    int port,
    String path,
  ) => _request();

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) => _request();

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      _request();

  @override
  Future<HttpClientRequest> patchUrl(Uri url) => _request();

  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      _request();

  @override
  Future<HttpClientRequest> postUrl(Uri url) => _request();

  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      _request();

  @override
  Future<HttpClientRequest> putUrl(Uri url) => _request();

  Future<HttpClientRequest> _request() =>
      Future<HttpClientRequest>.value(_OkHttpRequest(bytes));
}

class _OkHttpRequest implements HttpClientRequest {  _OkHttpRequest(this.bytes);

  final Uint8List bytes;

  @override
  bool bufferOutput = true;

  @override
  int contentLength = -1;

  @override
  Encoding encoding = utf8;

  @override
  bool followRedirects = true;

  @override
  final HttpHeaders headers = _OkHttpHeaders();

  @override
  void add(List<int> data) {}

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<void> addStream(Stream<List<int>> stream) => Future<void>.value();

  @override
  Future<HttpClientResponse> close() =>
      Future<HttpClientResponse>.value(_OkHttpResponse(bytes));

  @override
  void abort([Object? exception, StackTrace? stackTrace]) {}

  @override
  HttpConnectionInfo? get connectionInfo => null;

  @override
  List<Cookie> get cookies => <Cookie>[];

  @override
  Future<HttpClientResponse> get done async => _OkHttpResponse(bytes);

  @override
  Future<void> flush() => Future<void>.value();

  @override
  int maxRedirects = 5;

  @override
  String get method => 'GET';

  @override
  bool persistentConnection = true;

  @override
  Uri get uri => Uri();

  @override
  void write(Object? obj) {}

  @override
  void writeAll(Iterable<dynamic> objects, [String? separator]) {}

  @override
  void writeCharCode(int charCode) {}

  @override
  void writeln([Object? obj = '']) {}
}

class _OkHttpResponse extends Stream<List<int>>
    implements HttpClientResponse {
  _OkHttpResponse(this.bytes);

  final Uint8List bytes;

  @override
  List<RedirectInfo> get redirects => const <RedirectInfo>[];

  @override
  final HttpHeaders headers = _OkHttpHeaders();

  @override
  X509Certificate? get certificate => null;

  @override
  HttpConnectionInfo? get connectionInfo => null;

  @override
  int get contentLength => bytes.length;

  @override
  HttpClientResponseCompressionState get compressionState {
    return HttpClientResponseCompressionState.decompressed;
  }

  @override
  List<Cookie> get cookies => <Cookie>[];

  @override
  Future<Socket> detachSocket() =>
      Future<Socket>.error(UnsupportedError('Mocked response'));

  @override
  bool get isRedirect => false;

  @override
  StreamSubscription<Uint8List> listen(
    void Function(Uint8List event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<Uint8List>.fromIterable(<Uint8List>[bytes]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  bool get persistentConnection => false;

  @override
  String get reasonPhrase => 'OK';

  @override
  Future<HttpClientResponse> redirect([
    String? method,
    Uri? url,
    bool? followLoops,
  ]) {
    return Future<HttpClientResponse>.error(
      UnsupportedError('Mocked response'),
    );
  }

  @override
  int get statusCode => HttpStatus.ok;
}

class _OkHttpHeaders implements HttpHeaders {
  final Map<String, List<String>> _values = <String, List<String>>{};

  @override
  bool chunkedTransferEncoding = false;

  @override
  int contentLength = -1;

  @override
  ContentType? contentType;

  @override
  DateTime? date;

  @override
  DateTime? expires;

  @override
  String? host;

  @override
  DateTime? ifModifiedSince;

  @override
  bool persistentConnection = true;

  @override
  int? port;

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    _values.putIfAbsent(name, () => <String>[]).add(value.toString());
  }

  @override
  void clear() => _values.clear();

  @override
  void forEach(void Function(String name, List<String> values) action) {
    _values.forEach(action);
  }

  @override
  List<String>? operator [](String name) => _values[name];

  @override
  void removeAll(String name) => _values.remove(name);

  @override
  void remove(String name, Object value) {
    _values[name]?.remove(value.toString());
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _values[name] = <String>[value.toString()];
  }

  @override
  String? value(String name) => _values[name]?.firstOrNull;

  @override
  void noFolding(String name) {}
}

/// 1×1 白色 PNG（合法图片字节，可被系统解码器解码）。
final Uint8List kOnePixelPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);
