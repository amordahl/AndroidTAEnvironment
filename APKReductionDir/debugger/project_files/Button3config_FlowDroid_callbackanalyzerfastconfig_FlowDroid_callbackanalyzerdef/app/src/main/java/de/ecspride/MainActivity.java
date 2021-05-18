package de.ecspride;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.widget.Button;

/**
 * @testcase_name Button3
 * @version 0.1
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail steven.arzt@cased.de
 *
 * @description A new callback is registered in another callback's handler. The second handler
 * 	leaks the data obtained by the first handler.
 * @dataflow Button1Listener: source -> imei; Button2Listener: imei -> sink
 * @number_of_leaks 2
 * @challenges The analysis must be able to detect callback handlers registered
 * 	in other callback handlers.
 */
public class MainActivity extends Activity {

    String imei = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Button button1 = (Button) findViewById(R.id.button1);
    }
}
