package com.chatting.chat_app.Storage;

import android.content.Context;

public class SharedPreManager {
    private static final String SHRED_PREF_NAME = "advice_shared_pref";

    // for payment
    private static final String SHRED_TEMP_APPOINT = "temp_appoint";

    private static SharedPreManager mInstance;
    private Context mCtx;

    private SharedPreManager(Context mCtx){
        this.mCtx = mCtx;

    }

    public static synchronized SharedPreManager getInstance(Context mCtx){
        if(mInstance == null){
            mInstance = new SharedPreManager(mCtx);
        }
        return mInstance;
    }



}
