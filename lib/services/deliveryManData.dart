class DeliveryManData {
  DeliveryManData(
      {this.name,
      this.surname,
      this.mail,
      this.phone,
      this.typeOfRemorque,
      this.immatriculation,
      this.marque,
      this.picture});

  final String name;
  final String surname;
  final String mail;
  final String phone;
  final String typeOfRemorque;
  final String immatriculation;
  final String marque;
  final String picture;

  Map<String, dynamic> getDataMap() {
    return {
      "name": name,
      "surname": surname,
      "mail": mail,
      "phone": phone,
      "typeOfRemorque": typeOfRemorque,
      "immatriculation": immatriculation,
      "marque": marque,
      "picture": picture,
    };
  }
}
