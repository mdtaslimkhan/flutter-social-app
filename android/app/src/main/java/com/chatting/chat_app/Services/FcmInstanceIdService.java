package com.chatting.chat_app.Services;

import android.app.Notification;
import android.app.PendingIntent;
import android.content.Intent;
import android.graphics.Color;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.util.Log;
import android.widget.RemoteViews;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.NotificationTarget;


import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;


import com.chatting.chat_app.IncomingCallsScreen;
import com.chatting.chat_app.MainActivity;
import com.chatting.chat_app.RingTonPlayOnCall;
import com.chatting.chat_app.MyApplication;
import com.chatting.chat_app.MyService;
import com.chatting.chat_app.R;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import static android.app.PendingIntent.FLAG_IMMUTABLE;


public class FcmInstanceIdService extends FirebaseMessagingService {

    private NotificationManagerCompat managerCompat;
    public static final String INTENT_FILTER = "INTENT_FILTER";
    private NotificationTarget notificationTarget;

    public static String mtitle = "from fcm";


    @Override
    public void onNewToken(String s) {
        Log.e("NEW_TOKEN", s);
    }

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);
        managerCompat = NotificationManagerCompat.from(this);

       if(Integer.parseInt(remoteMessage.getData().get("channel")) == 4){
            int notificationId = 1;
            notificationId = Integer.parseInt(remoteMessage.getData().get("set_id"));


            Intent homePage = new Intent(this, MainActivity.class);
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                homePage.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            }
            this.startActivity(homePage);

            RemoteViews remoteViews = new RemoteViews(this.getPackageName(), R.layout.notification_collapse);
            remoteViews.setTextViewText(R.id.notificationCollapseTitleId, remoteMessage.getData().get("title"));
            remoteViews.setTextViewText(R.id.notificationCollapseDescriptionId, remoteMessage.getData().get("message"));
            Intent mainActivityIntent;

            mainActivityIntent = new Intent(this , MainActivity.class);
            mainActivityIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            mainActivityIntent.putExtra("message",1);
            mainActivityIntent.putExtra("id",1);

           PendingIntent contentIntent;
           if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
               contentIntent = PendingIntent.getActivity(this,
                       0, mainActivityIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
           }else {
               contentIntent = PendingIntent.getActivity(this,
                       0, mainActivityIntent, PendingIntent.FLAG_UPDATE_CURRENT);
           }

            Notification notification = new NotificationCompat.Builder(this, MyApplication.CHANNEL_1_ID)
                    .setSmallIcon(R.drawable.ic_status_icon)
                    .setTicker("Call status")
                    .setCustomContentView(remoteViews)
                    .setPriority(NotificationCompat.PRIORITY_HIGH)
                    .setCategory(NotificationCompat.CATEGORY_CALL)
                    .setColor(Color.BLUE)
                    .setOnlyAlertOnce(true)
                    .setAutoCancel(true)
                    .setContentIntent(contentIntent)
                    .setFullScreenIntent(contentIntent,true)
                    .build();



            // notification sound

//            notification.sound = Uri.parse("android.resource://" + getPackageName() + "/" + R.raw.phone_loud1);
//            notification.defaults |= Notification.DEFAULT_VIBRATE;


            managerCompat.notify(notificationId, notification);

            // set target id for loading image
            notificationTarget = new NotificationTarget(
                    this,
                    R.id.notificationCollapseImageId,
                    remoteViews,
                    notification,
                    notificationId);

            Glide.with(this.getApplicationContext())
                    .asBitmap()
                    .load(remoteMessage.getData().get("photo"))
                    .into(notificationTarget);


            // send notification to broadcast receiver
           // to run any function direct in main activity
           // to run function in index page in flutter
            Intent intent = new Intent(INTENT_FILTER);
            intent.putExtra("startCall",1);
            sendBroadcast(intent);

          // RingTonPlayOnCall.mediyaPlayStart(this).start();
           
           RingTonPlayOnCall.ringtonPlay(this).play();

          //  showing floating items mice and custom over apps notification
