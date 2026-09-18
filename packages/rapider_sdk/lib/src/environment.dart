class RapiderEnvironment {
  // Use const String.fromEnvironment for compile-time injection, but provide default fallback values.
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://dev.api.rappider.com',
  );

  static const bool requireLogin = bool.fromEnvironment(
    'REQUIRE_LOGIN',
    defaultValue: false,
  );
}
