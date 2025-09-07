// To parse this JSON data, do
//
//     final responseApi = responseApiFromJson(jsonString);

import 'dart:convert';

ResponseApi responseApiFromJson(String str) => ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
    late int status;
    var error;
    late int code;
    late bool success;
    late dynamic data;
    ResponseApi({
         required this.status,
         this.error,
         required this.code,
    });
    ResponseApi.fromJson(Map<String, dynamic> json){
       // status= json["status"];
       // code= json["code"];
        try {
        status= json["status"];
        code= json["code"];

            error= json["error"] != null ? json["error"] : '';
          data=json['data'];
        } catch (e) {
          print('Exception data'+e.toString());
        }
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "code": code,
        "data":data,
    };
}
