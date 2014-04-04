package com.hasoffers.nativeExtensions.GAID
{
	import flash.events.EventDispatcher;

	[RemoteClass(alias="com.hasoffers.nativeExtensions.GAID.GAID")]
	public class GAID extends EventDispatcher
	{
		// If the AIR application creates multiple IFA objects,
		// all the objects share one instance of the ExtensionContext class.

		private static var extId:String = "com.hasoffers.GAID";

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
			return false;
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
		}
		
		public function getGoogleAdvertisingId(callback:Function):void
		{
			trace("GAID.getGoogleAdvertisingId()");
			trace("Only supported on Android");
		}
	}
}
