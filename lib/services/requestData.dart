

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
   this.proposition,
   this.description
});

 final String depart;
 final String destination;
 final DateTime retraitDate;
 final DateTime deliveryDate;
 final Map<String, dynamic> typeOfMarchandise;
 final Map<String, dynamic> typeOfRemorque;
 final String userId;
 final String description;

 //champs pour les demandes stockées chez le user et non pas display à tout le monde
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
     "userId": userId,
     "description": description,
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
     "proposition": proposition,
     "description": description,
   };
 }

}