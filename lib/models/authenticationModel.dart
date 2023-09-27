class Authentication_Model {
  Result? result;
  Null? targetUrl;
  bool? success;
  Null? error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  Authentication_Model(
      {this.result,
        this.targetUrl,
        this.success,
        this.error,
        this.unAuthorizedRequest,
        this.bAbp});

  Authentication_Model.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    targetUrl = json['targetUrl'];
    success = json['success'];
    error = json['error'];
    unAuthorizedRequest = json['unAuthorizedRequest'];
    bAbp = json['__abp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['targetUrl'] = this.targetUrl;
    data['success'] = this.success;
    data['error'] = this.error;
    data['unAuthorizedRequest'] = this.unAuthorizedRequest;
    data['__abp'] = this.bAbp;
    return data;
  }
}

class Result {
  String? accessToken;
  String? encryptedAccessToken;
  int? expireInSeconds;
  bool? shouldResetPassword;
  Null? passwordResetCode;
  int? userId;
  bool? requiresTwoFactorVerification;
  Null? twoFactorAuthProviders;
  Null? twoFactorRememberClientToken;
  Null? returnUrl;
  String? refreshToken;
  int? refreshTokenExpireInSeconds;

  Result(
      {this.accessToken,
        this.encryptedAccessToken,
        this.expireInSeconds,
        this.shouldResetPassword,
        this.passwordResetCode,
        this.userId,
        this.requiresTwoFactorVerification,
        this.twoFactorAuthProviders,
        this.twoFactorRememberClientToken,
        this.returnUrl,
        this.refreshToken,
        this.refreshTokenExpireInSeconds});

  Result.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    encryptedAccessToken = json['encryptedAccessToken'];
    expireInSeconds = json['expireInSeconds'];
    shouldResetPassword = json['shouldResetPassword'];
    passwordResetCode = json['passwordResetCode'];
    userId = json['userId'];
    requiresTwoFactorVerification = json['requiresTwoFactorVerification'];
    twoFactorAuthProviders = json['twoFactorAuthProviders'];
    twoFactorRememberClientToken = json['twoFactorRememberClientToken'];
    returnUrl = json['returnUrl'];
    refreshToken = json['refreshToken'];
    refreshTokenExpireInSeconds = json['refreshTokenExpireInSeconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['encryptedAccessToken'] = this.encryptedAccessToken;
    data['expireInSeconds'] = this.expireInSeconds;
    data['shouldResetPassword'] = this.shouldResetPassword;
    data['passwordResetCode'] = this.passwordResetCode;
    data['userId'] = this.userId;
    data['requiresTwoFactorVerification'] = this.requiresTwoFactorVerification;
    data['twoFactorAuthProviders'] = this.twoFactorAuthProviders;
    data['twoFactorRememberClientToken'] = this.twoFactorRememberClientToken;
    data['returnUrl'] = this.returnUrl;
    data['refreshToken'] = this.refreshToken;
    data['refreshTokenExpireInSeconds'] = this.refreshTokenExpireInSeconds;
    return data;
  }
}