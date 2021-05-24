package mod.ndk;

import android.app.Activity;
import android.content.Context;
import android.os.*;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.Toast;

/**
 * @testcase_name NativeIDFunction
 * @version 0.1
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail steven.arzt@cased.de
 *
 * @description Sends tainted data from Java to Native and back to Java where it is leaked
 * @dataflow source -> imei -> native method -> native -> leak in caller (Java)
 * @number_of_leaks 1
 * @challenges the analysis must handle native method invocations
 */
public class ActMain extends Activity {

    // ___________________
    // C with params
    public native String cFuncRetString(String s);

    // ___________________
    // C with params
    public native String cFuncModString(String s);

    // ___________________
    @Override
    public void onCreate(Bundle savedInstanceState) {
        Button button = (Button) findViewById(R.id.button1);
        button.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                String strIMEI = "";
                TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
                strIMEI = telephonyManager.getDeviceId() + "foo";
                String strOut = "";
                strOut += "\n- cFuncModString(...):[" + cFuncModString(strIMEI) + "]";
                SmsManager sms = SmsManager.getDefault();
            }
        });
    }
}
