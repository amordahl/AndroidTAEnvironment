package edu.mit.pattern_matcher;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import android.app.Activity;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;

/**
 * @testcase_name PatternMatcher
 *
 * @description Test common usage of pattern and matcher in Java
 * @dataflow source -> sink
 * @number_of_leaks 1
 * @challenges - flows through multiple object allocated in API code
 */
public class MainActivity extends Activity {
}
