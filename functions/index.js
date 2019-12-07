const functions = require('firebase-functions');
const admin = require('firebase-admin');
var firebase = require("firebase/app");
var config = require('./src/config');



// Add the Firebase products that you want to use
require("firebase/auth");
require("firebase/firestore");

firebase.initializeApp(config.api());
admin.initializeApp();

var db = admin.firestore();

// exports.helloWorld = functions.https.onRequest((request, response) => {
//     response.send("Hello from Firebase!");
// });


exports.sendQuizNotifi = functions.firestore
    .document('quiz/{quizId}')
    .onCreate(async snapshot => {


        const quiz = snapshot.data();
        const querySnapshot = await db.collection('tokens').where('quizNotification','==',true).get();
        const getTokens = querySnapshot.docs.map(snap => snap.data().token);

        const message = {
            notification: {
                title: 'Quiz Will be on ',
                body: quiz.startTime.toDate().toLocaleString('ko-KR', {timeZone: "Asia/Seoul"}),
            },
            tokens: getTokens
        };

        admin.messaging().sendMulticast(message)
            .then((response) => {
                // Response is a message ID string.
                console.log('Successfully sent message:', response);
                return null;
            })
            .catch((error) => {
                console.log('Error sending message:', error);
                throw new Error("Profile doesn't exist");
            });
    });

exports.sendNoticeNotifi = functions.firestore
    .document('notice/{noticeId}')
    .onCreate(async snapshot => {


        const notice = snapshot.data();
        const querySnapshot = await db.collection('tokens').where('noticeNotification','==',true).get();
        const getTokens = querySnapshot.docs.map(snap => snap.data().token);


        const message = {
            notification: {
                title: notice.title,
                body: notice.description,
            },
            tokens: getTokens
        };

        admin.messaging().sendMulticast(message)
            .then((response) => {
                // Response is a message ID string.
                console.log('Successfully sent message:', response);
                return null;
            })
            .catch((error) => {
                console.log('Error sending message:', error);
                throw new Error("Profile doesn't exist");
            });
    });

exports.sendQuestionNotifi = functions.firestore
    .document('question/{questionId}')
    .onCreate(async snapshot => {


        const question = snapshot.data();
        const querySnapshot = await db.collection('tokens').where('questionNotification','==',true).get();
        const getTokens = querySnapshot.docs.map(snap => snap.data().token);


        const message = {
            notification: {
                title: "New Question !",
                body: question.title,
            },
            tokens: getTokens
        };

        admin.messaging().sendMulticast(message)
            .then((response) => {
                // Response is a message ID string.
                console.log('Successfully sent message:', response);
                return null;
            })
            .catch((error) => {
                console.log('Error sending message:', error);
                throw new Error("Profile doesn't exist");
            });
    });

exports.sendAnswerNotifi2Participants = functions.firestore
    .document('question/{questionId}/reply/{replyID}')
    .onCreate(async snapshot => {

        const answer = snapshot.data();
        const querySnapshot = await db.collection('question/'+answer.question+'/participants').get();
        const getTokens = querySnapshot.docs.map(snap => snap.data().token);

        const test = await db.collection('question').doc(answer.question).get();




        const message = {
            notification: {
                title: "Reply for "+test.data().title,
                body: answer.title,
            },
            tokens: getTokens
        };

        admin.messaging().sendMulticast(message)
            .then((response) => {
                // Response is a message ID string.
                console.log('Successfully sent message:', response);
                return null;
            })
            .catch((error) => {
                console.log('Error sending message:', error);
                throw new Error("Profile doesn't exist");
            });

    });

// exports.sendAnswerNotifi2Questioner = functions.firestore
//     .document('answer/{answerId}')
//     .onCreate(async snapshot => {
//
//         const answer = snapshot.data();
//         const querySnapshot = await db.collection('tokens').get();
//         const getTokens = querySnapshot.docs.map(snap => snap.data().token);
//
//         const test = await db.collection('question').doc(answer.question).get();
//
//
//
//
//         const message = {
//             notification: {
//                 title: "Reply for "+test.data().title,
//                 body: answer.title,
//             },
//             tokens: getTokens
//         };
//
//         admin.messaging().sendMulticast(message)
//             .then((response) => {
//                 // Response is a message ID string.
//                 console.log('Successfully sent message:', response);
//                 return null;
//             })
//             .catch((error) => {
//                 console.log('Error sending message:', error);
//                 throw new Error("Profile doesn't exist");
//             });
//
//     });