class UserData {
  UserData({this.name, this.surname, this.mail, this.phone, this.picture});

  final String name;
  final String surname;
  final String mail;
  final String phone;
  final String picture;

  Map<String, dynamic> getDataMap() {
    return {
      "name": name,
      "surname": surname,
      "mail": mail,
      "phone": phone,
      "picture": picture,
    };
  }
}
