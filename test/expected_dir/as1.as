actionscript	comment	/* SVN FILE: $Id: FakeObject.as 42 2008-03-26 03:18:02Z xpointsh $ */
actionscript	comment	/**
actionscript	comment	 * Description
actionscript	comment	 *
actionscript	comment	 * Fake
actionscript	comment	 * Copyright 2008, Sean Chatman and Garrett Woodworth
actionscript	comment	 *
actionscript	comment	 * Licensed under The MIT License
actionscript	comment	 * Redistributions of files must retain the above copyright notice.
actionscript	comment	 *
actionscript	comment	 * @filesource
actionscript	comment	 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
actionscript	comment	 * @link			http://code.google.com/p/fake-as3/
actionscript	comment	 * @package			fake
actionscript	comment	 * @subpackage		com.fake
actionscript	comment	 * @since			2008-03-06
actionscript	comment	 * @version			$Revision: 42 $
actionscript	comment	 * @modifiedby		$LastChangedBy: xpointsh $
actionscript	comment	 * @lastmodified	$Date: 2008-03-25 20:18:02 -0700 (Tue, 25 Mar 2008) $
actionscript	comment	 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
actionscript	comment	 */
actionscript	code	package com.fake
actionscript	code	{
actionscript	code		import flash.utils.*;
actionscript	blank	
actionscript	comment		/**
actionscript	comment		 * FakeObject is the root object for all classes
actionscript	comment		 * in Fake. It contains a reference to the class name
actionscript	comment		 * and class object. These are obtained by using the
actionscript	comment		 * reflection classes in flash.utils.
actionscript	comment		 */
actionscript	code		public dynamic class FakeObject extends Proxy
actionscript	code		{
actionscript	comment			/**
actionscript	comment			* The name of the top level subclass
actionscript	comment			*/
actionscript	code			[Transient] public var className:String;
actionscript	comment			/**
actionscript	comment			* A reference to the top level subclass
actionscript	comment			*/
actionscript	code			[Transient] public var ClassRef:Class;
actionscript	blank	
actionscript	code			private var __item:Array;
actionscript	blank	
actionscript	code			public function FakeObject()
actionscript	code			{
actionscript	code				getClassInfo();
actionscript	code				__item = new Array();
actionscript	code			}
actionscript	blank	
actionscript	comment			/**
actionscript	comment			 * This method is called by the constructor. Populates the className and ClassRef using
actionscript	comment			 * getQualifiedClassName and getDefinitionByName
actionscript	comment			 */
actionscript	code			private function getClassInfo():void
actionscript	code			{
actionscript	code				var qcName:Array = getQualifiedClassName(this).split("::");
actionscript	code				className = qcName[1];
actionscript	blank	
actionscript	code				var classPath:String = getQualifiedClassName(this).replace( "::", "." );
actionscript	code				ClassRef = getDefinitionByName(classPath) as Class;
actionscript	code			}
actionscript	blank	
actionscript	comment			/**
actionscript	comment			 * Override the callProperty of the flash_proxy
actionscript	comment			 * @param method
actionscript	comment			 * @param args
actionscript	comment			 * @return
actionscript	comment			 *
actionscript	comment			 */
actionscript	code			override flash_proxy function callProperty(method: *, ...args):*
actionscript	code			{
actionscript	code				try
actionscript	code				{
actionscript	code					return ClassRef.prototype[method].apply(method, args);
actionscript	code				}
actionscript	code				catch (e:Error)
actionscript	code				{
actionscript	code					return overload(method, args);
actionscript	code				}
actionscript	code			}
actionscript	blank	
actionscript	comment			/**
actionscript	comment			 * To be overriden by subclasses. Allows calling any method on any object that extends FakeOject
actionscript	comment			 * @param method
actionscript	comment			 * @param args
actionscript	comment			 *
actionscript	comment			 */
actionscript	code			protected function overload(method:*, args:Array):void
actionscript	code			{
actionscript	code			}
actionscript	blank	
actionscript	comment			/**
actionscript	comment			 * get a property on the object
actionscript	comment			 * @param name
actionscript	comment			 * @return
actionscript	comment			 *
actionscript	comment			 */
actionscript	code			override flash_proxy function getProperty(name:*):*
actionscript	code			{
actionscript	code	       	 	return overloadGetProperty(name);
actionscript	code		    }
actionscript	blank	
actionscript	code		    protected function overloadGetProperty(name:*):*
actionscript	code		    {
actionscript	code		    	return __item[name];
actionscript	code		    }
actionscript	blank	
actionscript	comment		    /**
actionscript	comment		     * Set a property on the object
actionscript	comment		     * @param name
actionscript	comment		     * @param value
actionscript	comment		     *
actionscript	comment		     */
actionscript	code		    override flash_proxy function setProperty(name:*, value:*):void
actionscript	code		    {
actionscript	code		        overloadSetProperty(name, value)
actionscript	code		    }
actionscript	blank	
actionscript	code		    protected function overloadSetProperty(name:*, value:*):void
actionscript	code		    {
actionscript	code		    	__item[name] = value;
actionscript	code		    }
actionscript	blank	
actionscript	comment		   	/**
actionscript	comment		     * Check if the property exits
actionscript	comment		     * @param name
actionscript	comment		     * @param value
actionscript	comment		     *
actionscript	comment		     */
actionscript	code		    override flash_proxy function hasProperty(name:*):Boolean
actionscript	code		    {
actionscript	code		    	if (__item[name])
actionscript	code		    	{
actionscript	code		    		return true;
actionscript	code		    	}
actionscript	code		    	return false;
actionscript	code		    }
actionscript	code		}
actionscript	code	}
