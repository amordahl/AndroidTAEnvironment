package de.ecspride;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;
import android.view.Menu;

/**
 * @testcase_name Reflection1
 * @version 0.1
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail steven.arzt@cased.de
 *
 * @description A class instance is created using reflection. Sensitive data is stored
 * 	in a field of this class and directly read out again and leaked.
 * @dataflow onCreate: source -> bc.imei -> sink
 * @number_of_leaks 1
 * @challenges The analysis must be able to handle reflective class instantiations.
 */
public class MainActivity extends Activity {
}
