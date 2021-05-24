package edu.uta;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import edu.uta.ServiceEventSequence1.LocalBinder;

/**
 * @testcase_name Lifecycle_ServiceEventSequence1
 *
 * @description   Testing if information leak can be detected which occurs through possible flows between the service callbacks.
 * @dataflow onStartCommand :source -> onBind -> onStartCommand: sink
 * @number_of_leaks 1
 * @challenges  The analysis tool must be able to detect data leaks which are triggered by different ordering of events.
 */
public class MainActivity extends Activity {
}
