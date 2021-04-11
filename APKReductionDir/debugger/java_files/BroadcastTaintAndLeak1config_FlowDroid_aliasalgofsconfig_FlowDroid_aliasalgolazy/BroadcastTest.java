package edu.mit.icc_broadcast_programmatic_intentfilter;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;

/**
 * @testcase_name ICC-Broadcast-Programmatic-IntentFilter
 *
 * @description   Testing BroadcastReceiver through programmatic setting up of IntentFilter
 * @dataflow source -> sink
 * @number_of_leaks 1
 * @challenges    The analysis tool has to be able to recognize a broadcast receiver and models its IntentFilter
 */
public class BroadcastTest extends Activity {

    private static String ACTION = "edu.mit.icc_broadcast_programmatic_intentfilter.action";

    public void onCreate(Bundle bundle) {
        BroadcastReceiver receiver = new BroadcastReceiver() {

            public void onReceive(Context c, Intent i) {
                String taint = i.getStringExtra("imei");
                if (taint != null)
                    // sink
                    Log.i("DroidBench", taint);
            }
        };
        this.registerReceiver(receiver, new IntentFilter(ACTION));
    }

    public void onDestroy() {
        // this is tainted!!!
        TelephonyManager mgr = (TelephonyManager) getSystemService(TELEPHONY_SERVICE);
        // source
        String imei = mgr.getDeviceId();
        Intent intent = new Intent(ACTION);
        intent.putExtra("imei", imei);
    }
}
