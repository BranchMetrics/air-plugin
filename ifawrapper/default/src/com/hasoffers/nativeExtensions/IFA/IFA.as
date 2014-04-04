package com.hasoffers.nativeExtensions.IFA
{
	import flash.events.EventDispatcher;

	[RemoteClass(alias="com.hasoffers.nativeExtensions.IFA.IFA")]
	public class IFA extends EventDispatcher
	{
		// If the AIR application creates multiple IFA objects,
		// all the objects share one instance of the ExtensionContext class.

		private static var extId:String = "com.hasoffers.IFA";

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
			return false;
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
		}
		
		public function getAppleAdvertisingIdentifier():String
		{
			trace("IFA.getAppleAdvertisingIdentifier()");
			trace("Only supported on iOS");
			return "";
		}
		
		public function isAdvertisingTrackingEnabled():Boolean
		{
			trace("IFA.isAdvertisingTrackingEnabled()");
			trace("Only supported on iOS");
			return false;
		}
	}
}
