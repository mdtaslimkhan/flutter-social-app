package com.chatting.chat_app;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.NotificationTarget;

public class IncomingCallsScreen extends Service {

    WindowManager wm;
    LinearLayout nll, nll2;
    Button receive, cancel;
    View mFloatingView;
    private NotificationManagerCompat managerCompat;
    private NotificationTarget notificationTarget;
    String fromId,receiverId,receiverImage,receiverName,call_type;
    RelativeLayout relativeLayout;
    ImageView receiverImageView, receiverFullImage;
    TextView callerName;
    Button rejectCall, acceptCall;
    Context mctx;


    public int onStartCommand(Intent intent, int flags, int startId) {

        fromId = intent.getStringExtra("fromId");
        receiverId = intent.getStringExtra("receiverId");
        receiverImage = intent.getStringExtra("receiverImage");
        receiverName = intent.getStringExtra("receiverName");
        call_type = intent.getStringExtra("call_type");


        // check if already window open for previous activity
        if(wm != null){
            wm.removeView(mFloatingView);
        }

        // custom layout
        mFloatingView = LayoutInflater.from(this).inflate(R.layout.incoming_call_screen, null);
        callerName = mFloatingView.findViewById(R.id.callerName);
        receiverImageView = mFloatingView.findViewById(R.id.receiverImage);
        rejectCall = mFloatingView.findViewById(R.id.rejectCall);
        acceptCall = mFloatingView.findViewById(R.id.acceptCall);
        receiverFullImage = mFloatingView.findViewById(R.id.receiverFullImage);
        callerName.setText(receiverName);

        Glide.with(this.getApplicationContext())
                .asBitmap()
                .load(receiverImage)
                .into(receiverImageView);
//        String subName = gName.substring(0,9);
//        textView.setText(subName);



        final WindowManager.LayoutParams params = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT);

        wm = (WindowManager) getSystemService(WINDOW_SERVICE);
        params.gravity = Gravity.TOP;
        params.x = 0;
        params.y = 0;



        // Attach layout to window manager object
        wm.addView(mFloatingView, params);



        acceptCall.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String type = "1";
                Intent home = new Intent(IncomingCallsScreen.this,MainActivity.class);
                home.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(home);
                Delegate.theMainActivity.onClickOnIncomingCallScreens(fromId,receiverId,receiverName,type, call_type);
                RingTonPlayOnCall.ringtonPlay(getApplicationContext()).stop();

                if(wm != null) {
                    wm.removeView(mFloatingView);
                }

            }
        });

        rejectCall.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String type = "0";
                Intent home = new Intent(IncomingCallsScreen.this,MainActivity.class);
                home.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(home);
                Delegate.theMainActivity.onClickOnIncomingCallScreens(fromId,receiverId,receiverName, type, call_type);
                RingTonPlayOnCall.ringtonPlay(getApplicationContext()).stop();
                if(wm != null) {
                    wm.removeView(mFloatingView);
                }
            }
        });



        return START_NOT_STICKY;

    }

    @Override
    public void onCreate() {
        super.onCreate();

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
//            RemoteViews remoteViews = new RemoteViews(this.getPackageName(), R.layout.notification_collapse);
//            remoteViews.setTextViewText(R.id.notificationCollapseTitleId, "CR");
//            remoteViews.setTextViewText(R.id.notificationCollapseDescriptionId,"Incoming call...");
//
//            Intent mainActivityIntent;
//            mainActivityIntent = new Intent(this , MainActivity.class);
//            mainActivityIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
//            PendingIntent contentIntent = PendingIntent.getActivity(this,0,mainActivityIntent, PendingIntent.FLAG_ONE_SHOT);
//
            NotificationCompat.Builder builder = new NotificationCompat.Builder(this, MyApplication.CHANNEL_3_ID)
                    .setSmallIcon(R.drawable.ic_call);
//                     .setContentTitle("Incoming call")
//                     .setContentText("Call description");
//                    .setContentIntent(contentIntent)
//                    .setCustomContentView(remoteViews);
            startForeground(101,builder.build());
        }

        // custom notification

//        final WindowManager.LayoutParams wmlp = new WindowManager.LayoutParams(
//                WindowManager.LayoutParams.MATCH_PARENT,WindowManager.LayoutParams.WRAP_CONTENT,
//                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
//                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
//                PixelFormat.TRANSLUCENT);
//        wmlp.gravity = Gravity.TOP;
//        wmlp.x = 0;
//        wmlp.y = 0;
//
//
//        nll2 = Floatcall.notificationStyle1(this);
//        wm.addView(nll2, wmlp);
//        Floatcall.moveevent(wm,nll2,wmlp);





    }



    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }



    @Override
    public void onDestroy() {
        super.onDestroy();
        stopSelf();
        if(wm != null) {
            wm.removeView(mFloatingView);
        }
    }












}
