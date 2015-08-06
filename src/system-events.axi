PROGRAM_NAME='system-events'

#if_not_defined __SYSTEM_EVENTS__
#define __SYSTEM_EVENTS__

#include 'system-devices'
#include 'system-structures'
#include 'system-constants'
#include 'system-variables'
#include 'system-functions'
#include 'system-library-api'
#include 'system-library-control'
#include 'system-rms-api'

#include 'debug'
#include 'wake-on-lan'


/*
 * --------------------
 * Events
 * --------------------
 */

define_event


/*
 * --------------------
 * Data events
 * --------------------
 */


data_event[vdvRmsGui]
{
	online:
	{
		RmsSetDefaultEventBookingDuration(bookingTime)
	}
}


channel_event[vdvRms,0]
{
	on:
	{
		switch (channel.channel)
		{
			case RMS_CHANNEL_CLIENT_ONLINE: // connection to RMS established
			{
				RmsBookingActiveRequest (rmsSchedule.locationId)
				RmsBookingNextActiveRequest (rmsSchedule.locationId)
				moderoSetPage (dvTpSchedulingMain, pageWelcomePanelRmsConnected)
				wait 30	// wait 3 seconds (just so we see the "connected" message for more than a split second)
				{
					lockWelcomePanel ()
				}
			}
		}
	}
	off:
	{
		switch (channel.channel)
		{
			case RMS_CHANNEL_CLIENT_ONLINE:	// lost connection to RMS
			{
				moderoSetPage (dvTpSchedulingMain, pageWelcomePanelRmsConnecting)
				moderoDisableAllPopups (dvTpSchedulingMain)
			}
		}
	}
}

data_event[dvTpTableRmsCustom]
{
	online:
	{
		if (rmsSchedule.bookingIdCurrentMeeting != '')
			showCurrentMeetingInfoOnTableSplashScreen ()
		else if (rmsSchedule.bookingIdNextMeeting != '')
			showNextMeetingInfoOnTableSplashScreen ()
		else
			showNoMeetingsTodayInfoOnTableSplashScreen ()
	}
}

data_event[dvTpSchedulingRms]
{
	online:
	{
		moderoDisableAllPopups (dvTpSchedulingMain)
		if ([vdvRms,RMS_CHANNEL_CLIENT_ONLINE])
		{
			lockWelcomePanel ()
			
			if (rmsSchedule.bookingIdCurrentMeeting != '')
				showCurrentMeetingInfoCardOnWelcomePanel ()
			else if (rmsSchedule.bookingIdNextMeeting != '')
				showNextMeetingInfoCardOnWelcomePanel ()
			else
				hideMeetingInfoCardOnWelcomePanel()
		}
		else
		{
			moderoSetPage (dvTpSchedulingMain, pageWelcomePanelRmsConnecting)
		}
	}
}

button_event[dvTpSchedulingRmsCustom, 0]
{
	push:
	{
		switch (button.input.channel)
		{
			case 20:	// meet now
			{
				// book a meeting for right now
				RmsBookingCreate (LDATE,
				                  TIME,
				                  bookingTime,
				                  "adHocBookingSubjectHeader,currentUserSchedulingPanel.name",
				                  "adHocBookingDescriptionHeader,currentUserSchedulingPanel.name",
				                  rmsSchedule.locationId)
				
				waitingForAdhocBookingResponse = true
			}
			
			case 21:	// meet next
			{
				// book the next meeting
				RmsBookingCreate (LDATE,
				                  rmsSchedule.currentMeetingEndTime,
				                  bookingTime,
				                  "adHocBookingSubjectHeader,currentUserSchedulingPanel.name",
				                  "adHocBookingDescriptionHeader,currentUserSchedulingPanel.name",
				                  rmsSchedule.locationId)
				
				waitingForAdhocBookingResponse = true
			}
		}
	}
}





data_event[dvDvxMain]
{
	online:
	{
		dvxRequestVideoInputNameAll (dvDvxMain)
		dvxRequestVideoInputStatusAll (dvDvxMain)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorLeft.port)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorRight.port)
		dvxRequestInputAudio (dvDvxMain, dvDvxAudOutSpeakers.port)
		dvxRequestAudioOutputMute (dvDvxAudOutSpeakers)
		dvxSetAudioOutputMaximumVolume (dvDvxAudOutSpeakers, volumeMax)
		dvxRequestAudioOutputVolume (dvDvxAudOutSpeakers)
	}
}

