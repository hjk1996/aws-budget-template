import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerError {
  final String message;
  ServerError(this.message);
}

class DynamodbRepository {
  late final Dio dio;
  late final SharedPreferences prefs;
  DynamodbRepository({required this.dio, required this.prefs});

  final String baseUrl =
      "https://hpfx65wi7vm5zfzutb7gf2ffhm0gxnia.lambda-url.ap-northeast-2.on.aws/";

  Future<Either<ServerError, List<Object>>> fetchResources(
      String resourceName) async {
    try {
      // 1. 캐시에서 데이터 확인
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(resourceName); // 캐시에 저장된 데이터 확인

      if (cachedData != null) {
        // 2. 캐시에 데이터가 있으면 파싱하여 반환
        List<Object> items = _parseCachedData(cachedData); // 캐시 데이터를 파싱하는 함수
        return Right(items);
      }

      // 3. 캐시에 데이터가 없으면 네트워크 요청
      Response res = await dio.get(baseUrl, queryParameters: {
        'resource': resourceName,
      });

      if (res.statusCode == 200) {
        // 데이터가 List<dynamic> 형태인지 확인 후 명시적으로 List<Object>로 변환
        if (res.data is List) {
          List<Object> items = res.data.cast<Object>(); // List<Object>로 변환

          // 4. 네트워크에서 가져온 데이터를 캐시에 저장
          await prefs.setString(resourceName, _serializeData(items));

          return Right(items); // 성공적으로 데이터를 가져오면 Right 반환
        } else {
          return Left(ServerError("Invalid data format received"));
        }
      } else {
        return Left(ServerError("Failed with status code: ${res.statusCode}"));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerError("DioError: ${e.message}"));
      } else {
        return Left(ServerError("Unknown error occurred: $e"));
      }
    }
  }

  // 캐시된 데이터를 파싱하는 함수
  List<Object> _parseCachedData(String cachedData) {
    // 캐시된 문자열 데이터를 List<Object>로 변환 (JSON 파싱을 가정)
    return List<Object>.from(jsonDecode(cachedData));
  }

// 네트워크 데이터를 캐시에 저장하기 위해 직렬화하는 함수
  String _serializeData(List<Object> items) {
    // List<Object> 데이터를 캐시에 저장할 수 있는 문자열로 변환 (JSON 직렬화)
    return jsonEncode(items);
  }
}
