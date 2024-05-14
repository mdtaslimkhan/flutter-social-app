package com.chatting.chat_app.floating_item;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.chatting.chat_app.MainActivity;
import com.chatting.chat_app.RingTonPlayOnCall;
import com.chatting.chat_app.MyService;
import com.chatting.chat_app.R;

public class Floatcall {


    public static LinearLayout floatingItem(Context context) {

        LinearLayout ll;
        ll = new LinearLayout(context);
        ll.setBackgroundColor(Color.WHITE);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
        );
        ll.setLayoutParams(layoutParams);
       // ll.setElevation(25);

        GradientDrawable gradientDrawable = new GradientDrawable();
        gradientDrawable.setShape(GradientDrawable.RECTANGLE);
        gradientDrawable.setCornerRadius(200);
        gradientDrawable.setColor(Color.rgb(136, 177, 83));
        ll.setBackground(gradientDrawable);
        ll.setOrientation(LinearLayout.VERTICAL);


        LinearLayout.LayoutParams mic = new LinearLayout.LayoutParams(
                70, 70);
        ImageView openapp = new ImageView(context);
        openapp.setImageResource(R.drawable.ic_mic);
        openapp.setLayoutParams(mic);
        mic.setMargins(10, 30, 10, 0);





        LinearLayout.LayoutParams text = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        TextView textView = new TextView(context);
        textView.setText("CR");
        textView.setGravity(Gravity.CENTER_HORIZONTAL);
        textView.setTextColor(Color.rgb(255, 255, 255));
        textView.setLayoutParams(text);
        text.setMargins(0, 20, 0, 30);


        ll.addView(openapp);
        ll.addView(textView);



        return ll;

    }

    public static LinearLayout notificationStyle1(Context context){

        // Main parent
        LinearLayout ll = new LinearLayout(context);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,LinearLayout.LayoutParams.WRAP_CONTENT);
        ll.setBackgroundColor(Color.TRANSPARENT);
       // ll.setElevation(15);
        ll.setLayoutParams(lp);


        // parent layout
        LinearLayout linearLayout = new Floatcall().Rowlayout(context, LinearLayout.VERTICAL,20);
        // top row
        LinearLayout layout = new Floatcall().Rowlayout(context, LinearLayout.HORIZONTAL,0);

        LinearLayout.LayoutParams leading = new LinearLayout.LayoutParams(100, 100);
        ImageView leadingImage = new ImageView(context);
        leadingImage.setImageResource(R.drawable.ic_person);
        leading.setMargins(20,20,20,20);
        leadingImage.setLayoutParams(leading);


        layout.addView(leadingImage);

        LinearLayout textHolder = new Floatcall().Rowlayout(context, LinearLayout.VERTICAL,0);

        TextView crtv =  textv(context,"CR", 14, Color.WHITE);
        TextView ictv =  textv(context,"Incoming call", 10, Color.WHITE);

        textHolder.addView(crtv);
        textHolder.addView(ictv);

        layout.addView(textHolder);

        // bottom row
        LinearLayout bottomLyout = new Floatcall().Rowlayout(context, LinearLayout.HORIZONTAL,0);

        LinearLayout.LayoutParams btnp = new LinearLayout.LayoutParams(250,70);
        btnp.setMargins(10,0,20,25);
        // bottom row button
        TextView btncancel = btntext(context, "Cancel", 10, Color.RED,Color.WHITE);
        btncancel.setLayoutParams(btnp);
        TextView btnreceive = btntext(context, "Answer", 10, Color.rgb(136, 177, 83),Color.WHITE);
        btnreceive.setLayoutParams(btnp);
        bottomLyout.setGravity(Gravity.RIGHT);

        bottomLyout.addView(btncancel);
        bottomLyout.addView(btnreceive);

        linearLayout.addView(layout);
        linearLayout.addView(bottomLyout);


        ll.addView(linearLayout);

        btncancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                context.stopService(new Intent(context, MyService.class));
               // RingTonPlayOnCall.mediyaPlayStart(context).stop();
                RingTonPlayOnCall.ringtonPlay(context).stop();
            }
        });

        btnreceive.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent homePage = new Intent(context, MainActivity.class);
                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    homePage.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                }
                context.startActivity(homePage);
                context.stopService(new Intent(context, MyService.class));
              //  RingTonPlayOnCall.mediyaPlayStart(context).stop();
                RingTonPlayOnCall.ringtonPlay(context).stop();

            }
        });

        return ll;
    }


    private LinearLayout Rowlayout(Context context, int orientation, int margin){
        LinearLayout.LayoutParams topRow = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,LinearLayout.LayoutParams.WRAP_CONTENT);
        LinearLayout topLayout = new LinearLayout(context);
        topRow.setMargins(margin,margin,margin,margin);
        topLayout.setLayoutParams(topRow);
        topLayout.setBackground(btnBg(Color.rgb(0, 0, 0),10));
        topLayout.setGravity(Gravity.CENTER_VERTICAL);
        topLayout.setOrientation(orientation);
         return topLayout;
    }



    private static Button btn(Context context, String text, int size, int color, int txtColor){
        Button btn = new Button(context);
        btn.setText(text);
        btn.setTextSize(size);
        btn.setTextColor(txtColor);
        btn.setBackground(btnBg(color,8));
        btn.setGravity(Gravity.CENTER);
        return btn;
    }

    private static TextView btntext(Context context, String text, int size, int bgColor, int txtColor){
        TextView btn = new TextView(context);
        btn.setText(text);
        btn.setTextSize(size);
        btn.setTextColor(txtColor);
        btn.setBackground(btnBg(bgColor, 8));
        btn.setGravity(Gravity.CENTER);
        return btn;
    }

    private static TextView textv(Context context, String text, int size, int txtColor){
        TextView btn = new TextView(context);
        btn.setText(text);
        btn.setTextSize(size);
        btn.setTextColor(txtColor);
        btn.setGravity(Gravity.LEFT);
        return btn;
    }


    private static GradientDrawable btnBg(int color, int radius){
        GradientDrawable bgbtn = new GradientDrawable();
        bgbtn.setColor(color);
        bgbtn.setShape(GradientDrawable.RECTANGLE);
        bgbtn.setCornerRadius(radius);
        return bgbtn;
    }








    static public void moveevent(WindowManager wm, View ll, WindowManager.LayoutParams params ) {
        ll.setOnTouchListener(new View.OnTouchListener() {
            WindowManager.LayoutParams updatepar = params;
            double x;
            double y;
            double px;
            double py;

            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {

                switch (motionEvent.getAction()) {
                    case MotionEvent.ACTION_DOWN:

                        x = updatepar.x;
                        y = updatepar.y;

                        px = motionEvent.getRawX();
                        py = motionEvent.getRawY();

                        break;

                    case MotionEvent.ACTION_MOVE:

                        updatepar.x = (int) (x + (motionEvent.getRawX() - px));
                        updatepar.y = (int) (y + (motionEvent.getRawY() - py));

                        wm.updateViewLayout(ll, updatepar);

                    default:
                        break;
                }

                return false;

            }



        });
    }



}


