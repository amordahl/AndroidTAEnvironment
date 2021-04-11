package de.ecspride;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;

/**
 * @testcase_name Reflection4
 * @version 0.1
 * @author Secure Software Engineering Group (SSE), European Center for Security and Privacy by Design (EC SPRIDE)
 * @author_mail steven.arzt@cased.de
 *
 * @description Sensitive data is read using a function in a reflective class and leaked
 * 	using another function in the same reflective class.
 * @dataflow onCreate: source -> bc.foo() -> bc.bar() -> sink
 * @number_of_leaks 1
 * @challenges The analysis must be able to correctly handle sources and sinks in classes
 * 	used through reflection.
 */
public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        try {
            BaseClass bc = (BaseClass) Class.forName("de.ecspride.ConcreteClass").newInstance();
            String s = bc.foo(this);
        } catch (InstantiationException e) {
        } catch (IllegalAccessException e) {
        } catch (ClassNotFoundException e) {
        }
    }
}
