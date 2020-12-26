import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/details_entity.dart';

import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';
// ignore: directives_ordering
import 'dart:async';
import '../utils/config.dart';

const String SAVE_ORDER_URL = '$JIWELL_SERVER_HOST/order';
class SaveOrderDao{

  static Future<String> fetch(Map<String, dynamic> param,String token) async{
    try {
      final String headerToken = 'Bearer '+ token;
      final Options options = Options(headers: {'Authorization':headerToken});
      final Response response = await Dio().post(SAVE_ORDER_URL,data: param,options: options);
      if(response.statusCode == 201){
        return response.data[0];
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}

const String serverAddress = 'http://your.server.address:prot';

///fix query string
class FixQueryStringRequestOptions extends RequestOptions {
  FixQueryStringRequestOptions({
    String method,
    int sendTimeout,
    int receiveTimeout,
    int connectTimeout,
    dynamic data,
    String path,
    Map<String, dynamic> queryParameters,
    String baseUrl,
    void Function(int, int) onReceiveProgress,
    void Function(int, int) onSendProgress,
    CancelToken cancelToken,
    Map<String, dynamic> extra,
    Map<String, dynamic> headers,
    ResponseType responseType,
    String contentType,
    ValidateStatus validateStatus,
    bool receiveDataWhenStatusError = true,
    bool followRedirects = true,
    int maxRedirects,
    RequestEncoder requestEncoder,
    ResponseDecoder responseDecoder,
  }) : super(
    method: method,
    sendTimeout: sendTimeout,
    receiveTimeout: receiveTimeout,
    connectTimeout: connectTimeout,
    data: data,
    path: path,
    queryParameters: queryParameters,
    baseUrl: baseUrl,
    onReceiveProgress: onReceiveProgress,
    onSendProgress: onSendProgress,
    cancelToken: cancelToken,
    extra: extra,
    headers: headers,
    responseType: responseType,
    contentType: contentType,
    validateStatus: validateStatus,
    receiveDataWhenStatusError: receiveDataWhenStatusError,
    followRedirects: followRedirects,
    maxRedirects: maxRedirects,
    requestEncoder: requestEncoder,
    responseDecoder: responseDecoder,
  );

  /// here is important
  ///
  ///
  @override
  Uri get uri {
    final Uri _url = Uri.parse(baseUrl + path);

    return Uri(
      scheme: _url.scheme,
      host: _url.host,
      port: _url.port,
      path: _url.path,
      queryParameters: queryParameters, //use Uri default querystring serializer
    );
  }
}

/// convert all value to string type
///
///
_convertQueryParameters(Map<String, dynamic> parameters) {
  final Map<String, dynamic> queryParams = <String, dynamic>{};
  // ignore: always_specify_types
  parameters.forEach((String key, value) {
    if (value is List) {
      // ignore: always_specify_types
      final List list = [];
      // ignore: always_specify_types
      for (final item in value) {
        list.add('$item');
      }
      queryParams[key] = list;
    } else {
      queryParams[key] = '$value';
    }
  });
  return queryParams;
}

/// global dio instance
final Dio dio = new Dio(new BaseOptions(baseUrl: serverAddress))
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        final fixOption = FixQueryStringRequestOptions(
          method: options.method,
          sendTimeout: options.sendTimeout,
          receiveTimeout: options.receiveTimeout,
          connectTimeout: options.connectTimeout,
          data: options.data,
          path: options.path,
          queryParameters: _convertQueryParameters(options.queryParameters),
          baseUrl: options.baseUrl,
          onReceiveProgress: options.onReceiveProgress,
          onSendProgress: options.onSendProgress,
          cancelToken: options.cancelToken,
          extra: options.extra,
          headers: options.headers,
          responseType: options.responseType,
          contentType: options.contentType,
          validateStatus: options.validateStatus,
          receiveDataWhenStatusError: options.receiveDataWhenStatusError,
          followRedirects: options.followRedirects,
          maxRedirects: options.maxRedirects,
          requestEncoder: options.requestEncoder,
          responseDecoder: options.responseDecoder,
        );
        return fixOption; //continue
      },
      // ignore: always_specify_types
      onResponse: (Response response) async {
        // Do something with response data
        return response; // continue
      },
      onError: (DioError e) async {
        // Do something with response error
        return e; //continue
      },
    ),
  );
//{"timestamp":1590743580571,"status":500,"error":"Internal Server Error","message":"Invalid property 'orderDetails[0][image]' of
//flutter Dao傳array參數

    //{"timestamp":1591586561556,"status":500,"error":"Internal Server Error","message":"Invalid property 'orderDetails[0][image]' of
