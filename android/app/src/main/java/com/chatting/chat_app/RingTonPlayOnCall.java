package com.chatting.chat_app;

import android.content.Context;
import android.media.MediaPlayer;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

public class RingTonPlayOnCall {



   private static MediaPlayer mediaPlayer;
   public static MediaPlayer mediyaPlayStart(Context context) {
       stopPlaying();
       mediaPlayer = MediaPlayer.create(context, Settings.System.DEFAULT_RINGTONE_URI);
       mediaPlayer.setLooping(true);
       return mediaPlayer;
   }

   private static void stopPlaying() {
        if (mediaPlayer != null) {
            mediaPlayer.stop();
            mediaPlayer.release();
            mediaPlayer = null;
        }
    }

    private static Ringtone mRington;
    public static Ringtone ringtonPlay(Context context) {
        stopRingTon();
        Uri notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE);
        mRington = RingtoneManager.getRingtone(context, notification);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            mRington.setLooping(true);
        }
        return mRington;
    }

    private static void stopRingTon(){
        if(mRington != null){
            mRington.stop();
            mRington = null;
        }
    }
    
    

}
