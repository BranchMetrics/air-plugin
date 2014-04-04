package com.hasoffers.nativeExtensions.GAID
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	[RemoteClass(alias="com.hasoffers.nativeExtensions.GAID.GAID")]
	public class GAID extends EventDispatcher
	{
		// If the AIR application creates multiple IFA objects,
		// all the objects share one instance of the ExtensionContext class.

		private static var extId:String = "com.hasoffers.GAID";
		private static var extContext:ExtensionContext = null;
		private static var _callback:Function = null;

		private static var _instance:GAID = null;

		public static function get instance():GAID
		{
			trace("GAID");
			if (_instance == null)
			{
				_instance = new GAID(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public static function get isSupported():Boolean
		{
			trace("GAID isSupported()");
			return true;
		}

		public function GAID(enforcer:SingletonEnforcer)
		{
			trace("GAID.Constructor");
			if (enforcer == null) throw new Error("Invalid singleton access. Please use GAID.instance() instead.");
			
			initExtension();
		}
		
		private static function initExtension():void
		{
			trace("GAID.initExtension()");
			
			// The extension context's context type is NULL, because this extension
			// has only one context type.
			extContext = ExtensionContext.createExtensionContext(extId, null);

			if (null == extContext )
			{
				trace("GAID.initExtension: extContext = null");
				throw new Error("Error when instantiating GAID native extension." );
			}
			
			extContext.addEventListener(StatusEvent.STATUS, onStatus);
		}
		
		public function getGoogleAdvertisingId(callback:Function):void
		{
			_callback = callback;
			trace("GAID.getGoogleAdvertisingId()");
			extContext.call(NativeMethods.getGoogleAdvertisingId);
		}
		
		private static function onStatus(e:StatusEvent):void {
			if (_callback is Function) 
			{
				_callback(e.level);
			}
		}
	}
}
