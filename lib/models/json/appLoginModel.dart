class AppLoginModel {
  final String accessToken;
  final int expires_in;
  final String token_type;
  final String scope;
  final String refresh_token;

  AppLoginModel(this.accessToken, this.expires_in, this.token_type, this.scope, this.refresh_token);

  AppLoginModel.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'],
        expires_in = json['expires_in'],
        token_type = json['token_type'],
        scope = json['scope'],
        refresh_token = json['refresh_token'];

  Map<String, dynamic> toJson() =>
      {
        'access_token': accessToken,
        'expires_in': expires_in,
        'token_type': token_type,
        'scope': scope,
        'refresh_token': refresh_token,
      };
}