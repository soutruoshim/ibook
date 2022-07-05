class User {
  String userId;
  String firstname;
  String lastname;
  String email;
  String password;
  String token;

  User({this.userId = "", this.firstname = "", this.lastname ="", this.email="", this.password="", this.token=""});

  // now create converter

  factory User.fromJson(Map<String,dynamic> responseData){
    print(responseData);
    return User(
      userId: responseData['id'],
      firstname: responseData['firstname'],
      lastname: responseData['lastname'],
      email : responseData['email'],
      password: responseData['password'],
      token: responseData["token"],
    );
  }
}