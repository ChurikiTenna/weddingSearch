import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

// データベースの参照を作成
const firestore: admin.firestore.Firestore = admin.firestore();
const functionFirestore = functions.region('asia-northeast1').firestore;

const pushMessage = 
(fcmToken: string, title: string, content: string, badges: any) => ({
  notification: {
    title: `${title}`,
    body: `${content}`,
  },
  token: fcmToken,
  apns: {
    payload: {
      aps: {
        badge: badges,
      },
    },
  },
});

export const onNotificationCreate = functionFirestore
    .document("users/{uid}/notifications/{notificationId}")
    .onCreate(async (snapshot, context) => {
        const notification = snapshot.data();
        
        // 通知を送る相手を取得
        //console.log("receiverID", context.params.uid)
        const receiverRef = firestore.collection('users').doc(context.params.uid);
        const receiver = await receiverRef.get()
        const receiverData = receiver.data()
        console.log("receiverData", receiverData?.name)
        if (!receiverData) return

        // アイコンの右上のバッジに表示される数を取得
        const receiverNotificationRef = receiverRef.collection('notifications')
        const receiverNotifications = await receiverNotificationRef.where("read", "==", false).limit(100).get()
        let unreadCount = receiverNotifications.docs.length
        
        admin.messaging()
            .send(pushMessage(receiverData.token, "", notification.message, unreadCount))
            .then((response) => {
                console.log("Successfully sent message:", response);
            })
            .catch((e) => {
                console.log("Error sending message:", e);
            });
    });
