class DeliveryManData {
  DeliveryManData(
      {this.name,
        this.surname,
        this.mail,
        this.phone,
      this.typeOfRemorque,
      this.immatriculation,
      this.marque});

  final String name;
  final String surname;
  final String mail;
  final String phone;
  final String typeOfRemorque;
  final String immatriculation;
  final String marque;


  Map<String,dynamic> getDataMap(){
    return {
      "name":name,
      "surname": surname,
      "mail": mail,
      "phone": phone,
      "typeOfRemorque" : typeOfRemorque,
      "immatriculation" : immatriculation,
      "marque" : marque,
    };
  }
}
