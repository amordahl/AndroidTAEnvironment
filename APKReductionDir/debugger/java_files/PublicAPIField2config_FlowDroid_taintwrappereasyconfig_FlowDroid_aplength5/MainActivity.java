package edu.mit.icc_intent_class_modeling;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;

/**
 * @testcase_name Intent-Class-Modeling
 *
 * @description Test if analysis links setter / getter of action field of Intent.
 * @dataflow source -> sink
 * @number_of_leaks 1
 * @challenges - Analysis must have a model of Intent implementation to  setter / getter of
 * Intent fields
 */
public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        TelephonyManager mgr = (TelephonyManager) this.getSystemService(TELEPHONY_SERVICE);
        // source
        String imei = mgr.getDeviceId();
        Intent i = new Intent();
        // leak
        Log.i("DroidBench", i.getAction());
    }
}
