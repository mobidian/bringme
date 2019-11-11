class CourseData {

  CourseData({this.depart,
    this.destination,
    this.retraitTime,
    this.deliveryTime,
    this.typeOfRemorque,
    this.typeOfMarchandise,
    this.userId,
    this.deliveryManId,
    this.completed});

  final String depart;
  final String destination;
  final String retraitTime;
  final String deliveryTime;
  final String typeOfMarchandise;
  final String typeOfRemorque;
  final String userId;
  final String deliveryManId;
  final bool completed;

  Map<String, dynamic> getCourseData() {
    return {
      'deliveryTime':deliveryTime,
      'depart': depart,
      'destination': destination,
      'retraitTime': retraitTime,
      'typeOfMarchandise': typeOfMarchandise,
      'typeOfRemorque': typeOfRemorque,
      'userId': userId,
      'deliveryManId': deliveryManId,
      'completed': completed
    };
  }
}