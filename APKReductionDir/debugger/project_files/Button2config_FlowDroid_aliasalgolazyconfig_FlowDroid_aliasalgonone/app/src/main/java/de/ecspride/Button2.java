package de.ecspride;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.View;
import android.widget.Button;

/**
 * @testcase_name Button2
 * @version 0.1
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail siegfried.rasthofer@cased.de
 *
 * @description Sources and sinks are called in button callbacks. There is only one data leak iff first button3 and then button1 is pressed!
 * @dataflow clickOnButton3: source -> imei; onClick (button1): imei -> sinks
 * @number_of_leaks 3
 * @challenges the analysis must be able to analyze listeners, know that callback of button3 is ClickOnButton3 (defined in xml file)
 *  and has to handle the arbitrary order of the listener callbacks.
 */
public class Button2 extends Activity {
}