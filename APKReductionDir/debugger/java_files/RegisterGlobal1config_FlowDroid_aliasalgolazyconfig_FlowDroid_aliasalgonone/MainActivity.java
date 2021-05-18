package de.ecspride;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;

/**
 * @testcase_name RegisterGlobal1
 * @version 0.1
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail steven.arzt@cased.de
 *
 * @description Both source and sink are part of a global (application-level) lifecycle handler.
 * @dataflow OnCreate: source -> imei; sendMessage: imei -> sink
 * @number_of_leaks 1
 * @challenges The analysis must support globally-registered callback handlers
 */
public class MainActivity extends Activity {
}
