package edu.mit.parcel;

import android.app.Activity;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;

/**
 * @testcase_name Parcel
 *
 * @description Tests whether analysis has proper modeling of Parcel marshall and unmarshall
 * @dataflow source -> sink
 * @number_of_leaks 1
 * @challenges - Parcel marshall and unmarshalling
 */
public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        TelephonyManager mgr = (TelephonyManager) this.getSystemService(TELEPHONY_SERVICE);
        // source
        writeParcel(mgr.getDeviceId());
    }

    public void writeParcel(String arg) {
        final Parcel p2 = Parcel.obtain();
        final Foo result;
        SmsManager sms = SmsManager.getDefault();
        try {
            result = (Foo) p2.readValue(Foo.class.getClassLoader());
        } finally {
        }
        // sink, leak
        sms.sendTextMessage("+49 1234", null, result.str, null, null);
    }

    protected static class Foo implements Parcelable {

        public String str;

        public int describeContents() {
        }

        public void writeToParcel(Parcel dest, int ignored) {
        }
    }
}