// Configure Resolutions for Multi-Preview Input and associated DVX Output
data_event[dvDvxVidOutMultiPreview]
data_event[dvTpTableMain]
{
	online:
	{
		select
		{
			active (data.device == dvDvxVidOutMultiPreview):
			{
				dvxSetVideoOutputResolution (dvDvxVidOutMultiPreview, DVX_VIDEO_OUTPUT_RESOLUTION_1280x720p_60HZ)
				dvxSetVideoOutputAspectRatio (dvDvxVidOutMultiPreview, DVX_ASPECT_RATIO_STRETCH)
			}
			
			active (data.device == dvTpTableMain):
				moderoSetMultiPreviewInputFormatAndResolution (dvTpTableMain, MODERO_MULTI_PREVIEW_INPUT_FORMAT_HDMI, MODERO_MULTI_PREVIEW_INPUT_RESOLUTION_HDMI_1280x720p30HZ)
		}
	}
}

data_event[dvPduMain1]
{
	online:
	{
		pduRequestVersion (dvPduMain1)
		pduRequestSerialNumber (dvPduMain1)
		pduRequestPersistStateAllOutlets (dvPduMain1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_2)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_3)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_4)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_5)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_6)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_7)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_8)
		WAIT 50   // putting a wait here because the PDU seems to set the temp scale back to fahrenheit if it is set to celcius immediately after coming online
		pduSetTempScaleCelcius (dvPduMain1)
	}
}

data_event [vdvDragAndDropTpTable]
{
    online:
    {
		// Define drag/drop items - they will automatically be enabled by the module
		addDragItemsAll (vdvDragAndDropTpTable)
		addDropAreasAll (vdvDragAndDropTpTable)
	}
    string:
    {
		stack_var char header[50]
		
		header = remove_string (data.text,DELIM_HEADER,1)
		
		switch (header)
		{
			case 'DRAG_ITEM_SELECTED-':
			{
				enableDropItemsAll (vdvDragAndDropTpTable)
				
				animateTpVideoSourceSelectionOpen()
			}
			
			case 'DRAG_ITEM_DESELECTED-':
			{
				stack_var integer idDragItem
				
				idDragItem = atoi(data.text)
				
				// reset the draggable popup position by hiding it and then showing it again
				resetDraggablePopup (vdvDragAndDropTpTable, idDragItem)
				
				disableDropAreasAll (vdvDragAndDropTpTable)
			}
			
			case 'DRAG_ITEM_ENTER_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						channelOn (dvTpTableVideo, BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_LEFT)
					}
					
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
						channelOn (dvTpTableVideo, BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_RIGHT)
					}
				}
			}
			
			case 'DRAG_ITEM_EXIT_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						channelOff (dvTpTableVideo, BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_LEFT)
					}
					
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
						channelOff (dvTpTableVideo, BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_RIGHT)
					}
				}
			}
			
			case 'DRAG_ITEM_DROPPED_ON_DROP_AREA-':
			{
				local_var integer idDragItem
				local_var integer idDropArea
				stack_var integer btnDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				disableDropAreasAll (vdvDragAndDropTpTable)
				
				resetDraggablePopup (vdvDragAndDropTpTable, idDragItem)
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						
						if (dvx.videoInputs[idDragItem].status != DVX_SIGNAL_STATUS_VALID_SIGNAL)
						{
							moderoEnablePopup (dvTpTableVideo, POPUP_NAME_NO_SIGNAL_ARE_YOU_SURE)
							wait_until (userAcknowledgedSelectingInputWithNoSignal) 'WAITING_FOR_USER_TO_ACKNOWLEDGE_SENDING_NO_SIGNAL_INPUT_TO_MONITOR'
							{
								userAcknowledgedSelectingInputWithNoSignal = false
								sendSelectedInputToLeftMonitor (idDragItem, idDropArea)
							}
						}
						else
						{
							sendSelectedInputToLeftMonitor (idDragItem, idDropArea)
						}
					}
					
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
					
						if (dvx.videoInputs[idDragItem].status != DVX_SIGNAL_STATUS_VALID_SIGNAL)
						{
							moderoEnablePopup (dvTpTableVideo, POPUP_NAME_NO_SIGNAL_ARE_YOU_SURE)
							wait_until (userAcknowledgedSelectingInputWithNoSignal) 'WAITING_FOR_USER_TO_ACKNOWLEDGE_SENDING_NO_SIGNAL_INPUT_TO_MONITOR'
							{
								userAcknowledgedSelectingInputWithNoSignal = false
								sendSelectedInputToRightMonitor (idDragItem, idDropArea)
							}
						}
						else
						{
							sendSelectedInputToRightMonitor (idDragItem, idDropArea)
						}
					}
					
					active (idDropArea == dvDvxVidOutMultiPreview.port):
					{
						showSourceOnDisplay (idDragItem, idDropArea)
						
						sendCommand (vdvMultiPreview, "'VIDEO_PREVIEW-',itoa(idDragItem)")
					}
				}
			}
			
			case 'DRAG_ITEM_NOT_LEFT_DRAG_AREA_WITHIN_TIME-': {}
		}
    }
}


