package edu.mit.string_formatter;

import java.util.Formatter;
import android.app.Activity;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;

/**
 * @testcase_name String Format
 *
 * @description Test String Formatter
 * @dataflow source -> sink
 * @number_of_leaks 1
 * @challenges - Modeling of StringBuffer and StringFormatter
 */
public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        TelephonyManager mgr = (TelephonyManager) this.getSystemService(TELEPHONY_SERVICE);
        // source
        String imei = mgr.getDeviceId();
        StringBuffer buf = new StringBuffer();
        Formatter formatter = new Formatter(buf);
        formatter.format("%s", imei);
        // sink, leak
        Log.i("DroidBench", buf.toString());
    }
}
