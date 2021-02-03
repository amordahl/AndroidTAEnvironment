package de.ecspride;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;

/**
 * @testcase_name ImplicitFlow1
 * @version 0.1
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail siegfried.rasthofer@cased.de
 *
 * @description A value from a source gets obfuscated by two different ways and is then written to the log
 * @dataflow source -> userInputPassword -> if-condition -> sink
 * @number_of_leaks 2
 * @challenges the analysis must be able to handle implicit flows and
 *  treat the value of password fields as source
 */
public class ImplicitFlow1 extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        TelephonyManager telephonyManager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
        // source
        String imei = telephonyManager.getDeviceId();
        String obfuscatedIMEI = obfuscateIMEI(imei);
        writeToLog(obfuscatedIMEI);
    }

    private String obfuscateIMEI(String imei) {
        String result = "";
        for (char c : imei.toCharArray()) {
            switch(c) {
                case '0':
                    result += 'a';
                    break;
                case '1':
                    result += 'b';
                    break;
                case '2':
                    result += 'c';
                    break;
                case '3':
                    result += 'd';
                    break;
                case '4':
                    result += 'e';
                    break;
                case '5':
                    result += 'f';
                    break;
                case '6':
                    result += 'g';
                    break;
                case '7':
                    result += 'h';
                    break;
                case '8':
                    result += 'i';
                    break;
                case '9':
                    result += 'j';
                    break;
                default:
                    System.err.println("Problem in obfuscateIMEI for character: " + c);
            }
        }
        return result;
    }

    private String copyIMEI(String imei) {
        char[] imeiAsChar = imei.toCharArray();
        char[] newOldIMEI = new char[imeiAsChar.length];
        return new String(newOldIMEI);
    }

    private void writeToLog(String message) {
        // sink
        Log.i("INFO", message);
    }
}