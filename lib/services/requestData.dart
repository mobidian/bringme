

class RequestData{
 RequestData({
   this.depart,
   this.destination,
   this.retraitDate,
   this.deliveryDate,
   this.typeOfMarchandise,
   this.typeOfRemorque,
   this.userId,
   this.accepted,
   this.completed,
   this.proposition
});

 final String depart;
 final String destination;
 final DateTime retraitDate;
 final DateTime deliveryDate;
 final Map<String, dynamic> typeOfMarchandise;
 final Map<String, dynamic> typeOfRemorque;
 final String userId;

 //champs pour les demandes sotckées chez le user et non pas display à tout le monde
 final bool completed;
 final bool accepted;
 final List<dynamic> proposition;

 Map<String,dynamic> getDataMap(){
   return {
     "depart": depart,
     "destination": destination,
     "retraitDate": retraitDate,
     "deliveryDate": deliveryDate,
     "typeOfMarchandise": typeOfMarchandise,
     "typeOfRemorque": typeOfRemorque,
     "userId": userId
   };
 }

 Map<String, dynamic> getDataMapForDemand(){
   return {
     "depart": depart,
     "destination": destination,
     "retraitDate": retraitDate,
     "deliveryDate": deliveryDate,
     "typeOfMarchandise": typeOfMarchandise,
     "typeOfRemorque": typeOfRemorque,
     "userId": userId,
     "completed": completed,
     "accepted": accepted,
     "proposition": proposition
   };
 }

}