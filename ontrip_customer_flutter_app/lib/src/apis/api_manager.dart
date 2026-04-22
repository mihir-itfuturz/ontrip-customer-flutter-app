import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../core/constants.dart';
import '../core/app_session.dart';
import '../helper/app_toast.dart';
import '../services/storage_service.dart';
import 'api_response.dart';
import 'network_config.dart';

enum ApiType { get, post, put, patch, delete }

class ApiManager {
  static final instance = ApiManager._apiManager();

  factory ApiManager() => instance;
  final Dio _dio = Dio();
  final String baseUrl = AppNetworkConstants.apiBaseURL;

  ApiManager._apiManager() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {'Accept': 'application/json', 'content-type': 'application/json'};
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (kDebugMode) {
            debugPrint("AuthToken ::: ${await getStorage(AppSession.token)}");
            debugPrint("Endpoint URL ::: ${options.uri}");
            debugPrint("Request SEND BODY ::: ${options.data}");
          }
          dynamic authToken = await getStorage(AppSession.token);
          if (authToken != null && authToken != '') {
            debugPrint("Admin Token");
            options.headers["Authorization"] = "Bearer $authToken";
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint("Method: ${response.requestOptions.method}");
            if (response.requestOptions.responseType == ResponseType.bytes) {
              debugPrint("Server Response: Binary data (${response.data.length} bytes)");
            } else {
              log("Server Response: ${response.data}");
            }
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint("API Error: ${error.toString()}");
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<ApiResponse> call({
    required String endPoint,
    dynamic body,
    ApiType type = ApiType.post,
    ResponseType responseType = ResponseType.json,
    Map<String, String>? customHeaders,
  }) async {
    ApiResponse apiData = ApiResponse(status: 0, message: Constant.instance.initialErrorMdg, data: null);
    try {
      if (customHeaders != null) {
        _dio.options.headers.addAll(customHeaders);
      }
      Response response;
      final options = Options(responseType: responseType);
      switch (type) {
        case ApiType.post:
          response = await _dio.post(endPoint, data: body, options: options);
          break;
        case ApiType.put:
          response = await _dio.put(endPoint, data: body, options: options);
          break;
        case ApiType.patch:
          response = await _dio.patch(endPoint, data: body, options: options);
          break;
        case ApiType.delete:
          response = await _dio.delete(endPoint, data: body, options: options);
          break;
        default:
          response = await _dio.get(endPoint, options: options);
          break;
      }
      apiData = _checkStatus(response, endPoint, body, responseType);
      return apiData;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        onSocketException(e);
      } else {
        onException(e);
        errorToast("Something went wrong\n${e.error ?? ''}");
      }
      return apiData;
    } catch (e) {
      errorToast("Something went wrong\n$e");
      return apiData;
    }
  }

  // ApiResponse _checkStatus(Response response, String apiName, dynamic req, ResponseType responseType) {
  //   if (response.statusCode == 200 || response.statusCode == 201) {

  //     if (responseType == ResponseType.bytes) {
  //       return ApiResponse(status: response.statusCode ?? 200, message: 'Success', data: response.data);
  //     } else {
  //       return ApiResponse.fromJson(response.data);
  //     }
  //   } else {
  //     return ApiResponse(
  //       status: response.statusCode ?? 0,
  //       message: response.data is Map ? response.data['message'] ?? 'Request failed' : 'Request failed',
  //       data: response.data is Map ? response.data['data'] : null,
  //     );
  //   }
  // }

  ApiResponse _checkStatus(Response response, String apiName, dynamic req, ResponseType responseType) {
    final statusCode = response.statusCode ?? 0;

    // Handle binary response
    if (responseType == ResponseType.bytes && (statusCode == 200 || statusCode == 201)) {
      return ApiResponse(status: statusCode, message: 'Success', data: response.data);
    }

    // Parse JSON safely
    final data = response.data;

    bool isSuccess = false;
    String message = "Request failed";

    if (data is Map) {
      isSuccess = data['success'] == true;
      message = data['message'] ?? message;
    }

    return ApiResponse(
      status: isSuccess ? 1 : 0, // ✅ IMPORTANT CHANGE
      message: message,
      data: data is Map ? data['data'] : null,
    );
  }

  void onSocketException(DioException e) => debugPrint("API : SocketException - ${e.toString()}");

  void onException(Exception e) => debugPrint("API : Exception - ${e.toString()}");
}
