import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;

  // Singleton instance
  static final DioClient _instance = DioClient._internal();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _initializeDio();
  }

  /// Disposes of the Dio instance.
  void dispose() {
    _dio.close();
  }

  /// Initializes the Dio instance with default configurations.
  Future<void> _initializeDio() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://khaltitf.prixa.live/tfauth',
        responseType: ResponseType.json,
      ),
    );
  }

  /// Generates a verification URL.
  Future<String?> generateVerificationUrl({required String jwtToken}) async {
    try {
      final response = await _dio.post(
        '/get-kyc-url/',
        data: {
          "jwt_token": jwtToken,
        },
      );
      if (response.statusCode == null) return null;
      if (!_validateStatusCode(response.statusCode!)) return null;
      return response.data?["url"];
    } catch (_) {
      rethrow;
    }
  }

  /// Validates the HTTP status code to ensure it falls within the success range.
  bool _validateStatusCode(int statusCode) =>
      statusCode >= 200 && statusCode < 300;
}
