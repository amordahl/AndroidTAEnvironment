package edu.mit.serialization;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import android.app.Activity;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;

/**
 * @testcase_name Serialization
 *
 * @description Test serialization end to end flow.
 * @dataflow source -> sink
 * @number_of_leaks 1
 * @challenges - must model serialization
 */
public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        TelephonyManager mgr = (TelephonyManager) this.getSystemService(TELEPHONY_SERVICE);
        // source
        String imei = mgr.getDeviceId();
        S s1 = new S(imei);
        try {
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            byte[] bytes = out.toByteArray();
            ByteArrayInputStream in = new ByteArrayInputStream(bytes);
            ObjectInputStream iis = new ObjectInputStream(in);
            S s2 = (S) iis.readObject();
            // sink
            Log.i("DroidBench", s2.toString());
        } catch (Exception e) {
        }
    }
}

class S implements Serializable {

    public S(String message) {
    }
}
