package de.ecspride;

import android.app.Activity;
import android.content.Context;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.util.Log;

/**
 * @testcase_name FactoryMethods1
 * @version 0.1
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail steven.arzt@cased.de
 *
 * @description This example obtains a LocationManager from a factory method contained
 * 	in the Android operating system, reads out the location, and leaks it.
 * @dataflow onCreate: source -> data -> sink
 * @number_of_leaks 2
 * @challenges The analysis must be able to handle factory methods contained in
 * 	the operating system.
 */
public class FactoryMethods1 extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Criteria crit = new Criteria();
        LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        Location data = locationManager.getLastKnownLocation(locationManager.getBestProvider(crit, true));
        // sink, leak
        Log.d("Latitude", "Latitude: " + data.getLatitude());
    }
}
