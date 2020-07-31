const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.myFunction = functions.firestore
  .document('newsfeed/{message}')
  .onCreate((snapshot, context) => {
    return admin.messaging().sendToTopic('chat', {
      notification: {
        title: 'New post is added',
        body: $snapshot.data().name +'Uploaded new post, Go an check out!!',
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      },
    });
  });
