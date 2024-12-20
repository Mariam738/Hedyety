
class Users {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  bool? prefrence; // notification on/ off

  Users({this.name, this.email, this.phone, this.password, this.prefrence});

  toJson(){
    return {
      'name' : name,
      'email' : email,
      'phone' : phone,
      'password' : password,
    };
  }
}