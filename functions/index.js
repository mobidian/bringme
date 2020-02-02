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
    const token ="chieMlcYKN8:APA91bF1K_nuPXGPXWdMXLfT7ETcEQdAE64cO1Q7KpA1sK1wVrjTpTr_HaPCPtXOuhIQ1Gq8J9wMCMuHCaLC3wpFNd28117SAUXImWXa5z_ODYGdS5gjcRawNBjqcY6I21lES1Cgsh1c";

    if (token) {
        console.log('Token is available .');
        return admin.messaging().sendToDevice(token, payload);
    } else {
        return console.log('token error');
    }

});

