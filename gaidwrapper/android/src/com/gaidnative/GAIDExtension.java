package com.gaidnative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class GAIDExtension implements FREExtension {

    @Override
    public FREContext createContext(String arg0) {
        Log.d(GAIDExtensionContext.TAG, "Creating context");
        return new GAIDExtensionContext();
    }

    @Override
    public void dispose() {
    }

    @Override
    public void initialize() {
    }

}
