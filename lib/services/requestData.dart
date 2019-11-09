

class RequestData{
 RequestData({
   this.depart,
   this.destination,
   this.retraitTime,
   this.deliveryTime,
   this.typeOfMarchandise,
   this.typeOfRemorque,
   this.userId,
   this.accepted,
   this.completed,
   this.proposition
});

 final String depart;
 final String destination;
 final String retraitTime;
 final String deliveryTime;
 final String typeOfMarchandise;
 final String typeOfRemorque;
 final String userId;

 //champs pour les demandes sotckées chez le user et non pas display à tout le monde
 final bool completed;
 final bool accepted;
 final List<dynamic> proposition;

 Map<String,dynamic> getDataMap(){
   return {
     "depart": depart,
     "destination": destination,
     "retraitTime": retraitTime,
     "deliveryTime": deliveryTime,
     "typeOfMarchandise": typeOfMarchandise,
     "typeOfRemorque": typeOfRemorque,
     "userId": userId
   };
 }

 Map<String, dynamic> getDataMapForDemand(){
   return {
     "depart": depart,
     "destination": destination,
     "retraitTime": retraitTime,
     "deliveryTime": deliveryTime,
     "typeOfMarchandise": typeOfMarchandise,
     "typeOfRemorque": typeOfRemorque,
     "userId": userId,
     "completed": completed,
     "accepted": accepted,
     "proposition": proposition
   };
 }

}