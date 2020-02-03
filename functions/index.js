const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();




exports.notifNewDelivery = functions.firestore.document('request/{requestId}').onCreate((snap, context) => {
    const newValue = snap.data();
    const t = newValue.test;
    console.log(newValue);
    console.log(t);

    const payload = {
        notification: { title: 'Notification test cloud functions', body: 'appuyer pour lancer l app', badge: '1', sound: 'default', }
    };

    // à chaque reinstallation de l'app le token change donc il doit etre redéfini
    const token ="cuUajTCsbf4:APA91bEzCg6fFMGEPAb8eH7jBWv8QtVRxKDNuNAOuh-S1rCxpHG_TQa5gp9gQiWkuUhc6cp4Lqk11cgFW7WVVGKu40iYH-c-zHZORoyj6VOzvY9XDVB4xMsCULdtxDbM3U2VL8mk6xHE";

    if (token) {
        console.log('Token is available .');
        return admin.messaging().sendToDevice(token, payload);
    } else {
        return console.log('token error');
    }

});

