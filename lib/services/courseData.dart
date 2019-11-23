class CourseData {

  CourseData({this.depart,
    this.destination,
    this.retraitDate,
    this.deliveryDate,
    this.typeOfRemorque,
    this.typeOfMarchandise,
    this.userId,
    this.deliveryManId,
    this.completed});

  final String depart;
  final String destination;
  final DateTime retraitDate;
  final DateTime deliveryDate;
  final String typeOfMarchandise;
  final String typeOfRemorque;
  final String userId;
  final String deliveryManId;
  final bool completed;

  Map<String, dynamic> getCourseData() {
    return {
      'deliveryDate': deliveryDate,
      'depart': depart,
      'destination': destination,
      'retraitDate': retraitDate,
      'typeOfMarchandise': typeOfMarchandise,
      'typeOfRemorque': typeOfRemorque,
      'userId': userId,
      'deliveryManId': deliveryManId,
      'completed': completed
    };
  }
}