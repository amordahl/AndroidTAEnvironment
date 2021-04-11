package de.ecspride;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;

/**
 * @testcase_name Exceptions4
 * @version 0.2
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail steven.arzt@cased.de
 *
 * @description tainted data is created, thrown as exception data and sent out in the exception handler
 * @dataflow source -> imei -> exception -> exception handler -> sink
 * @number_of_leaks 1
 * @challenges the analysis must handle exception data
 */
public class Exceptions4 extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        try {
            TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
            // source
            String imei = telephonyManager.getDeviceId();
            throw new RuntimeException(imei);
        } catch (RuntimeException ex) {
            SmsManager sm = SmsManager.getDefault();
        }
    }
}