data_event [dvTpTableVideo]
{
	online:
	{
		moderoEnableButtonScaleToFit (dvTpTableVideo, BTN_ADR_VIDEO_MONITOR_LEFT_PREVIEW_SNAPSHOT, MODERO_BUTTON_STATE_ALL)
		moderoEnableButtonScaleToFit (dvTpTableVideo, BTN_ADR_VIDEO_MONITOR_RIGHT_PREVIEW_SNAPSHOT, MODERO_BUTTON_STATE_ALL)
	}
}

data_event[dvTpSchedulingMain]
{
	online:
	{
		moderoEnablePageTracking(dvTpSchedulingMain)
	}
}

data_event[dvTpTableMain]
{
	online:
	{
		/*
		 * --------------------
		 * Request info from connected devices.
		 *
		 * This will solicit a response which will in turn update button feedback.
		 * --------------------
		 */

		// DVX
		dvxRequestVideoInputNameAll (dvDvxMain)
		dvxRequestVideoInputStatusAll (dvDvxMain)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorLeft.port)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorRight.port)
		dvxRequestInputAudio (dvDvxMain, dvDvxAudOutSpeakers.port)
		dvxRequestAudioOutputMute (dvDvxAudOutSpeakers)
		dvxRequestAudioOutputVolume (dvDvxAudOutSpeakers)
		dvxRequestAudioOutputMaximumVolume (dvDvxAudOutSpeakers)

		// DXLink Rx - Left monitor
		dxlinkRequestRxVideoOutputResolution (dvRxMonitorLeftVidOut)
		dxlinkRequestRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut)
		dxlinkRequestRxVideoOutputScaleMode (dvRxMonitorLeftVidOut)

		// DXLink Rx - Right monitor
		dxlinkRequestRxVideoOutputResolution (dvRxMonitorRightVidOut)
		dxlinkRequestRxVideoOutputAspectRatio (dvRxMonitorRightVidOut)
		dxlinkRequestRxVideoOutputScaleMode (dvRxMonitorRightVidOut)

		// DXLink Tx's
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable1Main)
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable2Main)
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable3Main)
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable4Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable1Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable2Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable3Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable4Main)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable1VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable2VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable3VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable4VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable1VidInDigital)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable2VidInDigital)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable3VidInDigital)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable4VidInDigital)

		// PDU
		pduRequestVersion (dvPduMain1)
		pduRequestSerialNumber (dvPduMain1)
		pduRequestPersistStateAllOutlets (dvPduMain1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_2)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_3)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_4)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_5)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_6)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_7)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_8)
		
		// Panel
		moderoEnablePageTracking(dvTpTableMain)

		// Update button text for PDU button labels
		{
			stack_var integer i

			for (i = 1; i <= PDU_MAX_OUTLETS; i++)
			{
				moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_OUTLET_LABELS[i], MODERO_BUTTON_STATE_ALL, LABELS_PDU_OUTLETS[i])
			}
		}
	}
}

data_event[dvTxTable1Main]
data_event[dvTxTable2Main]
data_event[dvTxTable3Main]
data_event[dvTxTable4Main]
{
	online:
	{
		dxlinkRequestTxVideoInputAutoSelect (data.device)
		dxlinkRequestTxSelectedVideoInput (data.device)
	}
}

