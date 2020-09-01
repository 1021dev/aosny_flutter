class LoginResponse {
  int userId;
  String userName;
  String firstName;
  String lastName;
  String email;
  String password;
  String providerid;
  String token;
  String message;
  String signatureFilename;
  String createdDate;
  String updatedDate;

  LoginResponse(
      {this.userId, this.email, this.password, this.providerid, this.token});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    password = json['password'];
    providerid = json['providerid'];
    token = json['token'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['email'] = this.email;
    data['password'] = this.password;
    data['providerid'] = this.providerid;
    data['token'] = this.token;
    data['message'] = this.message;
    return data;
  }
}