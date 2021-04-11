package edu.mit.public_api_field;

import android.app.Activity;
import android.graphics.PointF;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;

/**
 * @testcase_name Public-API-Field
 *
 * @description Track flows through an API field setter and a direct field access
 * @dataflow source -> sink
 * @number_of_leaks 1
 * @challenges - Must have accurate modeling for API classes that expose fields
 */
public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        TelephonyManager mgr = (TelephonyManager) this.getSystemService(TELEPHONY_SERVICE);
        // source
        String imei = mgr.getDeviceId();
        float fx = Float.valueOf(imei.substring(0, 8));
        float fy = Float.valueOf(imei.substring(8));
        PointF point = new PointF(fx, fy);
        // sink, leak
        Log.i("DroidBench", "IMEI: " + point.x + "" + point.y);
    }
}