data_event[dvTxTable1VidInAnalog]
data_event[dvTxTable2VidInAnalog]
data_event[dvTxTable3VidInAnalog]
data_event[dvTxTable4VidInAnalog]
{
	online:
	{
		dxlinkRequestTxVideoInputSignalStatusAnalog (data.device)
	}
}

data_event[dvTxTable1VidInDigital]
data_event[dvTxTable2VidInDigital]
data_event[dvTxTable3VidInDigital]
data_event[dvTxTable4VidInDigital]
{
	online:
	{
		dxlinkRequestTxVideoInputSignalStatusDigital (data.device)
	}
}

data_event[dvRxMonitorLeftVidOut]
data_event[dvRxMonitorRightVidOut]
{
	online:
	{
		dxlinkRequestRxVideoOutputResolution (data.device)
		dxlinkRequestRxVideoOutputAspectRatio (data.device)
		dxlinkRequestRxVideoOutputScaleMode (data.device)
	}
}


/*
 * --------------------
 * Button events
 * --------------------
 */




button_event[dvTpTableAudio,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_AUDIO_VOLUME_DN:    dvxEnableAudioOutputVolumeRampDown (dvDvxAudOutSpeakers)
			case BTN_AUDIO_VOLUME_UP:    dvxEnableAudioOutputVolumeRampUp (dvDvxAudOutSpeakers)
			case BTN_AUDIO_VOLUME_MUTE:  dvxCycleAudioOutputVolumeMute (dvDvxAudOutSpeakers)

			case BTN_AUDIO_INPUT_01:     dvxSwitchAudioOnly (dvDvxMain, 1, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_02:     dvxSwitchAudioOnly (dvDvxMain, 2, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_03:     dvxSwitchAudioOnly (dvDvxMain, 3, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_04:     dvxSwitchAudioOnly (dvDvxMain, 4, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_05:     dvxSwitchAudioOnly (dvDvxMain, 5, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_06:     dvxSwitchAudioOnly (dvDvxMain, 6, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_07:     dvxSwitchAudioOnly (dvDvxMain, 7, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_08:     dvxSwitchAudioOnly (dvDvxMain, 8, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_09:     dvxSwitchAudioOnly (dvDvxMain, 9, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_10:     dvxSwitchAudioOnly (dvDvxMain, 10, dvDvxAudOutSpeakers.port)

			case BTN_AUDIO_FOLLOW_MONITOR_LEFT:
			{
				audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
				dvxSwitchAudioOnly (dvDvxMain, selectedVideoInputMonitorLeft, dvDvxAudOutSpeakers.port)
			}
			case BTN_AUDIO_FOLLOW_MONITOR_RIGHT:
			{
				audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
				dvxSwitchAudioOnly (dvDvxMain, selectedVideoInputMonitorRight, dvDvxAudOutSpeakers.port)
			}
		}
	}
	release:
	{
		switch (button.input.channel)
		{
			case BTN_AUDIO_VOLUME_DN:    dvxDisableAudioOutputVolumeRampDown (dvDvxAudOutSpeakers)
			case BTN_AUDIO_VOLUME_UP:    dvxDisableAudioOutputVolumeRampUp (dvDvxAudOutSpeakers)
		}
	}
}


button_event[dvTpTableVideo,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_VIDEO_MONITOR_LEFT_OFF:     necMonitorSetPowerOff (vdvMonitorLeft)
			case BTN_VIDEO_MONITOR_LEFT_ON:      necMonitorSetPowerOn (vdvMonitorLeft)
			case BTN_VIDEO_MONITOR_RIGHT_OFF:    necMonitorSetPowerOff (vdvMonitorRight)
			case BTN_VIDEO_MONITOR_RIGHT_ON:     necMonitorSetPowerOn (vdvMonitorRight)
			
			case BTN_USER_ACKNOWLEDGE_SEND_INPUT_NO_SIGNAL_TO_MONITOR_NO:
			{
				userAcknowledgedSelectingInputWithNoSignal = false
				cancel_wait 'WAITING_FOR_USER_TO_ACKNOWLEDGE_SENDING_NO_SIGNAL_INPUT_TO_MONITOR'
				channelOff (dvTpTableVideo, BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_LEFT)
				channelOff (dvTpTableVideo, BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_RIGHT)
			}
			
			case BTN_USER_ACKNOWLEDGE_SEND_INPUT_NO_SIGNAL_TO_MONITOR_YES:
			{
				userAcknowledgedSelectingInputWithNoSignal = true
			}
		}
	}
}

button_event[dvTpTableLighting,0]
{
	push:
	{
		min_to [button.input]

		switch (button.input.channel)
		{
			case BTN_LIGHTING_PRESET_ALL_OFF:    lightsEnablePresetAllOff()
			case BTN_LIGHTING_PRESET_ALL_ON:     lightsEnablePresetAllOn()
			case BTN_LIGHTING_PRESET_ALL_DIM:    lightsEnablePresetAllDim()
			case BTN_LIGHTING_PRESET_VC_MODE:    lightsEnablePresetVc()
		}
	}
}


button_event[dvTpTablePower,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_POWER_TOGGLE_MONITOR_LEFT:  pduToggleRelayPower (dvPduOutletMonitorLeft)
			case BTN_POWER_TOGGLE_MONITOR_RIGHT: pduToggleRelayPower (dvPduOutletMonitorRight)
			case BTN_POWER_TOGGLE_PDXL2:         pduToggleRelayPower (dvPduOutletPdxl2)

			case BTN_POWER_TOGGLE_MULTI_PREVIEW:
			{
				// Cycle power on the PDU
				pduDisableRelayPower (dvPduOutletMultiPreview)
				wait waitTimePowerCycle
				{
					pduEnableRelayPower (dvPduOutletMultiPreview)
				}
			}

			case BTN_POWER_TOGGLE_PC:        pduToggleRelayPower (dvPduOutletPc)
			case BTN_POWER_TOGGLE_FAN_1:     pduToggleRelayPower (dvPduOutletFan1)
			case BTN_POWER_TOGGLE_FAN_2:     pduToggleRelayPower (dvPduOutletFan2)

			case BTN_POWER_TEMPERATURE_SCALE_TOGGLE:     channelToggle (dvPduMain1,PDU_CHANNEL_TEMP_SCALE)
			case BTN_POWER_TEMPERATURE_SCALE_CELCIUS:    pduSetTempScaleCelcius (dvPduMain1)
			case BTN_POWER_TEMPERATURE_SCALE_FAHRENHEIT: pduSetTempScaleFahrenheit (dvPduMain1)
		}
	}
}

#warn 'finish programming Enzo control button event'
button_event[dvTpTableEnzo,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_ENZO_HOME:						enzoHome (dvEnzo)
			case BTN_ENZO_BACK:						enzoBack (dvEnzo)
			case BTN_ENZO_ENTER:					enzoEnter (dvEnzo)
			case BTN_ENZO_START_SESSION:			enzoSessionStart (dvEnzo)
			case BTN_ENZO_END_SESSION:				enzoSessionEnd (dvEnzo)
			case BTN_ENZO_UP:						enzoUp (dvEnzo)
			case BTN_ENZO_DOWN:						enzoDown (dvEnzo)
			case BTN_ENZO_LEFT:						enzoLeft (dvEnzo)
			case BTN_ENZO_RIGHT:					enzoRight (dvEnzo)
			case BTN_ENZO_PLAY:						enzoPlay (dvEnzo)
			case BTN_ENZO_PAUSE:					enzoPause (dvEnzo)
			case BTN_ENZO_STOP:						enzoStop (dvEnzo)
			case BTN_ENZO_FFWD:						enzoFfwd (dvEnzo)
			case BTN_ENZO_REWIND:					enzoRewind (dvEnzo)
			case BTN_ENZO_PAGE_DOWN:				enzoPageDown (dvEnzo)
			case BTN_ENZO_PAGE_UP:					enzoPageUp (dvEnzo)
			case BTN_ENZO_PREVIOUS:					enzoPrevious(dvEnzo)
			case BTN_ENZO_NEXT:						enzoNext (dvEnzo)
		}
	}
}


button_event[dvTpTableDxlink,0]
{
	push:
	{
		// button feedback
		on[button.input]

		switch (button.input.channel)
		{
			// TX - Auto
			case BTN_DXLINK_TX_AUTO_1:   dxlinkEnableTxVideoInputAutoSelectPriotityDigital (dvTxTable1Main)
			case BTN_DXLINK_TX_AUTO_2:   dxlinkEnableTxVideoInputAutoSelectPriotityDigital (dvTxTable2Main)
			case BTN_DXLINK_TX_AUTO_3:   dxlinkEnableTxVideoInputAutoSelectPriotityDigital (dvTxTable3Main)
			case BTN_DXLINK_TX_AUTO_4:   dxlinkEnableTxVideoInputAutoSelectPriotityDigital (dvTxTable4Main)

			// TX - HDMI
			case BTN_DXLINK_TX_HDMI_1:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable1Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable1VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable1Main)
			}
			case BTN_DXLINK_TX_HDMI_2:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable2Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable2VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable2Main)
			}
			case BTN_DXLINK_TX_HDMI_3:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable3Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable3VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable3Main)
			}
			case BTN_DXLINK_TX_HDMI_4:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable4Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable4VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable4Main)
			}

			// TX - VGA
			case BTN_DXLINK_TX_VGA_1:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable1Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable1VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable1Main)
			}
			case BTN_DXLINK_TX_VGA_2:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable2Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable2VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable2Main)
			}
			case BTN_DXLINK_TX_VGA_3:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable3Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable3VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable3Main)
			}
			case BTN_DXLINK_TX_VGA_4:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable4Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable4VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable4Main)
			}

			// RX - Scaler Auto
			case BTN_DXLINK_RX_SCALER_AUTO_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorLeftVidOut, DXLINK_SCALE_MODE_AUTO)
			}
			case BTN_DXLINK_RX_SCALER_AUTO_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorRightVidOut, DXLINK_SCALE_MODE_AUTO)
			}

			// RX - Scaler Bypass
			case BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorLeftVidOut, DXLINK_SCALE_MODE_BYPASS)
			}
			case BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorRightVidOut, DXLINK_SCALE_MODE_BYPASS)
			}

			// RX - Scaler Manual
			case BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorLeftVidOut, DXLINK_SCALE_MODE_MANUAL)
			}
			case BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorRightVidOut, DXLINK_SCALE_MODE_MANUAL)
			}

			// RX - Aspect Maintain
			case BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_MAINTAIN)
			}
			case BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_MAINTAIN)
			}

			// RX - Aspect Stretch
			case BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_STRETCH)
			}
			case BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_STRETCH)
			}

			// RX - Aspect Zoom
			case BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_ZOOM)
			}
			case BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_ZOOM)
			}

			// RX - Aspect Anamorphic
			case BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_ANAMORPHIC)
			}
			case BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_ANAMORPHIC)
			}
		}
	}
}

