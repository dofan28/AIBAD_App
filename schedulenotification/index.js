// const functions = require("firebase-functions");
// const admin = require("firebase-admin");
// const {log} = require("firebase-functions/logger");
// const cors = require("cors")({origin: true});

// admin.initializeApp({
//   credential: admin.credential.cert(require("./serviceAccountkey.json")),
//   databaseURL: "https://your-database-url.firebaseio.com",
// });

// function compareTime(date1, date2) {
//   const hours1 = date1.getHours();
//   const minutes1 = date1.getMinutes();

//   const hours2 = date2.getHours();
//   const minutes2 = date2.getMinutes();

//   return hours1 === hours2 && minutes1 === minutes2;
// }

// async function getNextQuote(userId) {
//   const quotesSnapshot = await admin.firestore()
//       .collection("userMetaData")
//       .doc(userId)
//       .collection("quotes")
//       .orderBy("timestamp", "desc")
//       .limit(1)
//       .get();

//   if (quotesSnapshot.empty) {
//     console.log(`No quotes found for user: ${userId}`);
//     return null;
//   }

//   const quoteDoc = quotesSnapshot.docs[0];
//   const quoteData = quoteDoc.data();
//   let nextQuote = null;
//   let updatedQuotes = quoteData.quotes.map((quoteObj) => {
//     if (!quoteObj.used && !nextQuote) {
//       quoteObj.used = true;
//       nextQuote = quoteObj.quote;
//     }
//     return quoteObj;
//   });

//   if (!nextQuote) {
//     // If no unused quote found, reset all to unused and take the first one
//     updatedQuotes = updatedQuotes.map((quoteObj) => {
//       quoteObj.used = false;
//       return quoteObj;
//     });
//     nextQuote = updatedQuotes[0].quote;
//     updatedQuotes[0].used = true;
//   }

//   // Update Firestore with new `used` statuses
//   await quoteDoc.ref.update({quotes: updatedQuotes});
//   return nextQuote;
// }

// exports.saveToken = functions.https.onRequest((req, res) => {
//   cors(req, res, () => {
//     const userId = req.body.userId;
//     const token = req.body.token;
//     console.log(`Received token: ${token} for user: ${userId}`);

//     return admin
//         .firestore()
//         .collection("userTokens")
//         .doc(userId)
//         .set(
//             {
//               token: token,
//             },
//             {merge: true},
//         )
//         .then(() => {
//           console.log(`Token saved successfully for user: ${userId}`);
//           res.status(200).send("Token saved successfully");
//         })
//         .catch((error) => {
//           console.error("Error saving token:", error);
//           res.status(500).send("Error saving token");
//         });
//   });
// });

// exports.sendScheduledNotification = functions.pubsub
//     .schedule("every 1 minutes")
//     .timeZone("Asia/Jakarta")
//     .onRun(async (context) => {
//       console.log("Running sendScheduledNotification at:", new Date().toISOString());
//       const today = new Date();

//       try {
//         const scheduleSnapshots = await admin.firestore().collection("schedules").get();
//         if (scheduleSnapshots.empty) {
//           console.log("No schedules found");
//           return null;
//         }

//         scheduleSnapshots.forEach(async (doc) => {
//           const scheduleData = doc.data();
//           if (scheduleData.time && scheduleData.time.toDate) {
//             const schedule = scheduleData.time.toDate();
//             const userId = scheduleData.userId;
//             const userTokenDoc = await admin.firestore().collection("userTokens").doc(userId).get();
//             const token = userTokenDoc.exists ? userTokenDoc.data().token : null;

//             if (schedule && compareTime(schedule, today) && token) {
//               const quote = await getNextQuote(userId);

//               if (!quote) {
//                 console.log(`No valid quote found for user: ${userId}`);
//                 return;
//               }

//               const payload = {
//                 token: token,
//                 notification: {
//                   title: "Quote Harian",
//                   body: quote,
//                 },
//               };

//               log("Notification payload:", payload);

//               admin.messaging().send(payload)
//                   .then((response) => {
//                     console.log("Notification sent successfully to:", token);
//                   })
//                   .catch((error) => {
//                     console.error("Error sending notification to:", token, error);
//                   });
//             } else {
//               log("Didn't send, because schedule or token is null. Schedule is: ", schedule);
//               log("Today is ", today);
//               log("Token is: ", token);
//               log("User id is: ", userId);
//             }
//           } else {
//             console.error("Schedule time is not a valid Timestamp:", scheduleData.time);
//           }
//         });
//       } catch (error) {
//         console.error("Error getting schedules or sending notifications:", error);
//       }

//       return null;
//     });
