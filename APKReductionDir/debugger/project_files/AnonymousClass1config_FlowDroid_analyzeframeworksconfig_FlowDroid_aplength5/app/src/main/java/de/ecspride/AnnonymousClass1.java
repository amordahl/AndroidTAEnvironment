package de.ecspride;

import android.app.Activity;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

/**
 * @testcase_name AnnonymousClass1
 * @version 0.1
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail siegfried.rasthofer@cased.de
 *
 * @description Registers a callback handler for location updates in an anonymous
 *  inner class. The incoming location data from the source are stored in static fields which are leaked to the log.
 * @dataflow onLocationChanged -> latitude, longitude -> Log
 * @number_of_leaks 2
 * @challenges the analysis must handle callbacks, anonymous inner classes and static fields.
 */
public class AnnonymousClass1 extends Activity {
}
