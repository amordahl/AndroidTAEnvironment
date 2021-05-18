package de.ecspride;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;

/**
 * @testcase_name ActivityLifecycle3
 * @version 0.1
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail siegfried.rasthofer@cased.de
 *
 * @description The return value of source method is stored to a static variable in one callback method
 *  and sent to a sink in a different callback method
 * @dataflow onSaveInstanceState: source -> s; onRestoreInstanceState: s -> sink
 * @number_of_leaks 1
 * @challenges the analysis must be able to handle the activity lifecycle correctly,
 *  in particular the less common instanceState callbacks
 */
public class MainActivity extends Activity {
}
