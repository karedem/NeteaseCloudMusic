class WxResponse<T> {
  num code;
  String message;
  T data;

  static WxResponse fromJson(map) {
    WxResponse wxResponse = WxResponse();
    wxResponse.code = map['code'];
    wxResponse.message = map['message'];
    wxResponse.data = map['data'];
    return wxResponse;
  }

  Map<String, dynamic> toJson() =>
      {'code': code, 'message': message, 'data': data};
}