button_event[dvTpTableDebug,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_DEBUG_REBUILD_EVENT_TABLE:
			{
				rebuild_event ()
				debugPrint ('**** Event Table Rebuilt ****')
			}
			case BTN_DEBUG_WAKE_ON_LAN_PC:
			{
				//wakeOnLan (MAC_ADDRESS_PC)
			}
		}
	}
}

button_event[dvTpTableMain, 0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_MAIN_SHUT_DOWN:
			{
				shutdownAvSystem ()
				userShutdown ()
			}

			case BTN_MAIN_SPLASH_SCREEN:
			{
				// page flips done on the panel
			}
		}
	}
}

button_event [dvTpTableDebug, 1]	// exit monitor selection animation
{
    push:
    {
		animateTpVideoSourceSelectionClose()
		
		sendCommand (vdvMultiPreview, "'SNAPSHOTS'")
    }
}

button_event [dvTpTableDebug, 2]	// select left monitor
button_event [dvTpTableDebug, 3]	// select right monitor
{
    push:
    {
		stack_var integer input
		
		switch (button.input.channel)
		{
			case 2:		showSourceControlPopup (selectedVideoInputMonitorLeft)
			
			case 3:		showSourceControlPopup (selectedVideoInputMonitorRight)
		}
    }
}

data_event[dvIrAppleTv]
{
	online:
	{	
		// Apple TV IR codes are fast and repeating.
		// Need to limit the amount of time we emit the IR for in order to avoid double-pulses
		amxIrSetOnTime (dvIrAppleTv, 2)
		amxIrSetOffTime (dvIrAppleTv, 5)
	}
}

