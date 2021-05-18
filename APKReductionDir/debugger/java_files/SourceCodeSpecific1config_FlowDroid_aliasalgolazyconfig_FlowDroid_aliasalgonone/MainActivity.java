package de.ecspride;

import java.util.HashSet;
import java.util.Set;
import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;

/**
 * @testcase_name SourceCodeSpecific1
 * @version 0.1
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail siegfried.rasthofer@cased.de
 *
 * @description tainted data is created in a condition branch and afterwards sent to a sink in a loop
 * @dataflow source -> message -> sink
 * @number_of_leaks 1
 * @challenges the analysis must handle standard java constructs
 */
public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
        Set<String> phoneNumbers = new HashSet<String>();
        int a = 22 + 11;
        int b = 22 * 2 - 1 + a;
        // source
        String message = (a == b) ? "no taint" : telephonyManager.getDeviceId();
        sendSMS(phoneNumbers, message);
    }

    private void sendSMS(Set<String> numbers, String message) {
        SmsManager sm = SmsManager.getDefault();
        for (String number : numbers) {
            // sink
            sm.sendTextMessage(number, null, message, null, null);
        }
    }
}
