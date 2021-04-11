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
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        TelephonyManager mgr = (TelephonyManager) this.getSystemService(TELEPHONY_SERVICE);
        // source
        writeParcel(mgr.getDeviceId());
    }

    protected static class Foo implements Parcelable {

        public static final Parcelable.Creator<Foo> CREATOR = new Parcelable.Creator<Foo>() {

            public Foo createFromParcel(Parcel source) {
                final Foo f = new Foo();
                f.str = (String) source.readValue(Foo.class.getClassLoader());
                return f;
            }

            public Foo[] newArray(int size) {
                throw new UnsupportedOperationException();
            }
        };

        public String str;

        public Foo() {
        }

        public Foo(String s) {
            str = s;
        }

        public int describeContents() {
            return 0;
        }

        public void writeToParcel(Parcel dest, int ignored) {
            dest.writeValue(str);
        }
    }
}
