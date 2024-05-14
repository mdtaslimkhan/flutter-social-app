package com.chatting.chat_app;

import android.app.Service;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.os.Build;
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
import com.chatting.chat_app.floating_item.Floatcall;

public class CallServices extends Service {

    WindowManager wm;
    LinearLayout nll, nll2;
    Button receive, cancel;
    View mFloatingView;
    private NotificationManagerCompat managerCompat;
    private NotificationTarget notificationTarget;
    String fromId,receiverId,receiverImage,receiverName;
    RelativeLayout relativeLayout;
    ImageView imageview;
    TextView textView;

    public int onStartCommand(Intent intent, int flags, int startId) {

        fromId = intent.getStringExtra("fromId");
        receiverId = intent.getStringExtra("receiverId");
        receiverImage = intent.getStringExtra("receiverImage");
        receiverName = intent.getStringExtra("receiverName");


        // check if already window open for previous activity
        if(wm != null){
            wm.removeView(mFloatingView);
        }

        // custom layout
        mFloatingView = LayoutInflater.from(this).inflate(R.layout.call_minimize_floaticon, null);
        relativeLayout = mFloatingView.findViewById(R.id.floatingActionBtn);
        imageview = mFloatingView.findViewById(R.id.groupImage);
        textView = mFloatingView.findViewById(R.id.groupName);

        Glide.with(this.getApplicationContext())
                .asBitmap()
                .load(receiverImage)
                .into(imageview);
//        String subName = gName.substring(0,9);
//        textView.setText(subName);


        final WindowManager.LayoutParams params = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT, WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT);

        wm = (WindowManager) getSystemService(WINDOW_SERVICE);
        params.gravity = Gravity.CENTER;
        params.x = 50;
        params.y = 0;



        // Attach layout to window manager object
        wm.addView(mFloatingView, params);
        Floatcall.moveevent(wm,mFloatingView,params);



        relativeLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent home = new Intent(CallServices.this,MainActivity.class);
                home.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(home);
                Delegate.theMainActivity.onClickOnCallFloatingButton(fromId,receiverId);
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
