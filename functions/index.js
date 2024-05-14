const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();


const sleep = require('util').promisify(setTimeout)

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

//exports.onCreateGift = functions.firestore
//                .docs("/bigGroups/{groupId}/hotGift/{giftId}")
//                .onCreate((snapshot, context) => {
//                  const groupId = context.params.groupId;
//                  const giftId = context.params.giftId;
//                  console.log(`this is gorup id ${groupId} and this is gift id ${giftId}`);
//
//                   const groupGiftRef = admin.database
//                   .collection('bigGroups')
//                   .docs(groupId)
//                   .collection("mentions")
//                   .add(snapshot.docs.data());
//                });,/


exports.onCreateGiftByUser = functions.firestore
                .document("/bigGroups/{groupId}/giftType/{typeId}")
                .onCreate(async (snap, context) => {
                  const groupId = context.params.groupId;
                  const typeId = context.params.typeId;

                //  const newValue = snap.data();
                console.log(`thisd is gorup id ${groupId} and thisd is gift id ${typeId}`);
                console.log(snap.data());
                  // access a particular field as you would any JS property
                //  const name = newValue.name;

                  const groupGiftRef = await db
                        .collection('bigGroups')
                        .doc(groupId)
                        .collection("showGift")
                        .add(snap.data());


                   await sleep(3000);
                   // setTimeout(function(){
                      const itemDeleted = db
                     .collection('bigGroups')
                     .doc(groupId)
                     .collection("showGift").listDocuments().then(val => {
                           val.map((val) => {
                               val.delete()
                           })
                   })
              //   }, 15000);



                  // perform desired operations ...
    });

                  // auto delete all group call every 2 hours
exports.scheduledFunction = functions.pubsub.schedule('0 */2 * * *')
            .onRun((context) => {
            db.collection("bigGroupCall").listDocuments().then(val => {
              val.map((dt) => {
                dt.delete();

                   db
                    .collection("bigGroups").listDocuments().then(groupInfo => {
                      groupInfo.map((dts) => {
                      if(dts.id == dt.id){
                         dts.collection("hostId").listDocuments().then(m => {
                          m.map((mt) => {
                            mt.delete();
                          });
                         });
                        }
                      })
                  });

                  db
                  .collection("bigGroups").listDocuments().then(groupInfo => {
                    groupInfo.map((dts) => {
                    if(dts.id == dt.id){
                       dts.collection("hostSeat").listDocuments().then(m => {
                        m.map((mt) => {
                          mt.delete();
                        });
                       });
                      }
                    })
                });

                db
                .collection("bigGroups").listDocuments().then(groupInfo => {
                  groupInfo.map((dts) => {
                  if(dts.id == dt.id){
                     dts.collection("userGiftSent").listDocuments().then(m => {
                      m.map((mt) => {
                        mt.delete();
                      });
                     });
                    }
                  })
              });

              db
                .collection("bigGroups").listDocuments().then(groupInfo => {
                  groupInfo.map((dts) => {
                  if(dts.id == dt.id){
                     dts.collection("userGiftSentAll").listDocuments().then(m => {
                      m.map((mt) => {
                        mt.delete();
                      });
                     });
                    }
                  })
              });

              db
                .collection("bigGroups").listDocuments().then(groupInfo => {
                  groupInfo.map((dts) => {
                  if(dts.id == dt.id){
                     dts.collection("waitingList").listDocuments().then(m => {
                      m.map((mt) => {
                        mt.delete();
                      });
                     });
                    }
                  })
              });

              });
            });


            });

exports.addUserToVoiceRoomByTappingSeat = functions.https.onRequest((req, res) =>{
    // const number = Math.round(Math.random() * 100);
     console.log('random math');
    // console.log(number);
  });

   exports.onLeavingHotSeatByUser = functions.firestore
              .document("/bigGroups/{groupId}/hotSeat/{userId}")
              .onDelete(async (snap, context) => {
                const groupId = context.params.groupId;
                const userId = context.params.userId;
                console.log(groupId);
                console.log(userId);
      });

  exports.hotSeatCount = functions.firestore
              .document("/bigGroups/{groupId}/hotSeat/{userId}")
              .onDelete(async (snap, context) => {
                const groupId = context.params.groupId;
                const userId = context.params.userId;

              var user = await db.collection("bigGroups").doc(groupId).collection("hotSeat").get();
              if(user.size < 9){
                var allSeat = [];
              //  var position = [];
                 for(var i = 2; i < 10; i++){
                     allSeat.push(i);
                  }
                // add positions item to position list from the active hot seat users
                 user.forEach(function(item) {
                  //  position.push(item.id);
                    allSeat = allSeat.filter(item => item !== item.data()['position']);
                });
                await db.collection("bigGroups").doc(groupId)
                  .collection("waitingList")
                  .orderBy("pos", "asc")
                  .limit(1)
                  .get()
                  .then(async snap => {
                      if (!snap.empty) {
                          //We know there is one doc in the querySnapshot
                          const qs = snap.docs[0].data();
                          await db.collection("bigGroups").doc(groupId)
                              .collection("waitingList")
                              .doc(qs['userId'])
                              .delete()
                              .then(function() {
                                  console.log("Document successfully deleted!");
                              }).catch(function(error) {
                                  console.error("Error removing document: ", error);
                              });

                          var rand = allSeat[(Math.random() * allSeat.length) | 0];

                         await db.collection("bigGroups").doc(groupId)
                            .collection("hotSeat").doc(qs['userId']).set({
                             'position' : rand,
                             'userId': qs['userId'],
                             'photo': qs['photo'],
                             'mute': false,
                             'name': qs['name'],
                             'timeStamp': qs['timeStamp']
                            })
                            console.log("============================ result deleted =====>>>>>>>>>>>>>>>>>>>>>>>>>");
                            return null;
                      }else{
                          console.log("No document corresponding to the query!");
                          return null;
                      }
                  });

              }

      });

      exports.onDeleteGroup = functions.firestore
                    .document("/bigGroupMessage/{groupId}/messages/{messageId}")
                    .onDelete(async (snap, context) => {
                      const groupId = context.params.groupId;
                      const messageId = context.params.messageId;
                        console.log(snap.data());
                        console.log(groupId);
                        console.log(messageId);
                      // get all group members to delete contacts
//                      var user = await db.collection("bigGroups")
//                      .doc(groupId)
//                      .collection("members")
//                      .get();
//
//                      user.forEach(function(item) {
//                         console.log(item.data());
//                      });

//                      await db.collection("bigGroups")
//                      .doc(groupId)
//                      .delete();

            });



                        exports.onCreateGroup = functions.firestore
                                        .document("/bigGroupMessage/{groupId}/messages/{messageId}")
                                        .onDelete(async (snap, context) => {
                                          const groupId = context.params.groupId;
                                          const messageId = context.params.messageId;

                                        //  const newValue = snap.data();
                                        console.log(snap.data());
                                        console.log(groupId);
                                        console.log(messageId);

                            });



