/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.net.rtmpstreaming
{
	import flash.events.NetStatusEvent;
	
	CONFIG::LOGGING
	{
	import org.osmf.logging.Logger;
	import org.osmf.logging.Log;
	}
	
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.SwitchingRuleBase;
	import org.osmf.utils.OSMFStrings;
	
	/**
	 * InsufficientBufferRule is a switching rule that switches down when
	 * the buffer has insufficient data.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class newRule extends SwitchingRuleBase
	{
		/**
		 * Constructor.
		 * 
		 * @param metrics The metrics provider used by this rule to determine
		 * whether to switch.
		 * @param minBufferLength The minimum buffer length that must be
		 * maintained before the rule suggests a switch down.  The default
		 * value is 2 seconds.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function newRule(metrics:RTMPNetStreamMetrics)
		{
			super(metrics);
		}
				
		/**
		 * @private
		 */
		override public function getNewIndex():int
		{
			var newIndex:int = -1;
			
			/*if (_panic || (rtmpMetrics.netStream.bufferLength < minBufferLength && rtmpMetrics.netStream.bufferLength > rtmpMetrics.netStream.bufferTime))
			{
				CONFIG::LOGGING
				{
					if (!_panic)
					{
						debug("Buffer of " + Math.round(rtmpMetrics.netStream.bufferLength)  + " < " + minBufferLength + " seconds");
					}
				}
				
				newIndex = 0;
			}*/

			if(rtmpMetrics.netStream.bufferLength < 5)
			{
				newIndex = decreaseIndex();
			}
			else if(rtmpMetrics.netStream.bufferLength > 9)
			{
				newIndex = increaseIndex();
			}
			
			CONFIG::LOGGING
			{
				if (newIndex != -1)
				{
					debug("getNewIndex() - about to return: " + newIndex + ", detail=" + _moreDetail);
				}
			} 
			
			return newIndex;
		}
		
		
		private function get rtmpMetrics():RTMPNetStreamMetrics
		{
			return metrics as RTMPNetStreamMetrics;
		}

		private function increaseIndex():int
		{
			if(rtmpMetrics.currentIndex == rtmpMetrics.resource.streamItems.length - 1)
			{
				return rtmpMetrics.currentIndex;
			}
			else
			{
				return rtmpMetrics.currentIndex+1;
			}
		}

		private function decreaseIndex():int
		{
			if(rtmpMetrics.currentIndex == 0)
			{
				return rtmpMetrics.currentIndex;
			}
			else
			{
				return rtmpMetrics.currentIndex-1;
			}
		}

		CONFIG::LOGGING
		{
			private function debug(s:String):void
			{
				logger.debug(s);
			}
		}

		private var _moreDetail:String;
		private var minBufferLength:Number;
				
		CONFIG::LOGGING
		{
			private static const logger:Logger = Log.getLogger("org.osmf.net.rtmpstreaming.newRule");
		}
	}
}
