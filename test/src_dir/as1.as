/* SVN FILE: $Id: FakeObject.as 42 2008-03-26 03:18:02Z xpointsh $ */
/**
 * Description
 *
 * Fake
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			fake
 * @subpackage		com.fake
 * @since			2008-03-06
 * @version			$Revision: 42 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-03-25 20:18:02 -0700 (Tue, 25 Mar 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake
{
	import flash.utils.*;

	/**
	 * FakeObject is the root object for all classes
	 * in Fake. It contains a reference to the class name
	 * and class object. These are obtained by using the
	 * reflection classes in flash.utils.
	 */
	public dynamic class FakeObject extends Proxy
	{
		/**
		* The name of the top level subclass
		*/
		[Transient] public var className:String;
		/**
		* A reference to the top level subclass
		*/
		[Transient] public var ClassRef:Class;

		private var __item:Array;

		public function FakeObject()
		{
			getClassInfo();
			__item = new Array();
		}

		/**
		 * This method is called by the constructor. Populates the className and ClassRef using
		 * getQualifiedClassName and getDefinitionByName
		 */
		private function getClassInfo():void
		{
			var qcName:Array = getQualifiedClassName(this).split("::");
			className = qcName[1];

			var classPath:String = getQualifiedClassName(this).replace( "::", "." );
			ClassRef = getDefinitionByName(classPath) as Class;
		}

		/**
		 * Override the callProperty of the flash_proxy
		 * @param method
		 * @param args
		 * @return
		 *
		 */
		override flash_proxy function callProperty(method: *, ...args):*
		{
			try
			{
				return ClassRef.prototype[method].apply(method, args);
			}
			catch (e:Error)
			{
				return overload(method, args);
			}
		}

		/**
		 * To be overriden by subclasses. Allows calling any method on any object that extends FakeOject
		 * @param method
		 * @param args
		 *
		 */
		protected function overload(method:*, args:Array):void
		{
		}

		/**
		 * get a property on the object
		 * @param name
		 * @return
		 *
		 */
		override flash_proxy function getProperty(name:*):*
		{
       	 	return overloadGetProperty(name);
	    }

	    protected function overloadGetProperty(name:*):*
	    {
	    	return __item[name];
	    }

	    /**
	     * Set a property on the object
	     * @param name
	     * @param value
	     *
	     */
	    override flash_proxy function setProperty(name:*, value:*):void
	    {
	        overloadSetProperty(name, value)
	    }

	    protected function overloadSetProperty(name:*, value:*):void
	    {
	    	__item[name] = value;
	    }

	   	/**
	     * Check if the property exits
	     * @param name
	     * @param value
	     *
	     */
	    override flash_proxy function hasProperty(name:*):Boolean
	    {
	    	if (__item[name])
	    	{
	    		return true;
	    	}
	    	return false;
	    }
	}
}
