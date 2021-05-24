package de.ecspride;

import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.Log;

public class LooperThread extends Thread {

    public boolean ready = false;

    public void run() {
        Looper.prepare();
        ready = true;
        Looper.loop();
    }
}
