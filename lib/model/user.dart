class User {
  int userId;
  String firstname;
  String lastname;
  String email;
  String password;
  String token;

  User({this.userId = 0, this.firstname = "", this.lastname ="", this.email="", this.password="", this.token=""});

  // now create converter

  factory User.fromJson(Map<String,dynamic> responseData){
    return User(
      userId: responseData['id'],
      firstname: responseData['firstname'],
      lastname: responseData['lastname'],
      email : responseData['Email'],
      password: responseData['password'],
      token: responseData["token"]
    );
  }
}