button_event [dvTpTableAppleTv,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_APPLE_TV_PLAY_PAUSE: amxIrStackPulse (dvIrAppleTv,IR_APPLE_TV_PLAY_PAUSE)
			case BTN_APPLE_TV_MENU:       amxIrStackPulse (dvIrAppleTv,IR_APPLE_TV_MENU)
			case BTN_APPLE_TV_SELECT:     amxIrStackPulse (dvIrAppleTv,IR_APPLE_TV_SELECT)
			case BTN_APPLE_TV_UP:         amxIrStackPulse (dvIrAppleTv,IR_APPLE_TV_UP)
			case BTN_APPLE_TV_DOWN:       amxIrStackPulse (dvIrAppleTv,IR_APPLE_TV_DOWN)
			case BTN_APPLE_TV_LEFT:       amxIrStackPulse (dvIrAppleTv,IR_APPLE_TV_LEFT)
			case BTN_APPLE_TV_RIGHT:      amxIrStackPulse (dvIrAppleTv,IR_APPLE_TV_RIGHT)
		}
	}
}


/*
 * --------------------
 * Level events
 * --------------------
 */

level_event[dvTpTableAudio, BTN_LVL_VOLUME_CONTROL]
{
	dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, level.value)
}



data_event[dvTpTableMain]
{
	string:
	{
		if ( (find_string(data.text, '@PPF-',1) == 1) or
			 (find_string(data.text, 'PPOF-',1) == 1) )
		{
			remove_string (data.text,"'-'",1)
			
			if (find_string(data.text,POPUP_NAME_SOURCE_SELECTION,1) == 1)
			{
				// deactivate the source selection drag areas
				disableDragItemsAll (vdvDragAndDropTpTable)
				do_push(dvTpTableDebug,1)
			}
			else if (find_string(data.text,POPUP_NAME_SOURCE_CONTROL,1) == 1)
			{
				// activate the source selection drag areas
				enableDragItemsAll (vdvDragAndDropTpTable)
				sendCommand (vdvMultiPreview, 'SNAPSHOTS')
			}
			else if ( (find_string(data.text,POPUP_NAME_CONFIRM_SHUTDOWN,1) == 1) or
			          (find_string(data.text,POPUP_NAME_MEETING_ENDING_WITH_EXTEND_OPTION,1) == 1) or
			          (find_string(data.text,POPUP_NAME_MEETING_ENDING_NO_EXTEND_OPTION,1) == 1) or
			          (find_string(data.text,POPUP_NAME_MEETING_EXTEND_REQUEST_IN_PROGRESS,1) == 1) or
			          (find_string(data.text,POPUP_NAME_MEETING_EXTEND_SUCCESS,1) == 1) or
			          (find_string(data.text,POPUP_NAME_MEETING_EXTEND_FAILURE,1) == 1) )
			{
				// activate the source selection drag areas
				enableDragItemsAll (vdvDragAndDropTpTable)
			}
		}
		else if ( (find_string(data.text, '@PPN-',1) == 1) or
				  (find_string(data.text, 'PPON-',1) == 1) )
		{
			remove_string (data.text,"'-'",1)
			
			if (find_string(data.text,POPUP_NAME_SOURCE_SELECTION,1) == 1)
			{
					// activate the source selection drag areas
					enableDragItemsAll (vdvDragAndDropTpTable)
			}
			else if ( (find_string(data.text,POPUP_NAME_CONFIRM_SHUTDOWN,1) == 1) or
			          (find_string(data.text,POPUP_NAME_SOURCE_CONTROL,1) == 1) or
			          (find_string(data.text,POPUP_NAME_MEETING_ENDING_WITH_EXTEND_OPTION,1) == 1) or
			          (find_string(data.text,POPUP_NAME_MEETING_ENDING_NO_EXTEND_OPTION,1) == 1) or
			          (find_string(data.text,POPUP_NAME_MEETING_EXTEND_REQUEST_IN_PROGRESS,1) == 1) or
			          (find_string(data.text,POPUP_NAME_MEETING_EXTEND_SUCCESS,1) == 1) or
			          (find_string(data.text,POPUP_NAME_MEETING_EXTEND_FAILURE,1) == 1) )
			{
				// deactivate the source selection drag areas
				disableDragItemsAll (vdvDragAndDropTpTable)
			}
		}
	}
}


