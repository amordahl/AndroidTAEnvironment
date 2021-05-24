package edu.mit.array_copy;

import android.app.Activity;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;

/**
 * @testcase_name ArrayCopy
 *
 * @description Testing System.arraycopy()
 * @dataflow source -> sink
 * @number_of_leaks 1
 * @challenges - The analysis tool must have a model for System.arraycopy()
 */
public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        TelephonyManager mgr = (TelephonyManager) this.getSystemService(TELEPHONY_SERVICE);
        // source
        String imei = mgr.getDeviceId();
        String[] array = new String[1];
        array[0] = imei;
        String[] arraycopy = new String[1];
        System.arraycopy(array, 0, arraycopy, 0, 1);
        // sink
        Log.i("DroidBench", arraycopy[0]);
    }
}