//           if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//               startForegroundService(new Intent(FcmInstanceIdService.this, IncomingCallsScreen.class));
//           }else{
//               startService(new Intent(FcmInstanceIdService.this, IncomingCallsScreen.class));
//           }
           if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
               Intent serviceIntent = new Intent(FcmInstanceIdService.this, IncomingCallsScreen.class);
               serviceIntent.putExtra("fromId", remoteMessage.getData().get("sernder_id"));
               serviceIntent.putExtra("receiverId", remoteMessage.getData().get("receiver_id"));
               serviceIntent.putExtra("receiverImage", remoteMessage.getData().get("photo"));
               serviceIntent.putExtra("receiverName", remoteMessage.getData().get("message"));
               serviceIntent.putExtra("call_type", remoteMessage.getData().get("call_type"));
               startForegroundService(serviceIntent);
           }else{
               Intent serviceIntent = new Intent(FcmInstanceIdService.this, IncomingCallsScreen.class);
               serviceIntent.putExtra("fromId", remoteMessage.getData().get("sernder_id"));
               serviceIntent.putExtra("receiverId", remoteMessage.getData().get("receiver_id"));
               serviceIntent.putExtra("receiverImage", remoteMessage.getData().get("photo"));
               serviceIntent.putExtra("receiverName", remoteMessage.getData().get("message"));
               serviceIntent.putExtra("call_type", remoteMessage.getData().get("call_type"));
               startService(serviceIntent);
               //  startService(new Intent(MainActivity.this, MyService.class));
           }





        }

        if(Integer.parseInt(remoteMessage.getData().get("channel")) == 2) {
            int notificationId = 2;
            notificationId = Integer.parseInt(remoteMessage.getData().get("set_id"));

            Intent fullScreenIntent = new Intent(this, MainActivity.class);

            PendingIntent fullScreenPendingIntent;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                fullScreenPendingIntent = PendingIntent.getActivity(this,
                        0, fullScreenIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
            }else {
                fullScreenPendingIntent = PendingIntent.getActivity(this,
                        0, fullScreenIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            }

            NotificationCompat.Builder notificationBuilder =
                    new NotificationCompat.Builder(this, MyApplication.CHANNEL_1_ID)
                            .setSmallIcon(R.drawable.ic_status_icon)
                            .setContentTitle("Incoming call")
                            .setContentText("(919) 555-1234")
                            .setPriority(NotificationCompat.PRIORITY_HIGH)
                            .setCategory(NotificationCompat.CATEGORY_CALL)
                            .setFullScreenIntent(fullScreenPendingIntent, true);

            Notification incomingCallNotification = notificationBuilder.build();

             managerCompat.notify(notificationId, incomingCallNotification);

          //  RingTonPlayOnCall.mediyaPlayStart(this).start();
            RingTonPlayOnCall.ringtonPlay(this).play();



        }

        if(Integer.parseInt(remoteMessage.getData().get("channel")) == 1) {
            int notificationId = 1;
            notificationId = Integer.parseInt(remoteMessage.getData().get("set_id"));

          //  RingTonPlayOnCall.mediyaPlayStart(this).stop();
            RingTonPlayOnCall.ringtonPlay(this).stop();
            stopService(new Intent(FcmInstanceIdService.this, MyService.class));
            stopService(new Intent(FcmInstanceIdService.this, IncomingCallsScreen.class));

        }



        if(Integer.parseInt(remoteMessage.getData().get("channel")) == 5){
            int notificationId = 1;
            notificationId = Integer.parseInt(remoteMessage.getData().get("set_id"));


            RemoteViews remoteViews = new RemoteViews(this.getPackageName(), R.layout.voiceroom_notification);
            remoteViews.setTextViewText(R.id.notificationCollapseTitleId, remoteMessage.getData().get("title"));
            remoteViews.setTextViewText(R.id.notificationCollapseDescriptionId, remoteMessage.getData().get("message"));
            Intent mainActivityIntent;

            mainActivityIntent = new Intent(this , MainActivity.class);
            mainActivityIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            mainActivityIntent.putExtra("groupId", remoteMessage.getData().get("groupId"));
            mainActivityIntent.putExtra("userId", remoteMessage.getData().get("userId"));

            PendingIntent contentIntent;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                contentIntent = PendingIntent.getActivity(this,
                        0, mainActivityIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
            }else {
                contentIntent = PendingIntent.getActivity(this,
                        0, mainActivityIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            }




            Notification notification = new NotificationCompat.Builder(this, MyApplication.CHANNEL_2_ID)
                    .setSmallIcon(R.drawable.ic_status_icon)
                    .setCustomContentView(remoteViews)
                    .setPriority(NotificationCompat.PRIORITY_HIGH)
                    .setCategory(NotificationCompat.CATEGORY_CALL)
                    .setColor(Color.BLUE)
                    .setOnlyAlertOnce(true)
                    .setAutoCancel(true)
                    .setContentIntent(contentIntent)
                    .build();
            

            managerCompat.notify(notificationId, notification);

            // set target id for loading image
            notificationTarget = new NotificationTarget(
                    this,
                    R.id.notificationCollapseImageId,
                    remoteViews,
                    notification,
                    notificationId);

            Glide.with(this.getApplicationContext())
                    .asBitmap()
                    .load(remoteMessage.getData().get("photo"))
                    .into(notificationTarget);

        }

        if(Integer.parseInt(remoteMessage.getData().get("channel")) == 6) {

            int notificationId = 1;

            notificationId = Integer.parseInt(remoteMessage.getData().get("set_id"));

            Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);

            Intent mainActivityIntent = new Intent(this, MainActivity.class);
            mainActivityIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);

            PendingIntent contentIntent;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                contentIntent = PendingIntent.getActivity(this,
                        0, mainActivityIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
            }else {
                contentIntent = PendingIntent.getActivity(this,
                        0, mainActivityIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            }

            Notification notification = new NotificationCompat.Builder(this, MyApplication.CHANNEL_6_ID)
                    .setSmallIcon(R.drawable.ic_status_icon)
                    .setContentTitle(remoteMessage.getData().get("title"))
                    .setContentText(remoteMessage.getData().get("message"))
                    .setSound(defaultSoundUri)
                    .setPriority(NotificationCompat.PRIORITY_HIGH)
                    .setCategory(NotificationCompat.CATEGORY_MESSAGE)
                    .setColor(Color.BLUE)
                    .setAutoCancel(true)
                    .setOnlyAlertOnce(true)
                    .setContentIntent(contentIntent)
                    .build();

            managerCompat.notify(notificationId, notification);



        }



        
        

        }






}
