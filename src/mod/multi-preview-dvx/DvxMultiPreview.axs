MODULE_NAME='DvxMultiPreview' (dev vdvApi,
                               dev dvTp,
                               dev dvDvxSwitcherVidOutMultiPreview,
                               integer BTNS_DVX_INPUT_SNAPSHOTS[],
                               integer BTNS_DVX_INPUT_LABELS[],
                               integer BTN_LOADING_VIDEO_PREVIEW,
                               integer BTN_VIDEO_PREVIEW_WINDOW,
                               char imageNameNoSignal[])


/*
	DvxMultiPreview module API
	--------------------------
	
	Control Commands
	----------------
	SNAPSHOTS_START
	SNAPSHOTS_STOP
	SNAPSHOT-<input>                e.g: SNAPSHOT-3
	VIDEO_PREVIEW_START-<input>     e.g: VIDEO_PREVIEW_STOP-4
	VIDEO_PREVIEW_STOP
*/



#DEFINE INCLUDE_DVX_MONITOR_SWITCHER_MAIN
#DEFINE INCLUDE_DVX_MONITOR_SWITCHER_VIDEO_INPUTS

#define INCLUDE_DVX_NOTIFY_SWITCH_CALLBACK
#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_STATUS_CALLBACK
#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_NAME_CALLBACK

define_device



#include 'amx-device-control'
#include 'amx-dvx-control'
#include 'amx-modero-control'

define_constant

/*integer BTNS_DVX_INPUT_SNAPSHOTS[] = {11,12,13,14,15,16,17,18,19,20}
integer BTNS_DVX_INPUT_LABELS[]    = {21,22,23,24,25,26,27,28,29,30}
integer BTN_LOADING_VIDEO_PREVIEW = 100
integer BTN_VIDEO_PREVIEW_WINDOW = 105*/

long TIMELINE_ID_SNAPSHOTS = 1

integer PREVIEW_MODE_STOP             = 0
integer PREVIEW_MODE_SNAPSHOTS        = 1
integer PREVIEW_MODE_SNAPSHOT_SINGLE  = 2
integer PREVIEW_MODE_VIDEO            = 3

char SNAPSHOT_IMAGE_RESOURCE_NAME_HEADER[] = 'SNAPSHOT_PREVIEW-'

define_variable

dev dvDvxMainPorts[1]
dev dvDvxVidInPorts[DVX_MAX_VIDEO_INPUTS]

dev dvTpPort1	// custom events come back on touch panel port #1

volatile _DvxSwitcher dvxSwitcher

long timelineTimes[] = {0,1000,1000}//{0,1000,500}	// switch,snapshot,wait

volatile integer inputPreview = 0
volatile integer inputPreviewVideo = 0

volatile integer resourceLoaded = TRUE
volatile integer switchToMplProcessed = TRUE
volatile integer streamLoaded = FALSE

volatile integer previewMode = PREVIEW_MODE_STOP

integer waitTimeToShowVideoPreviewButton = 50

#include 'debug'
#include 'amx-dvx-listener'
#include 'amx-modero-listener'


define_function initDevice (dev device, integer number, integer port, integer system)
{
	debugPrint("'multi-preview-dvx - ENTER function initDevice(...)'")
	debugPrint("' device = ',debugDevToString(device)")
	debugPrint("' number = ',itoa(number)")
	debugPrint("' port = ',itoa(port)")
	debugPrint("' system = ',itoa(system)")
	device.number = number
	device.port = port
	device.system = system
}

define_function addDeviceToDevArray (dev deviceArray[], dev device)
{
	if (length_array(deviceArray) < max_length_array(deviceArray))
	{
		set_length_array (deviceArray, (length_array(deviceArray)+1))
		deviceArray[length_array(deviceArray)] = device
	}
}

