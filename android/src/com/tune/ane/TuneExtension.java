package com.tune.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class TuneExtension implements FREExtension {
    @Override
    public FREContext createContext(String arg0) {
        return new TuneExtensionContext();
    }

    @Override
    public void dispose() {
    }

    @Override
    public void initialize() {
    }
}
