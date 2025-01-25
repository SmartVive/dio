part of 'http2_adapter.dart';

typedef ValidateCertificate = bool Function(
  X509Certificate? certificate,
  String host,
  int port,
);

/// Resolves the proxy to use for a request to [uri].
///
/// Returning `null` connects directly to [uri].
typedef ProxyResolver = FutureOr<Uri?> Function(Uri uri);

class ClientSetting {
  /// The certificate provided by the server is checked
  /// using the trusted certificates set in the SecurityContext object.
  /// The default SecurityContext object contains a built-in set of trusted
  /// root certificates for well-known certificate authorities.
  SecurityContext? context;

  /// [onBadCertificate] is an optional handler for unverifiable certificates.
  /// The handler receives the [X509Certificate], and can inspect it and
  /// decide (or let the user decide) whether to accept
  /// the connection or not.  The handler should return true
  /// to continue the [SecureSocket] connection.
  bool Function(X509Certificate certificate)? onBadCertificate;

  /// Allows the user to decide if the response certificate is good.
  /// If this function is missing, then the certificate is allowed.
  /// This method is called only if both the [SecurityContext] and
  /// [badCertificateCallback] accept the certificate chain. Those
  /// methods evaluate the root or intermediate certificate, while
  /// [validateCertificate] evaluates the leaf certificate.
  ValidateCertificate? validateCertificate;

  /// Creates clients with the given [proxy] setting.
  ///
  /// When set, all HTTP/2 traffic from [Dio] goes through this proxy tunnel.
  /// The [Uri] contains the scheme, address, port, and optional credentials.
  Uri? proxy;

  /// Resolves a proxy for each request URI.
  ///
  /// When set, this takes precedence over [proxy]. Returning `null` connects
  /// directly. The resolver can complete synchronously or asynchronously.
  ProxyResolver? findProxy;

  Future<Uri?> _resolveProxy(Uri uri) async {
    final resolver = findProxy;
    return resolver == null ? proxy : await resolver(uri);
  }
}
