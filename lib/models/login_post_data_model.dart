class LoginTokenPost {
  int userId;
  String firstName;
  String lastName;
  String email;
  String password;
  String createdDate;

  LoginTokenPost(
      {this.userId,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.createdDate});

  LoginTokenPost.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['createdDate'] = this.createdDate;
    return data;
  }
}