class Environment {
  // static const String url ="https://animated-happiness-g4546xgqvrwxhvrvw-8080.app.github.dev";
  static const String url ="http://192.168.1.20:8080";
  static const String baseUrl = String.fromEnvironment('BASE_URL',defaultValue: '$url/api/v1');

  static const double rayonTripParcel = 10000000.0;
}
