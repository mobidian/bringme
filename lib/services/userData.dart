class UserData {
  UserData(
      {this.name,
        this.surname,
        this.mail,
        this.phone,
        this.sex});

  final String name;
  final String surname;
  final String mail;
  final String phone;
  final bool sex;


  Map<String,dynamic> getDataMap(){
    return {
      "name":name,
      "surname": surname,
      "mail": mail,
      "phone": phone,
    };
  }
}