data_event[dvTpSchedulingMain]
{
	string:
	{
		if ( (find_string(data.text, '@PPF-',1) == 1) or
			 (find_string(data.text, 'PPOF-',1) == 1) )
		{
			remove_string (data.text,"'-'",1)
			
			if ( (find_string(data.text,POPUP_NAME_SELECT_DURATION_MEETING_NOW,1) == 1) or
				 (find_string(data.text,POPUP_NAME_SELECT_DURATION_MEETING_NEXT,1) == 1) )
			{
				schedulingPanelShowingSelectBookingDurationMessage = false
			}
		}
		else if ( (find_string(data.text, '@PPN-',1) == 1) or
				  (find_string(data.text, 'PPON-',1) == 1) )
		{
			remove_string (data.text,"'-'",1)
			
			if ( (find_string(data.text,POPUP_NAME_SELECT_DURATION_MEETING_NOW,1) == 1) or
				 (find_string(data.text,POPUP_NAME_SELECT_DURATION_MEETING_NEXT,1) == 1) )
			{
				schedulingPanelShowingSelectBookingDurationMessage = true
			}
		}
	}
}



data_event[vdvSimulation]
{
	command:
	{
		switch (data.text)
		{
			case 'MEETING_STARTED':
			{
				meetingStarted()
			}
			
			case 'MEETING_ENDED':
			{
				meetingEnded()
			}
			
			case 'USER_SHUTDOWN_BEFORE_MEETING_ENDED':
			{
			}
		}
	}
}


