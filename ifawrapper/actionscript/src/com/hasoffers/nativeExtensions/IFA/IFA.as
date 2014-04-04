package com.hasoffers.nativeExtensions.IFA
{
    import flash.events.EventDispatcher;
    import flash.external.ExtensionContext;

    [RemoteClass(alias="com.hasoffers.nativeExtensions.IFA.IFA")]
    public class IFA extends EventDispatcher
    {
        // If the AIR application creates multiple IFA objects,
        // all the objects share one instance of the ExtensionContext class.

        private static var extId:String = "com.hasoffers.IFA";
        private static var extContext:ExtensionContext = null;

        private static var _instance:IFA = null;

        public static function get instance():IFA
        {
            trace("IFA");
            if (_instance == null)
            {
                _instance = new IFA(new SingletonEnforcer());
            }
            return _instance;
        }

        public static function get isSupported():Boolean
        {
            trace("IFA isSupported()");
            return true;
        }

        public function IFA(enforcer:SingletonEnforcer)
        {
            trace("IFA.Constructor");
            if (enforcer == null) throw new Error("Invalid singleton access. Please use IFA.instance() instead.");
            
            initExtension();
        }
        
        private static function initExtension():void
        {
            trace("IFA.initExtension()");
            
            // The extension context's context type is NULL, because this extension
            // has only one context type.
            extContext = ExtensionContext.createExtensionContext(extId, null);

            if (null == extContext )
            {
                trace("IFA.initExtension: extContext = null");
                throw new Error("Error when instantiating IFA native extension." );
            }
        }
        
        public function getAppleAdvertisingIdentifier():String
        {
            trace("IFA.getAppleAdvertisingIdentifier()");
            return extContext.call(NativeMethods.getAppleAdvertisingIdentifier) as String;
        }
        
        public function isAdvertisingTrackingEnabled():Boolean
        {
            trace("IFA.isAdvertisingTrackingEnabled()");
            return extContext.call(NativeMethods.isAdvertisingTrackingEnabled) as Boolean;
        }
    }
}