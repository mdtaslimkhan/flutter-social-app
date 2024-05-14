package com.chatting.chat_app;

import android.app.ActivityManager;
import android.app.AlertDialog;
import android.app.KeyguardManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.view.KeyEvent;
import android.view.WindowManager;
import android.widget.Toast;
import androidx.annotation.NonNull;

import com.chatting.chat_app.Services.FcmInstanceIdService;


import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private Intent forService;
    MethodChannel channel;
    AlertDialog alert;
    boolean started = false;
    private String uid = "";
    private String guid = "";
    private String gIamge = "";
    private String gName = "";

    String notifyUserId = "";
    String notifygroupId = "";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
       // forService = new Intent(MainActivity.this, MyService.class);



        // Open group from notification just click on the notification
        if (getIntent().hasExtra("userId") || getIntent().hasExtra("groupId")) {
             notifyUserId = getIntent().getStringExtra("userId");
             notifygroupId = getIntent().getStringExtra("groupId");
        }



        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(this)) {
                reqPermission();
            }
        }

        // this delegate function for run a function from floating buttion on click action
        Delegate.theMainActivity = this;



        // register for fcm instance service
        registerReceiver(myReceiver, new IntentFilter(FcmInstanceIdService.INTENT_FILTER));


        // run function from flutter to java code to stop call ringing
       new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(),"com.callService")
               .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
           @Override
           public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
               if(call.method.equals("startService")){
                 //  RingTonPlayOnCall.mediyaPlayStart(MainActivity.this).stop();
                   RingTonPlayOnCall.ringtonPlay(MainActivity.this).stop();
                   result.success("Service started.");
               }

           }
       });

        // run function from flutter to java code for show floating button for big group
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(),"com.floatingActionButton")
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                        if(call.method.equals("showButton")){
                            uid = call.argument("userId");
                            guid = call.argument("groupId");
                            gIamge = call.argument("groupImage");
                            gName = call.argument("name");
                            result.success("Button showing new "+uid+ " groupid "+guid +gIamge);
                            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                Intent serviceIntent = new Intent(MainActivity.this, MyService.class);
                                serviceIntent.putExtra("image", gIamge);
                                serviceIntent.putExtra("name", gName);
                                startForegroundService(serviceIntent);
                             //   startForegroundService(new Intent(MainActivity.this, MyService.class));
                            }else{
                                Intent serviceIntent = new Intent(MainActivity.this, MyService.class);
                                serviceIntent.putExtra("image", gIamge);
                                serviceIntent.putExtra("name", gName);
                                startService(serviceIntent);
                              //  startService(new Intent(MainActivity.this, MyService.class));
                            }
                        }else if(call.method.equals("hideButton")){
                          String  u = call.argument("userId");
                          String g = call.argument("groupId");
                            result.success("Button hidden");
                            if(uid.equals(u) && guid.equals(g)) {
                                stopService(new Intent(MainActivity.this, MyService.class));
                            }
                        }else if(call.method.equals("showCallFloatElement")){
                            String fid = call.argument("fromId");
                            String rid = call.argument("receiverId");
                            String rPic = call.argument("receiverImage");
                            String rName = call.argument("receiverName");
                        //    result.success("Button showing new "+uid+ " groupid "+guid +gIamge);
                            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                Intent serviceIntent = new Intent(MainActivity.this, CallServices.class);
                                serviceIntent.putExtra("fromId", fid);
                                serviceIntent.putExtra("receiverId", rid);
                                serviceIntent.putExtra("receiverImage", rPic);
                                serviceIntent.putExtra("receiverName", rName);
                                startForegroundService(serviceIntent);
                            }else{
                                Intent serviceIntent = new Intent(MainActivity.this, CallServices.class);
                                serviceIntent.putExtra("fromId", fid);
                                serviceIntent.putExtra("receiverId", rid);
                                serviceIntent.putExtra("receiverImage", rPic);
                                serviceIntent.putExtra("receiverName", rName);
                                startService(serviceIntent);
                                //  startService(new Intent(MainActivity.this, MyService.class));
                            }
                        }else if(call.method.equals("incomingNotifyClose")){
                            result.success("Notification hidden");
                            stopService(new Intent(MainActivity.this, IncomingCallsScreen.class));

                        }
                    }
         });


        channel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "call_channel");

    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN || keyCode == KeyEvent.KEYCODE_VOLUME_UP || keyCode == KeyEvent.KEYCODE_POWER){
            RingTonPlayOnCall.ringtonPlay(this).stop();
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onStart() {
        super.onStart();
        // after getting onCreate data from click push notification when app is in the background or distroyed
        // and start activity and go to the voice room
        if(!notifygroupId.isEmpty() && !notifyUserId.isEmpty()) {
            callGroup(notifyUserId, notifygroupId);
        }
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        //  alert.dismiss();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        stopService(new Intent(MainActivity.this, MyService.class));
        unregisterReceiver(myReceiver);
    }

    private void reqPermission(){
        final AlertDialog.Builder alertBuilder = new AlertDialog.Builder(this);
        alertBuilder.setCancelable(true);
        alertBuilder.setTitle("Screen overlay detected");
        alertBuilder.setMessage("Enable 'Draw over other apps' in your system setting.");
        alertBuilder.setPositiveButton("OPEN SETTINGS", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                        Uri.parse("package:" + getPackageName()));
                startActivityForResult(intent,RESULT_OK);
            }
        });

        alert = alertBuilder.create();
        alert.show();


    }


    // when notification arraives then run function on flutter
    private BroadcastReceiver myReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.hasExtra("startCall")) {
              int type = intent.getIntExtra("startCall",-1);
                if(type == 1){
                 // Toast.makeText(context, "This is running with notification arraival "+type, Toast.LENGTH_SHORT).show();
              }
            }
          //  callFlutter();
          //  start_stop();
          //  startService();
        }
    };







    public int callGroup(String userId, String groupId){
        HashMap<String,String> hashMap = new HashMap<>();
        hashMap.put("userId",userId);
        hashMap.put("groupId",groupId);
        channel.invokeMethod("openGroup", hashMap);
        return 1;
    }

    public void onClickFloatingButton(){
        callGroup(uid, guid);
        stopService(new Intent(MainActivity.this, MyService.class));
    }


    // this is for personal call minimized floating icon on click event
    public void openPersonCallingScreen(String fromId, String receiverId){
        HashMap<String,String> hashMap = new HashMap<>();
        hashMap.put("fromId",fromId);
        hashMap.put("receiverId",receiverId);
        channel.invokeMethod("openPersonalCallScreen",hashMap);
    }

    public void onClickOnCallFloatingButton(String fromId, String receiverId){
        openPersonCallingScreen(fromId, receiverId);
        stopService(new Intent(MainActivity.this, CallServices.class));
    }

    // this is for personal call minimized floating icon on click event
    // this page will navigate to already received screen
    public void openIncomingCallingScreen(String fromId, String receiverId, String receiverName, String type, String call_type){
        HashMap<String,String> hashMap = new HashMap<>();
        hashMap.put("fromId",fromId);
        hashMap.put("receiverId",receiverId);
        hashMap.put("receiverName",receiverName);
        hashMap.put("answerType",type);
        hashMap.put("call_type",call_type);
        channel.invokeMethod("openIncomingCallScreen",hashMap);
    }

    public void onClickOnIncomingCallScreens(String fromId, String receiverId, String receiverName, String type, String call_type){
        openIncomingCallingScreen(fromId, receiverId,receiverName, type, call_type);
        stopService(new Intent(MainActivity.this, IncomingCallsScreen.class));
    }


    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        // This intent on click will work when app already running and when will have been arrived the
        // notification on click will take to the group
        if(intent.hasExtra("groupId") && intent.hasExtra("userId")){
           String userId = intent.getStringExtra("userId");
           String groupId = intent.getStringExtra("groupId");
            callGroup(userId, groupId);
        }

    }


    public void start_stop() {
        if (started) {
            stopService(new Intent(MainActivity.this, MyService.class));
            started = false;
        } else {
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(new Intent(MainActivity.this, MyService.class));
            }else{
                startService(new Intent(MainActivity.this, MyService.class));
            }
            started = true;

        }
    }

}
