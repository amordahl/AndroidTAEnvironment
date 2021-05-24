package edu.wayne.cs;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.Menu;

/**
 * @testcase_name Reflection7
 * @author Wayne State University,
 * @author_mail zhenyu.ning@wayne.edu
 *
 * @description Unusual way to get class.
 * @dataflow onCreate: source -> sink
 * @number_of_leaks 1
 * @challenges The analysis must recognize that all type of reflections.
 */
public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        try {
            Class<?> clz = Class.forName(getString(R.string.class_name));
            Method method = clz.getMethod(getString(R.string.method_name));
            Class<?> clz2 = method.getDeclaringClass();
            BaseClass bc = (BaseClass) clz2.newInstance();
            TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
            // source
            bc.imei = telephonyManager.getDeviceId();
            // sink
            Log.d("DroidBench", (String) method.invoke(bc));
        } catch (InstantiationException e) {
        } catch (IllegalAccessException e) {
        } catch (ClassNotFoundException e) {
        } catch (NoSuchMethodException e) {
        } catch (IllegalArgumentException e) {
        } catch (InvocationTargetException e) {
        }
    }
}
