class DeliveryManData {
  DeliveryManData(
      {this.name,
        this.surname,
        this.mail,
        this.phone,
      this.typeOfRemorque});

  final String name;
  final String surname;
  final String mail;
  final String phone;
  final String typeOfRemorque;


  Map<String,dynamic> getDataMap(){
    return {
      "name":name,
      "surname": surname,
      "mail": mail,
      "phone": phone,
      "typeOfRemorque" : typeOfRemorque
    };
  }
}
