package com.mobileapptrackernative;

import android.util.Log;
import android.view.ViewGroup.LayoutParams;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.tune.crosspromo.TuneAdMetadata;
import com.tune.crosspromo.TuneBanner;
import com.tune.crosspromo.TuneBannerPosition;

public class ShowBannerFunction implements FREFunction {
    public static final String NAME = "showBanner";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            if (passedArgs[0] != null) {
                String placement = passedArgs[0].getAsString();
                
                // Parse metadata object and set values if any are found
                TuneAdMetadata metadata = MATExtensionContext.parseMetadata(passedArgs[1]);
                
                // Parse banner position, default is BOTTOM_CENTER
                TuneBannerPosition position = TuneBannerPosition.BOTTOM_CENTER;
                if (passedArgs[2] != null) {
                    int bannerPosition = passedArgs[2].getAsInt();
                    if (bannerPosition == 1) {
                        position = TuneBannerPosition.TOP_CENTER;
                    }
                }
                
                MATExtensionContext mec = (MATExtensionContext)context;
                if (mec.banner == null) {
                    mec.banner = new TuneBanner(context.getActivity());
                    
                    // create a RelativeLayout and add the ad view to it
                    if (mec.layout == null) {
                        mec.layout = new RelativeLayout(context.getActivity());
                    } else {
                        // remove the layout if it has a parent
                        FrameLayout parentView = (FrameLayout) mec.layout.getParent();
                        if (parentView != null) {
                            parentView.removeView(mec.layout);
                        }
                    }
                    mec.layout.addView(mec.banner);
                    context.getActivity().addContentView(mec.layout, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
                }
                mec.layout.setVisibility(RelativeLayout.VISIBLE);
                mec.banner.setPosition(position);
                mec.banner.show(placement, metadata);
            }
            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
