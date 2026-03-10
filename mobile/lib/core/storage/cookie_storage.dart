import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// Creates and returns a PersistCookieJar instance.
Future<PersistCookieJar> createCookieJar() async {
  final dir = await getApplicationDocumentsDirectory();
  return PersistCookieJar(
    storage: FileStorage('${dir.path}/cookies'),
    ignoreExpires: false,
  );
}

// This provider should be overridden in main.dart with a pre-initialized CookieJar
//// CookieJar provider
final cookieJarProvider = Provider<PersistCookieJar>((ref) {
  throw UnimplementedError(
      'Override this provider with a pre-initialized CookieJar in main.dart');
});