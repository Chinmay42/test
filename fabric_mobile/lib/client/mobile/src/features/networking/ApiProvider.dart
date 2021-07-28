
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'CustomException.dart';


class ApiProvider {
  final String _AadharVaultUrl = "http://59.165.234.9:1002/adv";
  final String token="SIN-OF-WRATH";



  Future<dynamic> get(String url) async {
    var responseJson;
    try {


      Map<String, String> headers = {"Content-Type": "application/json","x-web-api-token":token};
      final response = await http.get(_AadharVaultUrl + url,headers:headers);
      responseJson = _response(response,_AadharVaultUrl);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    var responseJson;
    try {

      Map<String, String> headers = {"Content-Type": "application/json","x-web-api-token":token};

      final response = await http.delete(_AadharVaultUrl + url,headers:headers);
      responseJson = _response(response,_AadharVaultUrl);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  Future<dynamic> post(String url, String json) async {
    var responseJson;
    try {

      Map<String, String> headers = {"Content-Type": "application/json","x-web-api-token":token};
      final response = await http.post(_AadharVaultUrl + url, headers: headers, body:'$json');
      responseJson = _response(response,_AadharVaultUrl);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  Future<dynamic> update(String url, String json) async {
    var responseJson;
    try {

      Map<String, String> headers = {"Content-Type": "application/json","x-web-api-token":token};
      final response = await http.put(_AadharVaultUrl + url, headers: headers, body:'$json');
      responseJson = _response(response,_AadharVaultUrl);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  dynamic _response(http.Response response,String url) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;

      case 400:

        if(url.compareTo(_AadharVaultUrl)==0){
        var responseJson = json.decode(response.body.toString());
       throw BadRequestParametersException(responseJson['errors'][0]['description']);}
        else{
          throw BadRequestParametersException(response.body.toString());
        }
        break;

      case 401:
        throw SessionsExpiredException(response.body.toString());
      case 404:
        throw EndPointsException(response.body.toString());
      case 500:
        throw InternalServerException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}