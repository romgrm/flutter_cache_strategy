/// An error related to the package.
class CacheStrategyError extends Error {
  /// A description of the error.
  final String message;

  /// Create a new CacheStrategy error (internal)
  CacheStrategyError(this.message);

  @override
  String toString() {
    return 'CacheStrategy: $message';
  }
}
