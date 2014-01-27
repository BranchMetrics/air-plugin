package com.mobileapptrackernative;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class MATExtension implements FREExtension {
    @Override
    public FREContext createContext(String arg0) {
        return new MATExtensionContext();
    }

    @Override
    public void dispose() {
    }

    @Override
    public void initialize() {
    }
}