custom_event[dvTpSchedulingMain,1,700]	// NFC tap on scheduling panel
{
    stack_var char    cUid[40]
	
	// custom.text contains the unique ID from the NFC device
	cUid = custom.text
	
	debugPrint ("'NFC tap on scheduling panel. Tag = [',cUid,']'")
	
	nfcTagDetectedWelcomePanel (cUid)
}


custom_event[dvTpTableMain,1,700]	// NFC tap on table panel
{
    stack_var char    cUid[40]
	
	// custom.text contains the unique ID from the NFC device
	cUid = custom.text
	
	debugPrint ("'NFC tap on table panel. Tag = [',cUid,']'")
	
	nfcTagDetectedTablePanel (cUid)
}


button_event[dvTpSchedulingRmsCustom,BTN_SCHEDULING_USER_LOG_OUT]
{
	push:
	{
		lockWelcomePanel ()
	}
}


data_event[dvTpSchedulingMain]
{
	online:
	{
		// track X/Y press/move/release touch coordinates on the scheduling panel
		// this is just so we can better guage when the user is actually interacting
		// with the panel. If we rely solely on button events we don't get a true picture
		// as some buttons on the panel do not have channel codes
		// not tracking move as this will reduce processing and it's unlikely that the user 
		// will continue to hold their finger on the screen moving it around for the amount
		// of time required to detect no user interaction and lock the welcome panel
		moderoEnableTouchCoordinateTrackingPressRelease (dvTpSchedulingMain)
	}
}


button_event[dvTpTableRmsCustom,BTN_TABLE_PANEL_EXTEND_MEETING]
{
	push:
	{
		// request a meeting extension
		RmsBookingExtend(rmsSchedule.bookingIdCurrentMeeting,
                         minutesToExtendBooking,
                         rmsSchedule.locationId)
		
		moderoEnablePopupOnPage (dvTpTableMain, POPUP_NAME_MEETING_EXTEND_REQUEST_IN_PROGRESS, PAGE_NAME_MAIN_USER)
		// deactivate the source selection drag areas
		disableDragItemsAll (vdvDragAndDropTpTable)
	}
}

button_event[dvTpSchedulingRmsCustom,BTN_SCHEDULING_MAKE_RESERVATION]
{
	push:
	{
		// book a meeting using the RMS Gui
		sendCommand (vdvRmsGui, "'CREATE.MEETING.REQUEST.SUBJECT-',debugDevToString(dvTpSchedulingMain),',',adHocBookingSubjectHeader,currentUserSchedulingPanel.name")
		sendCommand (vdvRmsGui, "'CREATE.MEETING.REQUEST.MESSAGE-',debugDevToString(dvTpSchedulingMain),',',adHocBookingDescriptionHeader,currentUserSchedulingPanel.name")
	}
}


#end_if