define_function dvxNotifySwitch (dev dvxPort1, char signalType[], integer input, integer output)
{
	// dvxPort1 is port 1 on the DVX.
	// signalType contains the type of signal that was switched ('AUDIO' or 'VIDEO')
	// input contains the source input number that was switched to the destination
	// output contains the destination output number that the source was switched to
	
	switch(signalType)
	{
		case 'AUDIO':
		{
			dvxSwitcher.switchStatusAudioInputs[input] = output
			dvxSwitcher.switchStatusAudioOutputs[output] = input
		}
		case 'VIDEO':
		{
			dvxSwitcher.switchStatusVideoInputs[input] = output
			dvxSwitcher.switchStatusVideoOutputs[output] = input
		
			if(output == dvDvxSwitcherVidOutMultiPreview.port)
			{
				if(((getPreviewMode() == PREVIEW_MODE_SNAPSHOTS) or (getPreviewMode() == PREVIEW_MODE_SNAPSHOT_SINGLE)) AND (switchToMplProcessed == FALSE))
				{
					switchToMplProcessed = TRUE
					timeline_restart(TIMELINE_ID_SNAPSHOTS)
				}
			}
		}
	}
}

define_function dvxNotifyVideoInputStatus (dev dvxVideoInput, char signalStatus[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// signalStatus is the input signal status (DVX_SIGNAL_STATUS_NO_SIGNAL | DVX_SIGNAL_STATUS_UNKNOWN | DVX_SIGNAL_STATUS_VALID_SIGNAL)
	
	
	switch(signalStatus)
	{
		case DVX_SIGNAL_STATUS_NO_SIGNAL:
		case DVX_SIGNAL_STATUS_UNKNOWN:
		{
			channelOff(dvTp,BTNS_DVX_INPUT_LABELS[dvxVideoInput.port])
			channelOff(dvTp,BTNS_DVX_INPUT_SNAPSHOTS[dvxVideoInput.port])
			
			if(dvxSwitcher.videoInputs[dvxVideoInput.port].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
			{
				moderoSetButtonBitmap (dvTp, BTNS_DVX_INPUT_SNAPSHOTS[dvxVideoInput.port], MODERO_BUTTON_STATE_ALL, imageNameNoSignal)
				
				if((getPreviewMode() == PREVIEW_MODE_SNAPSHOTS) and (inputPreview == dvxVideoInput.port))
				{
					restartSnapshots(getNextInputWithValidSignal(inputPreview))
				}
				else if((getPreviewMode() == PREVIEW_MODE_SNAPSHOT_SINGLE) and (inputPreview == dvxVideoInput.port))
				{
					stopSnapshots()
				}
			}
		}
		case DVX_SIGNAL_STATUS_VALID_SIGNAL:
		{
			channelOn(dvTp,BTNS_DVX_INPUT_LABELS[dvxVideoInput.port])
			channelOn(dvTp,BTNS_DVX_INPUT_SNAPSHOTS[dvxVideoInput.port])
			
			if((dvxSwitcher.videoInputs[dvxVideoInput.port].status == DVX_SIGNAL_STATUS_NO_SIGNAL) or
			   (dvxSwitcher.videoInputs[dvxVideoInput.port].status == DVX_SIGNAL_STATUS_UNKNOWN))
			{
				switch(getPreviewMode())
				{
					case PREVIEW_MODE_STOP:
					{
						if(resourceLoaded == FALSE)
						{
							timed_wait_until (resourceLoaded == TRUE) 50
							{
								takeSnapshot(dvxVideoInput.port)
							}
						}
						else
							takeSnapshot(dvxVideoInput.port)
					}
					case PREVIEW_MODE_SNAPSHOT_SINGLE:
					{
						timed_wait_until (getPreviewMode() == PREVIEW_MODE_STOP) 50
						{
							takeSnapshot(dvxVideoInput.port)
						}
					}
					case PREVIEW_MODE_SNAPSHOTS:
					{
						if(resourceLoaded == FALSE)
						{
							timed_wait_until (resourceLoaded == TRUE) 50
							{
								restartSnapshots(dvxVideoInput.port)
							}
						}
						else
							restartSnapshots(dvxVideoInput.port)
					}
					case PREVIEW_MODE_VIDEO:
					{
						// make sure that this is the first input to grab a snapshot of when snapshot mode resumes
						inputPreview = dvxVideoInput.port
						wait_until (getPreviewMode() != PREVIEW_MODE_VIDEO)
						{
							if((getPreviewMode() != PREVIEW_MODE_SNAPSHOTS) and (getPreviewMode() != PREVIEW_MODE_SNAPSHOT_SINGLE))
								takeSnapshot(inputPreview)
						}
					}
				}
			}
		}
	}

	dvxSwitcher.videoInputs[dvxVideoInput.port].status = signalStatus
}

define_function dvxNotifyVideoInputName (dev dvxVideoInput, char name[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// name is the name of the video input
	
	dvxSwitcher.videoInputs[dvxVideoInput.port].name = name
	moderoSetButtonText (dvTp, BTNS_DVX_INPUT_LABELS[dvxVideoInput.port], MODERO_BUTTON_STATE_ALL, name)
}


define_function char[100] getResourceName(integer input)
{
	return "SNAPSHOT_IMAGE_RESOURCE_NAME_HEADER,itoa(input)"
}

define_function integer getNextInputWithValidSignal(integer currentInput)
{
	if((currentInput == 0) or (currentInput == DVX_MAX_VIDEO_INPUTS))
	{
		stack_var integer input
		for(input = 1; input <= DVX_MAX_VIDEO_INPUTS; input++)
		{
			if(dvxSwitcher.videoInputs[input].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
				return input
		}
		// if we got to here then no DVX inputs have any signals
		return 0
	}
	else
	{
		stack_var integer input
		for(input = (currentInput+1); input <= DVX_MAX_VIDEO_INPUTS; input++)
		{
			if(dvxSwitcher.videoInputs[input].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
				return input
		}
		for(input = 1; input <= currentInput; input++)
		{
			if(dvxSwitcher.videoInputs[input].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
				return input
		}
		// if we got to here then no DVX inputs have any signals
		return 0
	}
}


define_function restartSnapshots(integer input)
{
	inputPreview = input
	if((getPreviewMode() == PREVIEW_MODE_SNAPSHOTS) or (getPreviewMode() == PREVIEW_MODE_SNAPSHOT_SINGLE))
	{
		stopSnapshots()
		startSnapshots()
	}
	else
	{
		startSnapshots()
	}
}

define_function startSnapshots()
{
	if(getPreviewMode() == PREVIEW_MODE_VIDEO)
		stopVideoPreview()

	if((getPreviewMode() == PREVIEW_MODE_SNAPSHOTS) or (getPreviewMode() == PREVIEW_MODE_SNAPSHOT_SINGLE))
		stopSnapshots()
	
	if(resourceLoaded == FALSE)
	{
		wait 50 'WaitingForResourceToLoad'
		{
			resourceLoaded = TRUE
		}
		
		timed_wait_until (resourceLoaded == TRUE) 60
		{
			cancel_wait 'WaitingForResourceToLoad'
			timeline_create(TIMELINE_ID_SNAPSHOTS,timelineTimes,length_array(timelineTimes),TIMELINE_RELATIVE,TIMELINE_REPEAT)
		}
	}
	else
		timeline_create(TIMELINE_ID_SNAPSHOTS,timelineTimes,length_array(timelineTimes),TIMELINE_RELATIVE,TIMELINE_REPEAT)
	
	// lastly, update the variable keeping track of preview mode
	setPreviewMode(PREVIEW_MODE_SNAPSHOTS)
}

define_function takeSnapshot(integer input)
{
	if(getPreviewMode() == PREVIEW_MODE_VIDEO)
		stopVideoPreview()
	
	if((getPreviewMode() == PREVIEW_MODE_SNAPSHOTS) or (getPreviewMode() == PREVIEW_MODE_SNAPSHOT_SINGLE))
		stopSnapshots()
	
	inputPreview = input

	if(resourceLoaded == FALSE)
	{
		wait 50 'WaitingForResourceToLoad'
		{
			resourceLoaded = TRUE
		}
		
		timed_wait_until (resourceLoaded == TRUE) 60
		{
			cancel_wait 'WaitingForResourceToLoad'
			timeline_create(TIMELINE_ID_SNAPSHOTS,timelineTimes,length_array(timelineTimes),TIMELINE_RELATIVE,TIMELINE_ONCE)
		}
	}
	else
		timeline_create(TIMELINE_ID_SNAPSHOTS,timelineTimes,length_array(timelineTimes),TIMELINE_RELATIVE,TIMELINE_ONCE)
	
	// lastly, update the variable keeping track of preview mode
	setPreviewMode(PREVIEW_MODE_SNAPSHOT_SINGLE)
}

define_function stopSnapshots()
{
	if(timeline_active(TIMELINE_ID_SNAPSHOTS) == TRUE)
	{
		timeline_kill(TIMELINE_ID_SNAPSHOTS)
	}
	cancel_all_wait
	cancel_all_wait_until
	
	// lastly, update the variable keeping track of preview mode, but only if we are actually in snapshot mode
	if((getPreviewMode() == PREVIEW_MODE_SNAPSHOTS) or (getPreviewMode() == PREVIEW_MODE_SNAPSHOT_SINGLE))
		setPreviewMode(PREVIEW_MODE_STOP)
}


define_function startVideoPreview(integer input)
{
	if((getPreviewMode() == PREVIEW_MODE_SNAPSHOTS) or (getPreviewMode() == PREVIEW_MODE_SNAPSHOT_SINGLE))
		stopSnapshots()

	inputPreviewVideo = input
	
	channelOn(dvTp,BTN_LOADING_VIDEO_PREVIEW)
	
	if(not (resourceLoaded))
	{
		wait 50 'WaitingForResourceToLoad'
		{
			resourceLoaded = TRUE
		}
		
		timed_wait_until(resourceLoaded) 60
		{
			cancel_wait 'WaitingForResourceToLoad'
			dvxSwitchVideoOnly(dvDvxMainPorts[1], inputPreviewVideo, dvDvxSwitcherVidOutMultiPreview.port)
			
			moderoDeleteButtonVideoSnapshot (dvTp, BTN_VIDEO_PREVIEW_WINDOW, MODERO_BUTTON_STATE_ALL)
			moderoSetButtonOpacity (dvTp, BTN_VIDEO_PREVIEW_WINDOW, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_INVISIBLE)
			moderoSetButtonShow (dvTp, BTN_VIDEO_PREVIEW_WINDOW)
			
			//timed_wait_until (streamLoaded == TRUE) waitTimeToShowVideoPreviewButton
			wait waitTimeToShowVideoPreviewButton
			{
				channelOff(dvTp,BTN_LOADING_VIDEO_PREVIEW)
				moderoSetButtonOpacity (dvTp, BTN_VIDEO_PREVIEW_WINDOW, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_OPAQUE)
			}
		}
	}
	else
	{
		dvxSwitchVideoOnly(dvDvxMainPorts[1], inputPreviewVideo, dvDvxSwitcherVidOutMultiPreview.port)

		moderoDeleteButtonVideoSnapshot (dvTp, BTN_VIDEO_PREVIEW_WINDOW, MODERO_BUTTON_STATE_ALL)
		moderoSetButtonOpacity (dvTp, BTN_VIDEO_PREVIEW_WINDOW, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_INVISIBLE)
		moderoSetButtonShow (dvTp, BTN_VIDEO_PREVIEW_WINDOW)
			
		
		//timed_wait_until (streamLoaded == TRUE) waitTimeToShowVideoPreviewButton
		wait waitTimeToShowVideoPreviewButton
		{
			channelOff(dvTp,BTN_LOADING_VIDEO_PREVIEW)
			moderoSetButtonOpacity (dvTp, BTN_VIDEO_PREVIEW_WINDOW, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_OPAQUE)
		}
	}
	
	// lastly, update the variable keeping track of preview mode
	setPreviewMode(PREVIEW_MODE_VIDEO)
}

define_function stopVideoPreview()
{
	moderoSetButtonHide (dvTp, BTN_VIDEO_PREVIEW_WINDOW)
	// lastly, update the variable keeping track of preview mode, but only if we are actually in video preview mode
	if(getPreviewMode() == PREVIEW_MODE_VIDEO)
		setPreviewMode(PREVIEW_MODE_STOP)
}

define_function setPreviewMode(integer mode)
{
	switch(mode)
	{
		case PREVIEW_MODE_STOP:
		case PREVIEW_MODE_SNAPSHOTS:
		case PREVIEW_MODE_SNAPSHOT_SINGLE:
		case PREVIEW_MODE_VIDEO:
		{
			previewMode = mode
		}
	}
}

define_function integer getPreviewMode()
{
	return previewMode
}




define_function initVariableDvxDevices()
{
	stack_var integer dvxDeviceId
	stack_var integer dvxSystemNum

	dvxDeviceId = dvDvxSwitcherVidOutMultiPreview.number
	dvxSystemNum = dvDvxSwitcherVidOutMultiPreview.system
	
	// DVX Switcher
	initDevice (dvDvxMainPorts[1], dvxDeviceId, DVX_PORT_MAIN, dvxSystemNum)
	set_length_array (dvDvxMainPorts, 1)
	
	// DVX Video Inputs
	{
		stack_var integer dvxPortNum
		
		for (dvxPortNum = 1; dvxPortNum <= DVX_MAX_VIDEO_INPUTS; dvxPortNum++)
		{
			initDevice (dvDvxVidInPorts[dvxPortNum], dvxDeviceId, dvxPortNum, dvxSystemNum)
		}
		
		set_length_array (dvDvxVidInPorts, DVX_MAX_VIDEO_INPUTS)
	}
	
	initDevice (dvTpPort1, dvTp.number, 1, dvTp.system)
	
	rebuild_event()
}

define_start

initVariableDvxDevices()


define_event

data_event[dvTp]
{
	online:
	{
		stack_var integer input

		
		for(input = 1; input <= DVX_MAX_VIDEO_INPUTS; input++)
		{
			dvxRequestVideoInputName(dvDvxVidInPorts[input])
			dvxRequestVideoInputStatus(dvDvxVidInPorts[input])
			dvxRequestInputVideo (dvDvxMainPorts[1], dvDvxSwitcherVidOutMultiPreview.port)
			// create dynamic resource on panel
			moderoSetResourceParameter(dvTp,"SNAPSHOT_IMAGE_RESOURCE_NAME_HEADER,itoa(input)",MODERO_EMBEDDED_CODE_RESOURCE_PARAMETER_PROTOCOL,MODERO_RESOURCE_PARAMETER_VALUE_PROTOCOL_HTTP)
			moderoSetResourceParameter(dvTp,"SNAPSHOT_IMAGE_RESOURCE_NAME_HEADER,itoa(input)",MODERO_EMBEDDED_CODE_RESOURCE_PARAMETER_HOST,'mxamp')
			moderoSetResourceParameter(dvTp,"SNAPSHOT_IMAGE_RESOURCE_NAME_HEADER,itoa(input)",MODERO_EMBEDDED_CODE_RESOURCE_PARAMETER_PATH,'snapit')
			moderoSetResourceParameter(dvTp,"SNAPSHOT_IMAGE_RESOURCE_NAME_HEADER,itoa(input)",MODERO_EMBEDDED_CODE_RESOURCE_PARAMETER_FILE,"'slot',itoa(input),'.jpg'")
		}
		
		startSnapshots()
	}
	offline:
	{
		stopSnapshots()
		resourceLoaded = TRUE
		streamLoaded = FALSE
	}
}

data_event[dvDvxMainPorts[1]]
{
	online:
	{
		stack_var integer input
		
		for(input = 1; input <= DVX_MAX_VIDEO_INPUTS; input++)
		{
			dvxRequestVideoInputName(dvDvxVidInPorts[input])
			dvxRequestVideoInputStatus(dvDvxVidInPorts[input])
			dvxRequestInputVideo (data.device, dvDvxSwitcherVidOutMultiPreview.port)
		}
	}
}

data_event[dvDvxSwitcherVidOutMultiPreview]
{
	online:
	{
		dvxSetVideoOutputScaleMode (dvDvxSwitcherVidOutMultiPreview, DVX_SCALE_MODE_AUTO)
	}
}


timeline_event[TIMELINE_ID_SNAPSHOTS]
{
	switch(timeline.sequence)
	{
		case 1:	// switch
		{
			if(inputPreview > 0)
			{
				if(dvxSwitcher.switchStatusVideoOutputs[dvDvxSwitcherVidOutMultiPreview.port] != inputPreview)
				{
					dvxSwitchVideoOnly(dvDvxMainPorts[1], inputPreview, dvDvxSwitcherVidOutMultiPreview.port)
					switchToMplProcessed = FALSE
					timeline_pause(TIMELINE_ID_SNAPSHOTS)
				}
			}
			//else
			//	timeline_kill(TIMELINE_ID_SNAPSHOTS)
		}
		case 2:	// snapshot
		{
			if(inputPreview > 0)
			{
				// send the RMF command to the panel with the '%V0' param // #1
				moderoEnableResourceReloadOnView (dvTp, getResourceName(inputPreview))
				
				// send the RFRP command to the panel with the 'once' param // #2
				//moderoResourceForceRefreshPrefetchFromCache (dvTp, getResourceName(inputPreview), MODERO_RESOURCE_NOTIFICATION_ONCE)
				
				// send the BBR command to the panel // #4
				//moderoSetButtonBitmapResource (dvTp, BTNS_DVX_INPUT_SNAPSHOTS[input], MODERO_BUTTON_STATE_ALL, getResourceName(inputPreview))
				moderoSetButtonBitmapResourceG5 (dvTp, BTNS_DVX_INPUT_SNAPSHOTS[inputPreview],MODERO_BUTTON_STATE_ALL,getResourceName(inputPreview),1,10)
				
				// send the RMF command to the panel with the '%V1' param // #3
				moderoDisableResourceReloadOnView (dvTp, getResourceName(inputPreview))
				
				//timeline_pause(TIMELINE_ID_SNAPSHOTS)
				//resourceLoaded = FALSE
				/*wait 50 'WaitingForResourceToLoad'
				{
					if(resourceLoaded == FALSE)
					{
						resourceLoaded = TRUE
						timeline_restart(TIMELINE_ID_SNAPSHOTS)
					}
				}*/
			}
		}
		case 3:	// determine next input
		{
			cancel_wait 'WaitingForResourceToLoad'
			inputPreview = getNextInputWithValidSignal(inputPreview)
		}
	}
}

custom_event[dvTpPort1,0,MODERO_CUSTOM_EVENT_ID_RESOURCE_LOAD_NOTIFICATION]
custom_event[dvTp,0,MODERO_CUSTOM_EVENT_ID_RESOURCE_LOAD_NOTIFICATION]
{
	resourceLoaded = TRUE
	
	if((getPreviewMode() == PREVIEW_MODE_SNAPSHOTS) or (getPreviewMode() == PREVIEW_MODE_SNAPSHOT_SINGLE))
	{
		if(find_string(custom.text,SNAPSHOT_IMAGE_RESOURCE_NAME_HEADER,1))
		{
			stack_var integer input
			
			remove_string(custom.text,SNAPSHOT_IMAGE_RESOURCE_NAME_HEADER,1)
			
			input = atoi(custom.text)
			
			// send the BBR command to the panel // #4
			//moderoSetButtonBitmapResource (dvTp, BTNS_DVX_INPUT_SNAPSHOTS[input], MODERO_BUTTON_STATE_ALL, getResourceName(input))	// G4
			moderoSetButtonBitmapResourceG5 (dvTp, BTNS_DVX_INPUT_SNAPSHOTS[input],MODERO_BUTTON_STATE_ALL,getResourceName(input),1,10)	// G5
			
			// send the RMF command to the panel with the '%V1' param // #3
			moderoDisableResourceReloadOnView (dvTp, getResourceName(input))
			
			timeline_restart(TIMELINE_ID_SNAPSHOTS)
		}
	}
}

custom_event[dvTpPort1,0,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]    // Streaming start/stop
custom_event[dvTp,0,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]    // Streaming start/stop
{
	if(custom.text == 'udp://169.254.11.12:5700')	// MPL stream
	{
		switch(custom.flag)
		{
			case 1:	// panel has started streaming
			{
				streamLoaded = TRUE
			}
			case 2:	// panel has stopped streaming
			{
				streamLoaded = FALSE
			}
			case 8:	// error
			{
				
			}
		}
	}
}


data_event[vdvApi]
{
	command:
	{
		/*
			DvxMultiPreview module API commands
			-----------------------------------
			
			SNAPSHOTS_START
			SNAPSHOTS_STOP
			SNAPSHOT-<input>                e.g: SNAPSHOT-3
			VIDEO_PREVIEW_START-<input>     e.g: VIDEO_PREVIEW_STOP-4
			VIDEO_PREVIEW_STOP
		*/
		
		if(compare_string(data.text,'SNAPSHOTS_START') == TRUE)
		{
			startSnapshots()
		}
		else if(compare_string(data.text,'SNAPSHOTS_STOP') == TRUE)
		{
			stopSnapshots()
		}
		else if(compare_string(data.text,'VIDEO_PREVIEW_STOP') == TRUE)
		{
			stopVideoPreview()
		}
		else
		{
			stack_var cmdHeader[50]
			
			cmdHeader = remove_string(data.text,"'-'",1)
			
			switch(cmdHeader)
			{
				case 'SNAPSHOT-':
				{
					stack_var integer input
					input = atoi(data.text)
					takeSnapshot(input)
				}
				case 'VIDEO_PREVIEW_START-':
				{
					stack_var integer input
					input = atoi(data.text)
					startVideoPreview(input)
				}
			}
		}
	}
}


define_program
