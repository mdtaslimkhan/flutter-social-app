package com.chatting.chat_app;


import android.os.Bundle;
import android.widget.TextView;
import io.flutter.embedding.android.FlutterActivity;


public class CallActivity extends FlutterActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_call);

        TextView textView =  findViewById(R.id.call_screen_text);

    }




}