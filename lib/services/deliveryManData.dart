class DeliveryManData {
  DeliveryManData(
      {this.name,
        this.surname,
        this.mail,
        this.phone});

  final String name;
  final String surname;
  final String mail;
  final String phone;


  Map<String,dynamic> getDataMap(){
    return {
      "name":name,
      "surname": surname,
      "mail": mail,
      "phone": phone,
    };
  }
}
