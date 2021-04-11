package edu.mit.clinit;

import android.app.Activity;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;

/**
 * @testcase_name Clinit
 *
 * @description Clinit (static initializer test)
 * @dataflow source -> sink
 * @number_of_leaks 1
 * @challenges - The order of execution of static initializers is not defined in Java.  This
 * test stresses a particular order to link a flow.
 */
public class MainActivity extends Activity {

    public static MainActivity v;

    public String s;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        s = "";
        // could call static initializer if has been called previously
        Test t = new Test();
        // sink, possible leak depending on runtime execution of Test's clinit
        Log.i("DroidBench", s);
    }
}

class Test {

    static {
        TelephonyManager mgr = (TelephonyManager) MainActivity.v.getSystemService(Activity.TELEPHONY_SERVICE);
        // source
        MainActivity.v.s = mgr.getDeviceId();
    }
}
