PROGRAM_NAME='system-functions'

#if_not_defined __SYSTEM_FUNCTIONS__
#define __SYSTEM_FUNCTIONS__

#include 'system-devices'
#include 'system-structures'
#include 'system-constants'
#include 'system-variables'
#include 'system-library-api'
#include 'system-library-control'
#include 'system-rms-api'

#include 'system-events'

// special case
#include 'cbus-lighting'
#include 'nec-monitor'
#include 'wake-on-lan'

#include 'debug'



/*
 * --------------------
 * Scheduling Panel Current Meeking Info Card Functions
 * --------------------
 */

define_function hideMeetingInfoCardOnWelcomePanel ()
{
	moderoDisablePopupOnPage (dvTpSchedulingRmsCustom, POPUP_NAME_MEETING_INFO_CARD, PAGE_NAME_ROOM_STATUS)
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_SUBJECT, MODERO_BUTTON_STATE_ALL, '')
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_ORGANIZER, MODERO_BUTTON_STATE_ALL, '')
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_START_TIME, MODERO_BUTTON_STATE_ALL, '')
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_TIME_REMAINING, MODERO_BUTTON_STATE_ALL, '')
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_DESCRIPTION, MODERO_BUTTON_STATE_ALL, '')
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_CARD_HEADER, MODERO_BUTTON_STATE_ALL, '')
}

define_function showCurrentMeetingInfoCardOnWelcomePanel ()
{
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_CARD_HEADER, MODERO_BUTTON_STATE_ALL, 'Meeting In Session')
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_SUBJECT, MODERO_BUTTON_STATE_ALL, "rmsSchedule.currentMeetingSubject")
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_ORGANIZER, MODERO_BUTTON_STATE_ALL, "rmsSchedule.currentMeetingOrganizerName")
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_START_TIME, MODERO_BUTTON_STATE_ALL, "'Started: ',getTimeString12HourFormatAmPm(rmsSchedule.currentMeetingStartTime)")
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_TIME_REMAINING, MODERO_BUTTON_STATE_ALL, "'Remaining: ',getFuzzyTimeString(getDifferenceInMinutesIgnoreSeconds(time,rmsSchedule.currentMeetingEndTime))")
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_DESCRIPTION, MODERO_BUTTON_STATE_ALL, "rmsSchedule.currentMeetingDetails")
	moderoEnablePopupOnPage (dvTpSchedulingRmsCustom, POPUP_NAME_MEETING_INFO_CARD, PAGE_NAME_ROOM_STATUS)
}


define_function showNextMeetingInfoCardOnWelcomePanel ()
{
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_CARD_HEADER, MODERO_BUTTON_STATE_ALL, 'Next Meeting')
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_SUBJECT, MODERO_BUTTON_STATE_ALL, "rmsSchedule.nextMeetingSubject")
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_ORGANIZER, MODERO_BUTTON_STATE_ALL, "rmsSchedule.nextMeetingOrganizerName")
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_START_TIME, MODERO_BUTTON_STATE_ALL, "'Starts: ',getTimeString12HourFormatAmPm(rmsSchedule.nextMeetingStartTime)")
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_TIME_REMAINING, MODERO_BUTTON_STATE_ALL, "'Duration: ',getFuzzyTimeString(getDifferenceInMinutesIgnoreSeconds(rmsSchedule.nextMeetingStartTime,rmsSchedule.nextMeetingEndTime))")
	moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_MEETING_CARD_INFO_DESCRIPTION, MODERO_BUTTON_STATE_ALL, "rmsSchedule.nextMeetingDetails")
	moderoEnablePopupOnPage (dvTpSchedulingRmsCustom, POPUP_NAME_MEETING_INFO_CARD, PAGE_NAME_ROOM_STATUS)
}


/*
 * --------------------
 * Table Panel Splash Sreen Meeting functions
 * --------------------
 */

define_function hideMeetingInfoOnTablePanelSplashScreen ()
{
	moderoSetButtonHide (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_USER_PHOTO)
	moderoSetButtonHide (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_USER_PHOTO_BACKGROUND)
	moderoSetButtonHide (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_TAP_ON_INDICATOR)
	moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_1, MODERO_BUTTON_STATE_ALL, '')
	moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_2, MODERO_BUTTON_STATE_ALL, '')
	moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_3, MODERO_BUTTON_STATE_ALL, '')
	moderoSetResourceFileName (dvTpTableRmsCustom,dynamicResourceUserPhoto,fileNameNoPhoto)
}

define_function showCurrentMeetingInfoOnTableSplashScreen ()
{
	stack_var _user user
	
	getUserDetailsFromName (rmsSchedule.currentMeetingOrganizerName, user)
	
	moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_1, MODERO_BUTTON_STATE_ALL, "'Welcome to the Boardroom ',user.name")
	moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_2, MODERO_BUTTON_STATE_ALL, 'Touch card where indicated above to begin meeting')
	
	if (rmsSchedule.currentMeetingRemainingMinutes == 0) // special case where ad-hoc meetings will sometimes report 0 minutes remaining until the next update
		moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_3, MODERO_BUTTON_STATE_ALL, "'This meeting will end in ',getFuzzyTimeString(getDifferenceInMinutesIgnoreSeconds (rmsSchedule.currentMeetingStartTime, rmsSchedule.currentMeetingEndTime))")
	else
		moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_3, MODERO_BUTTON_STATE_ALL, "'This meeting will end in ',getFuzzyTimeString(rmsSchedule.currentMeetingRemainingMinutes)")
	
	moderoSetResourceFileName (dvTpTableRmsCustom,dynamicResourceUserPhoto,user.photo)
	
	moderoSetButtonShow (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_USER_PHOTO)
	moderoSetButtonShow (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_USER_PHOTO_BACKGROUND)
	moderoSetButtonShow (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_TAP_ON_INDICATOR)
}

define_function showNextMeetingInfoOnTableSplashScreen ()
{
	moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_1, MODERO_BUTTON_STATE_ALL, "'Meetings in the Boardroom must be booked in advance'")
	
	moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_2, MODERO_BUTTON_STATE_ALL, "'The next scheduled meeting in the Boardroom'")
	moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_3, MODERO_BUTTON_STATE_ALL, "'will begin in ',getFuzzyTimeString (rmsSchedule.nextMeetingMinutesUntilStart)")
	
	moderoSetButtonHide (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_USER_PHOTO)
	moderoSetButtonHide (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_USER_PHOTO_BACKGROUND)
	moderoSetButtonHide (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_TAP_ON_INDICATOR)
	
	moderoSetResourceFileName (dvTpTableRmsCustom,dynamicResourceUserPhoto,fileNameNoPhoto)
}

define_function showNoMeetingsTodayInfoOnTableSplashScreen ()
{
	moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_1, MODERO_BUTTON_STATE_ALL, "'Meetings in the Boardroom must be booked in advance'")
	moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_2, MODERO_BUTTON_STATE_ALL, "'There are no meetings booked for today'")
	moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_3, MODERO_BUTTON_STATE_ALL, "''")
	
	moderoSetButtonHide (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_USER_PHOTO)
	moderoSetButtonHide (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_USER_PHOTO_BACKGROUND)
	moderoSetButtonHide (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_TAP_ON_INDICATOR)
	
	moderoSetResourceFileName (dvTpTableRmsCustom,dynamicResourceUserPhoto,fileNameNoPhoto)
}






/*
 * --------------------
 * User Interaction functions
 * --------------------
 */


define_function processUserInteractionWelcomePanel ()
{
	if ( (schedulingPanelInUse == true) and (waitingForAdhocBookingResponse == false) )
	{
		startTimerLockWelcomePanel ()
	}
	else if ( (schedulingPanelInUse == true) and (waitingForAdhocBookingResponse == true) )
	{
		cancelTimerLockWelcomePanel ()
	}
}



/*
 * --------------------
 * Overrider Modero Listener Touch coordinate callback functions
 * --------------------
 */


#define INCLUDE_MODERO_NOTIFY_TOUCH_COORDINATES_PRESS
// Note: This will get triggered BEFORE a push event handler in a button_event
// Note: If push/release coordinate reporting is enabled a push anywhere on the panel will trigger this function
define_function moderoNotifyTouchCoordinatesPress (dev panel, integer nX, integer nY)
{
	// panel is the touch panel
	// nX is the X coordinate
	// nY is the Y Coordinate
	
	if (panel == dvTpSchedulingMain)
		processUserInteractionWelcomePanel ()
}

#define INCLUDE_MODERO_NOTIFY_TOUCH_COORDINATES_RELEASE
// Note: This will get triggered AFTER a release event handler in a button_event
// Note: If push/release coordinate reporting is enabled a release anywhere on the panel will trigger this function
define_function moderoNotifyTouchCoordinatesRelease (dev panel, integer nX, integer nY)
{
	// panel is the touch panel
	// nX is the X coordinate
	// nY is the Y Coordinate
	
	if (panel == dvTpSchedulingMain)
		processUserInteractionWelcomePanel ()
}



/*
 * --------------------
 * User functions
 * --------------------
 */

define_function copyUserInfo (_user userToCopyFrom, _user userToCopyTo)
{
	userToCopyTo.nfcTag = userToCopyFrom.nfcTag
	userToCopyTo.name = userToCopyFrom.name
	userToCopyTo.email = userToCopyFrom.email
	userToCopyTo.photo = userToCopyFrom.photo
}



/*
 * --------------------
 * Panel access functions
 * --------------------
 */


define_function nfcTagDetectedTablePanel (char nfcTag[])
{
	if ( [vdvRms,RMS_CHANNEL_CLIENT_ONLINE] == false )	// lost connection to RMS
	{
		// allow any NFC card to start using the panel - special case in case Internet drops during the Integrate tradeshow
		_user user
		unlockTablePanel (user)
	}
	else if (tablePanelInUse == false)	// am connected to RMS so just need to check that the table panel is not already being used
	{
		// next step is to authenticate NFC card...
		if (authenticateUserNfcTag(nfcTag) == true)
		{
			_user user
			getUserDetailsFromNfcTag (nfcTag, user)
			
			// now check that the user is the person who booked the room...or maintenance (maintenance should always be allowed access)
			if (user.name == USER_NAME_MAINTENANCE)
			{
				unlockTablePanel (user)
			}
			else if (user.name == rmsSchedule.currentMeetingOrganizerName)
			{
				if (userShutdownSystemToEndMeeting == false)
				{
					unlockTablePanel (user)
				}
			}
			else
				userAccessTablePanelDenied ()
		}
		else	// unauthorised NFC card
		{
			userAccessTablePanelDenied ()
		}
	}
}

define_function nfcTagDetectedWelcomePanel (char nfcTag[])
{
	// only respond to NFC taps if we are connected to RMS and the scheduling panel is not already in use
	if ( [vdvRms,RMS_CHANNEL_CLIENT_ONLINE] and (schedulingPanelInUse == false) )
	{
		// next step is to authenticate user....
		if (authenticateUserNfcTag(nfcTag) == true)
		{
			_user user
			getUserDetailsFromNfcTag (nfcTag, user)
			unlockWelcomePanel (user)
		}
		else	// unauthorised NFC card
		{
			userAccessWelcomePanelDenied ()
		}
	}
}

define_function userAccessTablePanelDenied ()
{
	moderoPlaySoundFile (dvTpTableMain, soundFileInvalidId)
}


define_function unlockTablePanel (_user user)
{
	moderoPlaySoundFile (dvTpTableMain, soundFileValidId)
	
	moderoDisableAllPopups (dvTpTableMain)
	// flip the panel to the main page
	moderoSetPage (dvTpTableMain, PAGE_NAME_MAIN_USER)
	// show the source selection / volume control page
	moderoEnablePopup (dvTpTableMain, POPUP_NAME_SOURCE_SELECTION)
	
	//show the draggable source popups
	moderoEnablePopupOnPage (dvTpTableMain, POPUP_NAME_DRAGGABLE_SOURCES[dvDvxVidInEnzo.port],PAGE_NAME_MAIN_USER)
	moderoEnablePopupOnPage (dvTpTableMain, POPUP_NAME_DRAGGABLE_SOURCES[dvDvxVidInAppleTv.port],PAGE_NAME_MAIN_USER)
	moderoEnablePopupOnPage (dvTpTableMain, POPUP_NAME_DRAGGABLE_SOURCES[dvDvxVidInTx3.port],PAGE_NAME_MAIN_USER)
	moderoEnablePopupOnPage (dvTpTableMain, POPUP_NAME_DRAGGABLE_SOURCES[dvDvxVidInTx4.port],PAGE_NAME_MAIN_USER)
	
	// activate the source selection drag areas
	enableDragItemsAll (vdvDragAndDropTpTable)
	
	tablePanelInUse = true
}


define_function userAccessWelcomePanelDenied ()
{
	moderoPlaySoundFile (dvTpSchedulingMain, soundFileInvalidId)
}

define_function unlockWelcomePanel (_user user)
{
	copyUserInfo (user, currentUserSchedulingPanel)
	
	schedulingPanelInUse = true
	
	// do this here just in case we want to adjust this on the fly in debug and have it update
	RmsSetDefaultEventBookingDuration(bookingTime)
	
	moderoPlaySoundFile (dvTpSchedulingMain, soundFileValidId)
	
	// show user details (name, photo) on scheduling panel for a more personalised feel
	moderoSetButtonText (dvTpSchedulingRmsCustom,BTN_ADR_SCHEDULING_USER_WELCOME_MESSAGE,MODERO_BUTTON_STATE_ALL,"'Welcome ',currentUserSchedulingPanel.name")
	moderoEnablePopupOnPage (dvTpSchedulingMain, popupWelcomeUserMessage, pageWelcomePanelUnlocked)
	moderoSetResourceFileName (dvTpSchedulingRmsCustom,dynamicResourceUserPhoto,currentUserSchedulingPanel.photo)
	
	updateSchedulingPanelToShowCorrectBookingOption ()
	
	moderoSetPage (dvTpSchedulingMain, pageWelcomePanelUnlocked)
	
	startTimerLockWelcomePanel ()
}

define_function lockWelcomePanel ()
{
	cancelTimerLockWelcomePanel ()
	schedulingPanelInUse = false
	schedulingPanelShowingBookingSucceededMessageWhileInUse = false
	moderoSetPage (dvTpSchedulingMain, pageWelcomePanelLocked)
	moderoDisablePopupOnPage (dvTpSchedulingMain, popupBookNext, pageWelcomePanelUnlocked)	// this will hide all popups in the same group as nfcBookNext
	moderoDisablePopupOnPage (dvTpSchedulingMain, popupBookingSuccessful, pageWelcomePanelUnlocked)	// this will hide all popups in the same group as nfcFeedbackSuccess
	moderoDisableAllPopupsOnPage (dvTpSchedulingMain, PAGE_NAME_RMS_SCHEDULING_CALENDAR)
	currentUserSchedulingPanel.name = ''
	currentUserSchedulingPanel.email = ''
	currentUserSchedulingPanel.nfcTag = ''
	currentUserSchedulingPanel.photo = ''
	moderoSetButtonText (dvTpSchedulingRmsCustom,BTN_ADR_SCHEDULING_USER_WELCOME_MESSAGE,MODERO_BUTTON_STATE_ALL,'')
	moderoSetResourceFileName (dvTpSchedulingRmsCustom,dynamicResourceUserPhoto,fileNameNoPhoto)
}

define_function startTimerLockWelcomePanel ()
{
	cancel_wait 'WAITING TO SHOW SPLASH SCREEN ON SCHEDULING PANEL'
	wait waitTimeToLockSchedulingPanel 'WAITING TO SHOW SPLASH SCREEN ON SCHEDULING PANEL'
	{
		lockWelcomePanel ()
	}
}


define_function cancelTimerLockWelcomePanel ()
{
	cancel_wait 'WAITING TO SHOW SPLASH SCREEN ON SCHEDULING PANEL'
}


/*
 * --------------------
 * Authentication functions
 * --------------------
 */

define_function integer authenticateUserNfcTag (char nfcTag[])
{
	
	// read NFC file that was uploaded to the master and search through for a matching NFC tag
	// if a match is found, close the file and return true
	// if no match is found, close the file and return false
	
	// file is located in the "nfc" folder.
	// file name is "users.txt"
	
	stack_var slong resultFileOpen
	stack_var slong resultFileReadLine
	stack_var slong resultFileClose
	stack_var slong fileHandle
	stack_var char buffer[300]
	
	resultFileOpen = file_open (filePathNfcUserList,file_read_only)
	
	if(resultFileOpen > 0)	// handle to file (open was successful)
	{
		debugPrint ("'Success opening nfc users file.'")
		fileHandle = resultFileOpen
		
		resultFileReadLine = file_read_line (fileHandle, buffer, max_length_array(buffer))
		while (resultFileReadLine >= 0)
		{
			debugPrint ("'Success reading line from nfc users file.'")
			if (find_string(buffer,nfcTag,1) == 1)
			{
				debugPrint ("'found matching NFC auth in file.'")
				debugPrint ("'closing file.'")
				file_close (fileHandle)
				return true
			}
			resultFileReadLine = file_read_line (fileHandle, buffer, max_length_array(buffer))
		}
		debugPrint ("'Did not find a matching NFC auth in file.'")
		debugPrint ("'closing file.'")
		file_close (fileHandle)
		return false
	}
	else	// error opening file
	{
		debugPrint ("'Error opening nfc users file. Error code = <',itoa(resultFileOpen),'>'")
		return false
	}
}


// user structure parameter will be updated by this function
define_function integer getUserDetailsFromNfcTag (char nfcTag[], _user user)
{
	stack_var slong resultFileOpen
	stack_var slong resultFileReadLine
	stack_var slong resultFileClose
	stack_var slong fileHandle
	stack_var char buffer[300]
	
	debugPrint ("'FUNCTION - getUserDetailsFromNfcTag (char nfcTag[], _user user)'")
	debugPrint ("'- nfcTag = ',nfcTag")
	
	resultFileOpen = file_open (filePathNfcUserList,file_read_only)
	
	if(resultFileOpen > 0)	// handle to file (open was successful)
	{
		debugPrint ("'Success opening nfc users file.'")
		fileHandle = resultFileOpen
		
		resultFileReadLine = file_read_line (fileHandle, buffer, max_length_array(buffer))
		while (resultFileReadLine >= 0)
		{
			debugPrint ("'Success reading line from nfc users file.'")
			if (find_string(buffer,nfcTag,1) == 1)
			{
				debugPrint ("'found matching NFC tag in file.'")
				debugPrint ("'collecting user details.'")
				
				user.nfcTag = remove_string (buffer,"','",1)
				user.nfcTag = left_string (user.nfcTag, length_string(user.nfcTag)-1)	// remove the trailing comma ','
				user.name = remove_string (buffer,"','",1)
				user.name = left_string (user.name, length_string(user.name)-1)	// remove the trailing comma ','
				user.email = remove_string (buffer,"','",1)
				user.email = left_string (user.email, length_string(user.email)-1)	// remove the trailing comma ','
				user.photo = buffer
				user.photo = left_string (user.photo, length_string(user.photo))
				debugPrint ("'user nfc tag = "[',user.nfcTag,']'")
				debugPrint ("'user name = "',user.name,'"'")
				debugPrint ("'user email = "',user.email,'"'")
				debugPrint ("'user photo = "',user.photo,'"'")
				
				debugPrint ("'closing file.'")
				file_close (fileHandle)
				return true
			}
			resultFileReadLine = file_read_line (fileHandle, buffer, max_length_array(buffer))
		}
		debugPrint ("'Did not find a matching NFC tag in file.'")
		debugPrint ("'closing file.'")
		file_close (fileHandle)
		return false
	}
	else	// error opening file
	{
		debugPrint ("'Error opening nfc users file. Error code = <',itoa(resultFileOpen),'>'")
		return false
	}
	
	
	return false
}


// user structure parameter will be updated by this function
define_function integer getUserDetailsFromName (char name[], _user user)
{
	stack_var slong resultFileOpen
	stack_var slong resultFileReadLine
	stack_var slong resultFileClose
	stack_var slong fileHandle
	stack_var char buffer[300]
	
	debugPrint ("'FUNCTION - getUserDetailsFromName (char name[], _user user)'")
	debugPrint ("'- name = ',name")
	
	resultFileOpen = file_open (filePathNfcUserList,file_read_only)
	
	if(resultFileOpen > 0)	// handle to file (open was successful)
	{
		debugPrint ("'Success opening nfc users file.'")
		fileHandle = resultFileOpen
		
		resultFileReadLine = file_read_line (fileHandle, buffer, max_length_array(buffer))
		while (resultFileReadLine >= 0)
		{
			debugPrint ("'Success reading line from nfc users file.'")
			if (find_string(buffer,name,1))
			{
				debugPrint ("'found matching user name in file.'")
				debugPrint ("'collecting user details.'")
				
				user.nfcTag = remove_string (buffer,"','",1)
				user.nfcTag = left_string (user.nfcTag, length_string(user.nfcTag)-1)	// remove the trailing comma ','
				user.name = remove_string (buffer,"','",1)
				user.name = left_string (user.name, length_string(user.name)-1)	// remove the trailing comma ','
				user.email = remove_string (buffer,"','",1)
				user.email = left_string (user.email, length_string(user.email)-1)	// remove the trailing comma ','
				user.photo = buffer
				user.photo = left_string (user.photo, length_string(user.photo))
				debugPrint ("'user nfc tag = "[',user.nfcTag,']'")
				debugPrint ("'user name = "',user.name,'"'")
				debugPrint ("'user email = "',user.email,'"'")
				debugPrint ("'user photo = "',user.photo,'"'")
				
				debugPrint ("'closing file.'")
				file_close (fileHandle)
				return true
			}
			resultFileReadLine = file_read_line (fileHandle, buffer, max_length_array(buffer))
		}
		debugPrint ("'Did not find a matching user name in file.'")
		debugPrint ("'closing file.'")
		file_close (fileHandle)
		return false
	}
	else	// error opening file
	{
		debugPrint ("'Error opening nfc users file. Error code = <',itoa(resultFileOpen),'>'")
		return false
	}
	
	
	return false
}


/*
 * --------------------
 * Time functions
 * --------------------
 */


define_function char[7] getTimeString12HourFormatAmPm (char timeParam24HourFormatHhMmSs[])	//HH:MM:SS
{
	if (atoi(left_string(timeParam24HourFormatHhMmSs,2)) > 12)
	{
		return "itoa(atoi(left_string(timeParam24HourFormatHhMmSs,2)) - 12),':',mid_string(timeParam24HourFormatHhMmSs,4,2),'pm'"
	}
	else if (atoi(left_string(timeParam24HourFormatHhMmSs,2)) == 12)
	{
		return "left_string(timeParam24HourFormatHhMmSs,2),':',mid_string(timeParam24HourFormatHhMmSs,4,2),'pm'"
	}
	else
	{
		return "left_string(timeParam24HourFormatHhMmSs,2),':',mid_string(timeParam24HourFormatHhMmSs,4,2),'am'"
	}
}

define_function char [100] getFuzzyTimeString (long timeInMinutes)
{
	stack_var char fuzzyTime[100]
	stack_var long hours
	stack_var long minutesRemainingAfterHours
	
	
	hours = timeInMinutes / 60
	minutesRemainingAfterHours = timeInMinutes mod 60
	
	if (hours == 0)
	{
		if (minutesRemainingAfterHours == 1)
		{
			fuzzyTime = '1 minute'
		}
		else
		{
			fuzzyTime = "itoa(minutesRemainingAfterHours),' minutes'"
		}
	}
	else if (hours == 1)
	{
		if (minutesRemainingAfterHours == 1)
		{
			fuzzyTime = '1 hour and 1 minute'
		}
		else
		{
			fuzzyTime = "'1 hour and ',itoa(minutesRemainingAfterHours),' minutes'"
		}
	}
	else
	{
		if (minutesRemainingAfterHours == 1)
		{
			fuzzyTime = "itoa(hours),' hours and 1 minute'"
		}
		else
		{
			fuzzyTime = "itoa(hours),' hours and ',itoa(minutesRemainingAfterHours),' minutes'"
		}
	}
	
	
	return fuzzyTime
}





define_function long getDateTimeEncoding (char paramShortDate[8], char paramTime[8])
{
	// this will work as long as the year isn't bigger than '63
	stack_var long encoding
	
	integer iYear
	integer iMonth
	integer iDay
	integer iHour
	integer iMinute
	integer iSecond
	
	iYear = type_cast(date_to_year(paramShortDate))	// converting SINTEGER to INTEGER
	iMonth = type_cast(date_to_month(paramShortDate))
	iDay = type_cast(date_to_day(paramShortDate))
	
	iHour = type_cast(time_to_hour(paramTime))
	iMinute = type_cast(time_to_minute(paramTime))
	iSecond = type_cast(time_to_second(paramTime))
	
	encoding = iYear
	encoding = encoding << 4
	encoding = encoding & iYear
	encoding = encoding << 5
	encoding = encoding & iMonth
	encoding = encoding << 5
	encoding = encoding & iHour
	encoding = encoding << 6
	encoding = encoding & iMinute
	encoding = encoding << 6
	encoding = encoding & iSecond
	
	return encoding
}


define_function sinteger getDifferenceInMinutesIgnoreSeconds (char paramTimeA[8], char paramTimeB[8])
{
	if ( time_to_hour(paramTimeA) == time_to_hour(paramTimeB) )	// the 2 times occur within the same hour
	{
		if ( time_to_minute(paramTimeA) == time_to_minute(paramTimeB) )	// the 2 times are the same (ignoring seconds)
		{
			return 0
		}
		else if ( time_to_minute(paramTimeA) < time_to_minute(paramTimeB) )	// time A occurs before time B
		{
			return abs_value(time_to_minute(paramTimeB) - time_to_minute(paramTimeA))
		}
		else	// time B occurs before time A
		{
			return abs_value(time_to_minute(paramTimeA) - time_to_minute(paramTimeB))
		}
		
	}
	else if ( time_to_hour(paramTimeA) < time_to_hour(paramTimeB) )	// time A occurs before time B but not within the same hour
	{
		stack_var integer numberOfHoursDifference
		
		
		numberOfHoursDifference = abs_value(time_to_hour(paramTimeB) - time_to_hour(paramTimeA))
		
		switch (numberOfHoursDifference)
		{
			case 1:
			{
				return abs_value( (60 - time_to_minute(paramTimeA)) + time_to_minute(paramTimeB) )
			}
			default:
			{
				return abs_value(( (60 - time_to_minute(paramTimeA)) + time_to_minute(paramTimeB) ) + ((numberOfHoursDifference - 1) * 60))
			}
		}
	}
	else	// time B occurs before time A but not within the same hour
	{
		stack_var integer numberOfHoursDifference
		
		numberOfHoursDifference = abs_value(time_to_hour(paramTimeA) - time_to_hour(paramTimeB))
		
		switch (numberOfHoursDifference)
		{
			case 1:
			{
				return abs_value( (60 - time_to_minute(paramTimeB)) + time_to_minute(paramTimeA) )
			}
			default:
			{
				return abs_value(( (60 - time_to_minute(paramTimeB)) + time_to_minute(paramTimeA) ) + ((numberOfHoursDifference - 1) * 60))
			}
		}
	}
}


/*
 * --------------------
 * System functions
 * --------------------
 */


define_function animateTpVideoSourceSelectionOpen ()
{
	channelOn (dvTpTableDebug, 1)	// both display animation elements - opens them via animation
	channelOn (dvTpTableDebug, 2)	// left display animation elements - hides it via animation
	channelOn (dvTpTableDebug, 3)	// right display animation elements - hides it via animation
	moderoEnableButtonPushes (dvTpTableDebug, 2)	// exit animation button
	moderoDisableButtonPushes (dvTpTableVideo, BTN_ADR_VIDEO_MONITOR_LEFT_PREVIEW_SNAPSHOT)	// left monitor
	moderoDisableButtonPushes (dvTpTableVideo, BTN_ADR_VIDEO_MONITOR_RIGHT_PREVIEW_SNAPSHOT)	// right monitor
}


define_function animateTpVideoSourceSelectionClose ()
{
	channelOff (dvTpTableDebug, 1)	// both display animation elements - closes them via animation
	channelOff (dvTpTableDebug, 2)	// left display animation elements - shows it via animation
	channelOff (dvTpTableDebug, 3)	// right display animation elements - shows it via animation
	moderoDisableButtonPushes (dvTpTableDebug, 2)	// exit animation button
	moderoEnableButtonPushes (dvTpTableVideo, BTN_ADR_VIDEO_MONITOR_LEFT_PREVIEW_SNAPSHOT)	// left monitor
	moderoEnableButtonPushes (dvTpTableVideo, BTN_ADR_VIDEO_MONITOR_RIGHT_PREVIEW_SNAPSHOT)	// right monitor
}

define_function showSourceControlPopup (integer input)
{
	select
	{
		active (input == dvDvxVidInEnzo.port):
		{
			moderoEnablePopup (dvTpTableMain, POPUP_NAME_SOURCE_CONTROL_BACKGROUNDS[input])
			moderoEnablePopup (dvTpTableMain, POPUP_NAME_SOURCE_CONTROL_ENZO)
			// deactivate the source selection drag areas
			disableDragItemsAll (vdvDragAndDropTpTable)
			sendCommand (vdvMultiPreview, "'SNAPSHOTS_INPUT-',itoa(input)")
		}
		
		active (input == dvDvxVidInAppleTv.port):
		{
			moderoEnablePopup (dvTpTableMain, POPUP_NAME_SOURCE_CONTROL_BACKGROUNDS[input])
			moderoEnablePopup (dvTpTableMain, POPUP_NAME_SOURCE_CONTROL_APPLE_TV)
			// deactivate the source selection drag areas
			disableDragItemsAll (vdvDragAndDropTpTable)
			sendCommand (vdvMultiPreview, "'SNAPSHOTS_INPUT-',itoa(input)")
		}
	}
}


define_function resetDraggablePopup (dev dragAndDropVirtual, integer id)
{
	hideDraggablePopup (dragAndDropVirtual, id)
	showDraggablePopup (dragAndDropVirtual, id)
}

define_function resetAllDraggablePopups (dev dragAndDropVirtual)
{
    select
    {
		active (dragAndDropVirtual == vdvDragAndDropTpTable):
		{
			hideDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInEnzo.port)
			hideDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInAppleTv.port)
			hideDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx1.port)
			hideDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx2.port)
			hideDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx3.port)
			hideDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx4.port)
			
			showDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInEnzo.port)
			showDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInAppleTv.port)
			showDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx1.port)
			showDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx2.port)
			showDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx3.port)
			showDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx4.port)
		}
    }
}

define_function hideDraggablePopup (dev dragAndDropVirtual, integer id)
{
    select
    {
	active (dragAndDropVirtual == vdvDragAndDropTpTable):
	{
	    moderoDisablePopup (dvTpTableDragAndDrop, draggablePopupsTpTable[id])
	}
    }
}

define_function hideAllDraggablePopups (dev dragAndDropVirtual)
{
    select
    {
	active (dragAndDropVirtual == vdvDragAndDropTpTable):
	{
	    hideDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInEnzo.port)
	    hideDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInAppleTv.port)
	    hideDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx1.port)
	    hideDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx2.port)
	    hideDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx3.port)
	    hideDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx4.port)
	}
    }
}

define_function showDraggablePopup (dev dragAndDropVirtual, integer id)
{
    select
    {
	active (dragAndDropVirtual == vdvDragAndDropTpTable):
	{
	    moderoEnablePopup (dvTpTableDragAndDrop, draggablePopupsTpTable[id])
	}
    }
}

define_function showDraggablePopupsAll (dev dragAndDropVirtual)
{
    select
    {
	active (dragAndDropVirtual == vdvDragAndDropTpTable):
	{
	    showDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInEnzo.port)
	    showDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInAppleTv.port)
	    showDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx1.port)
	    showDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx2.port)
	    showDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx3.port)
	    showDraggablePopup (vdvDragAndDropTpTable, dvDvxVidInTx4.port)
	}
    }
}

define_function addDragItem (dev dragAndDropVirtual, integer id)
{
    select
    {
	active (dragAndDropVirtual == vdvDragAndDropTpTable):
	{
	    sendCommand (vdvDragAndDropTpTable, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(id, dragAreasTpTable[id])")
	}
    }
}

define_function addDragItemsAll (dev dragAndDropVirtual)
{
    select
    {
	active (dragAndDropVirtual == vdvDragAndDropTpTable):
	{
	    addDragItem (vdvDragAndDropTpTable, dvDvxVidInEnzo.port)
	    addDragItem (vdvDragAndDropTpTable, dvDvxVidInAppleTv.port)
	    addDragItem (vdvDragAndDropTpTable, dvDvxVidInTx3.port)
	    addDragItem (vdvDragAndDropTpTable, dvDvxVidInTx4.port)
	}
    }
}


define_function enableDragItem (dev dragAndDropVirtual, integer id)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDropTpTable):
		{
			sendCommand (vdvDragAndDropTpTable, "'ACTIVATE_DRAG_ITEM-',buildDragAndDropParameterString(id, dragAreasTpTable[id])")
		}
	}
}

define_function enableDragItemsAll (dev dragAndDropVirtual)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDropTpTable):
		{
			enableDragItem (vdvDragAndDropTpTable, dvDvxVidInEnzo.port)
			enableDragItem (vdvDragAndDropTpTable, dvDvxVidInAppleTv.port)
			enableDragItem (vdvDragAndDropTpTable, dvDvxVidInTx3.port)
			enableDragItem (vdvDragAndDropTpTable, dvDvxVidInTx4.port)
		}
	}
}


define_function disableDragItem (dev dragAndDropVirtual, integer id)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDropTpTable):
		{
			sendCommand (vdvDragAndDropTpTable, "'DEACTIVATE_DRAG_ITEM-',itoa(id)")
		}
	}
}

define_function disableDragItemsAll (dev dragAndDropVirtual)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDropTpTable):
		{
			disableDragItem (vdvDragAndDropTpTable, dvDvxVidInEnzo.port)
			disableDragItem (vdvDragAndDropTpTable, dvDvxVidInAppleTv.port)
			disableDragItem (vdvDragAndDropTpTable, dvDvxVidInTx1.port)
			disableDragItem (vdvDragAndDropTpTable, dvDvxVidInTx2.port)
			disableDragItem (vdvDragAndDropTpTable, dvDvxVidInTx3.port)
			disableDragItem (vdvDragAndDropTpTable, dvDvxVidInTx4.port)
		}
	}
}

define_function disableDropArea (dev dragAndDropVirtual, integer id)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDropTpTable):
		{
			sendCommand (vdvDragAndDropTpTable, "'DEACTIVATE_DROP_AREA-',itoa(id)")
		}
	}
}

define_function disableDropAreasAll (dev dragAndDropVirtual)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDropTpTable):
		{
			disableDropArea (vdvDragAndDropTpTable, dvDvxVidOutMonitorLeft.port)
			disableDropArea (vdvDragAndDropTpTable, dvDvxVidOutMonitorRight.port)
			disableDropArea (vdvDragAndDropTpTable, dvDvxVidOutMultiPreview.port)
		}
	}
}

define_function addDropArea (dev dragAndDropVirtual, integer id)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDropTpTable):
		{
			sendCommand (vdvDragAndDropTpTable, "'DEFINE_DROP_AREA-',buildDragAndDropParameterString(id, dropAreasTpTable[id])")
		}
	}
}

define_function addDropAreasAll (dev dragAndDropVirtual)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDropTpTable):
		{
			addDropArea (vdvDragAndDropTpTable, dvDvxVidOutMonitorLeft.port)
			addDropArea (vdvDragAndDropTpTable, dvDvxVidOutMonitorRight.port)
			addDropArea (vdvDragAndDropTpTable, dvDvxVidOutMultiPreview.port)
		}
	}
}

define_function enableDropArea (dev dragAndDropVirtual, integer id)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDropTpTable):
		{
			sendCommand (vdvDragAndDropTpTable, "'ACTIVATE_DROP_AREA-',itoa(id)")
		}
	}
}

define_function enableDropItemsAll (dev dragAndDropVirtual)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDropTpTable):
		{
			enableDropArea (vdvDragAndDropTpTable, dvDvxVidOutMonitorLeft.port)
			enableDropArea (vdvDragAndDropTpTable, dvDvxVidOutMonitorRight.port)
			enableDropArea (vdvDragAndDropTpTable, dvDvxVidOutMultiPreview.port)
		}
	}
}

define_function initArea (_area area, integer left, integer top, integer width, integer height)
{
    area.left = left
    area.top = top
    area.width = width
    area.height = height
}

define_function char[20] buildDragAndDropParameterString (integer id, _area area)
{
    return "itoa(id),',',itoa(area.left),',',itoa(area.top),',',itoa(area.width),',',itoa(area.height)"
}




define_function turnOnDisplay (dev virtual)
{
	snapiDisplayEnablePower (virtual)
}

define_function turnOffDisplay (dev virtual)
{
	snapiDisplayDisablePower (virtual)
}

define_function turnOnDisplaysAll ()
{
	turnOnDisplay (vdvMonitorLeft)
	turnOnDisplay (vdvMonitorRight)
}

define_function turnOffDisplaysAll ()
{
	turnOffDisplay (vdvMonitorLeft)
	turnOffDisplay (vdvMonitorRight)
}




define_function showSourceOnDisplay (integer input, integer output)
{
	// switch the video
	dvxSwitchVideoOnly (dvDvxMain, input, output)
	
	// disable any test patterns on the output of the dvx
	// turn on the monitor
	select
	{
		active (output == dvDvxVidOutMonitorLeft.port):
		{
			if (dvx.videoOutputs[dvDvxVidOutMonitorLeft.port].testPattern != DVX_TEST_PATTERN_OFF)
			{
				dvxSetVideoOutputTestPattern (dvDvxVidOutMonitorLeft, DVX_TEST_PATTERN_OFF)
				dvx.videoOutputs[dvDvxVidOutMonitorLeft.port].testPattern = DVX_TEST_PATTERN_OFF
			}
			turnOnDisplay (vdvMonitorLeft)
		}
		
		active (output == dvDvxVidOutMonitorRight.port):
		{
			if (dvx.videoOutputs[dvDvxVidOutMonitorRight.port].testPattern != DVX_TEST_PATTERN_OFF)
			{
				dvxSetVideoOutputTestPattern (dvDvxVidOutMonitorRight, DVX_TEST_PATTERN_OFF)
				dvx.videoOutputs[dvDvxVidOutMonitorRight.port].testPattern = DVX_TEST_PATTERN_OFF
			}
			turnOnDisplay (vdvMonitorRight)
		}
	}
	
	// set flag to indicate that system is in use
	setFlagAvSystemInUse (TRUE)
}

define_function setFlagAvSystemInUse (integer boolean)
{
	isSystemAvInUse = boolean
}


define_function shutdownAvSystem ()
{
	// Blinds - raise blockouts and shades
	amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_UP)
	amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_UP)
	amxRelayPulse (dvRelaysRelBox, REL_SHADES_CORNER_WINDOW_UP)
	amxRelayPulse (dvRelaysRelBox, REL_SHADES_WALL_WINDOW_UP)
	
	// cancel the meeting in RMS if there is one currently in session
	if (rmsSchedule.bookingIdCurrentMeeting != '')
	{
		RmsBookingEnd(rmsSchedule.bookingIdCurrentMeeting, rmsSchedule.locationId)
	}
	
	if (rmsSchedule.bookingIdNextMeeting == '')	// no upcoming bookings
		showNoMeetingsTodayInfoOnTableSplashScreen ()
	else
		showNextMeetingInfoOnTableSplashScreen ()

	// Lights - recall the "all on" preset
	lightsSetLevelWithFade (cLightAddressBoardroom, 100, 1)
	
	// End Enzo session
	enzoSessionEnd (dvEnzo)

	// Video - Turn the monitors off and switch input "none" to the monitor and multi-preview outputs on the DVX
	necMonitorSetPowerOff (vdvMonitorLeft)
	necMonitorSetPowerOff (vdvMonitorRight)
	
	if (dvx.videoOutputs[dvDvxVidOutMonitorLeft.port].testPattern != DVX_TEST_PATTERN_LOGO_3)
	{
		dvxSetVideoOutputTestPattern (dvDvxVidOutMonitorLeft, DVX_TEST_PATTERN_LOGO_3)
		dvx.videoOutputs[dvDvxVidOutMonitorLeft.port].testPattern = DVX_TEST_PATTERN_LOGO_3
	}
	if (dvx.videoOutputs[dvDvxVidOutMonitorRight.port].testPattern != DVX_TEST_PATTERN_LOGO_3)
	{
		dvxSetVideoOutputTestPattern (dvDvxVidOutMonitorRight, DVX_TEST_PATTERN_LOGO_3)
		dvx.videoOutputs[dvDvxVidOutMonitorRight.port].testPattern = DVX_TEST_PATTERN_LOGO_3
	}
	dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorLeft.port)
	dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorRight.port)

	// Audio - Switch input "none" to the speaker output on the DVX, unmute the audio and reset the volume to a base level for next use
	dvxSwitchAudioOnly (dvDvxMain, DVX_PORT_AUD_IN_NONE, dvDvxAudOutSpeakers.port)
	dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
	dvxDisableAudioOutputMute (dvDvxAudOutSpeakers)

	moderoSetPage (dvTpTableMain,PAGE_NAME_SPLASH_SCREEN)
	moderoDisableAllPopups (dvTpTableMain)
	// dectivate the source selection drag areas
	disableDragItemsAll (vdvDragAndDropTpTable)

	// set flag to indicate that system is not in use
	isSystemAvInUse = FALSE
	
	tablePanelInUse = false
	meetingInSession = false

	// clear flags keeping track of selected video/audio inputs
	selectedVideoInputMonitorLeft = FALSE
	selectedVideoInputMonitorRight = FALSE
	selectedAudioInput = FALSE
	audioFollowingVideoOutput = FALSE
	
	cancel_wait 'WAIT_FOR_SIGNAL_OF_INPUT_ROUTED_TO_LEFT_MONITOR_TO_RETURN'
	cancel_wait 'WAIT_FOR_SIGNAL_OF_INPUT_ROUTED_TO_RIGHT_MONITOR_TO_RETURN'
	
	
	userAcknowledgedSelectingInputWithNoSignal = false
	
	wait waitTimeDigitalSignage 'WAITING TO SHOW SIGNAGE'
	{
		dvxSwitchVideoOnly(dvDvxMain, dvDvxVidInSignage.port, dvDvxVidOutMonitorLeft.port)
		dvxSwitchVideoOnly(dvDvxMain, dvDvxVidInSignage.port, dvDvxVidOutMonitorRight.port)
		if (dvx.videoOutputs[dvDvxVidOutMonitorLeft.port].testPattern != DVX_TEST_PATTERN_OFF)
		{
			dvxSetVideoOutputTestPattern (dvDvxVidOutMonitorLeft, DVX_TEST_PATTERN_OFF)
			dvx.videoOutputs[dvDvxVidOutMonitorLeft.port].testPattern = DVX_TEST_PATTERN_OFF
		}
		if (dvx.videoOutputs[dvDvxVidOutMonitorRight.port].testPattern != DVX_TEST_PATTERN_OFF)
		{
			dvxSetVideoOutputTestPattern (dvDvxVidOutMonitorRight, DVX_TEST_PATTERN_OFF)
			dvx.videoOutputs[dvDvxVidOutMonitorRight.port].testPattern = DVX_TEST_PATTERN_OFF
		}
		// turn lights to full on
		lightsSetLevelWithFade (cLightAddressBoardroom, 0, 2)
	}
	
	
	do_push(dvTpTableDebug,1)
}




/*
 *
 *
 */
define_function sendSelectedInputToLeftMonitor (integer input, integer output)
{
	animateTpVideoSourceSelectionClose()
	
	showSourceOnDisplay (input, output)
	
	sendCommand (vdvMultiPreview, "'SNAPSHOTS'")
	
	channelOff (dvTpTableVideo, BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_LEFT)

	if ( (selectedAudioInput == DVX_PORT_AUD_IN_NONE) or
		 ((audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port) and (signalStatusDvxInputMonitorRight != DVX_SIGNAL_STATUS_VALID_SIGNAL))  )
	{
		audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
	}
	
	if (audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port)
	{
		dvxSwitchAudioOnly (dvDvxMain, input, dvDvxAudOutSpeakers.port)
	}
	
	// set flag to indicate that system is in use
	isSystemAvInUse = TRUE
}




/*
 *
 *
 */
define_function sendSelectedInputToRightMonitor (integer input, integer output)
{
	animateTpVideoSourceSelectionClose()
	
	showSourceOnDisplay (input, output)
	
	sendCommand (vdvMultiPreview, "'SNAPSHOTS'")
	
	channelOff (dvTpTableVideo, BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_RIGHT)
	
	if ( (selectedAudioInput == DVX_PORT_AUD_IN_NONE) or
		 ((audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port) and (signalStatusDvxInputMonitorLeft != DVX_SIGNAL_STATUS_VALID_SIGNAL)) )
	{
		audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
	}

	if (audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port)
	{
		dvxSwitchAudioOnly (dvDvxMain, input, dvDvxAudOutSpeakers.port)
	}

	// set flag to indicate that system is in use
	isSystemAvInUse = TRUE
}








/*
 * Reports a valid signal on DXLink MFTX HDMI input.
 *
 * Need to be a little bit careful here. This could be an indicator to tell us someone
 * has just plugged a video source into a table HDMI input but it might also just be
 * a response to the signal status query that we send to each MFTX when the DVX boots.
 *
 * One thing we do know for sure is that if the AV system is already on and this notification
 * comes through just do nothing.
 *
 * We really only want to react to this notification if the system is off in which case
 * we turn the system on and route the DVX to the appropriate DXLink input corresponding
 * to the MFTX that triggered this notification MFTX.
 */
define_function tableInputDetected (dev dvTxVidIn)
{
	#warn '@BUG: amx-au-gc-boardroom-main'

	/*
	 * --------------------
	 * This code running as expected but the MFTX is reporting a valid signal twice when a new input is plugged in.
	 *
	 * The result is that this function is getting called twice.
	 *
	 * If a new laptop input is plugged in when the system is off this function gets called the first time the MFTX reports
	 * a valid signal and routes the newly found laptop video to the left monitor.
	 *
	 * But then the MFTX reports a valid signal again so this function gets called again. This time teh system is already on
	 * and nothing is routed to the right monitor so this function sends the laptop to the right monitor.
	 *
	 * In effect, what the user sees is that when the plug in their laptop it comes on on both screens.
	 *
	 * Not really an issue as far as the user is concerned (they may think the system is designed to do just that) but it's
	 * not what I want to happen!
	 * --------------------
	 */
	
	if ((meetingInSession == true) and (tablePanelInUse == true))
	{
		if (!isSystemAvInUse)
		{
			stack_var integer input
	
			select
			{
				active (dvTxVidIn == dvTxTable1VidInDigital):    input = dvDvxVidInTx1.port
				active (dvTxVidIn == dvTxTable1VidInAnalog):     input = dvDvxVidInTx1.port
	
				active (dvTxVidIn == dvTxTable2VidInDigital):    input = dvDvxVidInTx2.port
				active (dvTxVidIn == dvTxTable2VidInAnalog):     input = dvDvxVidInTx2.port
	
				active (dvTxVidIn == dvTxTable3VidInDigital):    input = dvDvxVidInTx3.port
				active (dvTxVidIn == dvTxTable3VidInAnalog):     input = dvDvxVidInTx3.port
	
				active (dvTxVidIn == dvTxTable4VidInDigital):    input = dvDvxVidInTx4.port
				active (dvTxVidIn == dvTxTable4VidInAnalog):     input = dvDvxVidInTx4.port
			}
			
			sendSelectedInputToLeftMonitor (input, dvDvxVidOutMonitorLeft.port)
		}
		// system is in use - is there a monitor not being used?
		else if (selectedVideoInputMonitorLeft == DVX_PORT_VID_IN_NONE)
		{
			stack_var integer input
			
			select
			{
				active (dvTxVidIn == dvTxTable1VidInDigital):    input = dvDvxVidInTx1.port
				active (dvTxVidIn == dvTxTable1VidInAnalog):     input = dvDvxVidInTx1.port
				
				active (dvTxVidIn == dvTxTable2VidInDigital):    input = dvDvxVidInTx2.port
				active (dvTxVidIn == dvTxTable2VidInAnalog):     input = dvDvxVidInTx2.port
				
				active (dvTxVidIn == dvTxTable3VidInDigital):    input = dvDvxVidInTx3.port
				active (dvTxVidIn == dvTxTable3VidInAnalog):     input = dvDvxVidInTx3.port
				
				active (dvTxVidIn == dvTxTable4VidInDigital):    input = dvDvxVidInTx4.port
				active (dvTxVidIn == dvTxTable4VidInAnalog):     input = dvDvxVidInTx4.port
			}
			
			sendSelectedInputToLeftMonitor (input, dvDvxVidOutMonitorLeft.port)
		}
		else if (selectedVideoInputMonitorRight == DVX_PORT_VID_IN_NONE)
		{
			stack_var integer input
			
			select
			{
				active (dvTxVidIn == dvTxTable1VidInDigital):    input = dvDvxVidInTx1.port
				active (dvTxVidIn == dvTxTable1VidInAnalog):     input = dvDvxVidInTx1.port
				
				active (dvTxVidIn == dvTxTable2VidInDigital):    input = dvDvxVidInTx2.port
				active (dvTxVidIn == dvTxTable2VidInAnalog):     input = dvDvxVidInTx2.port
				
				active (dvTxVidIn == dvTxTable3VidInDigital):    input = dvDvxVidInTx3.port
				active (dvTxVidIn == dvTxTable3VidInAnalog):     input = dvDvxVidInTx3.port
				
				active (dvTxVidIn == dvTxTable4VidInDigital):    input = dvDvxVidInTx4.port
				active (dvTxVidIn == dvTxTable4VidInAnalog):     input = dvDvxVidInTx4.port
			}
			
			sendSelectedInputToRightMonitor (input, dvDvxVidOutMonitorRight.port)
		}
	}
}




/*
 * --------------------
 * Lighting functions
 * --------------------
 */

define_function lightsEnablePresetAllOn()
{
	lightsOn (cLightAddressBoardroom)
}

define_function lightsEnablePresetAllOff()
{
	lightsOff (cLightAddressBoardroom)
}

define_function lightsEnablePresetAllDim()
{
	lightsSetLevelWithFade (cLightAddressBoardroom, LIGHTING_LEVEL_30_PERCENT, 20)
}

define_function lightsEnablePresetPresentation()
{
	lightsSetLevelWithFade (cLightAddressBoardroom, LIGHTING_LEVEL_30_PERCENT, 80)
}

define_function lightsEnablePresetVc()
{
	lightsSetLevelWithFade (cLightAddressBoardroom, LIGHTING_LEVEL_30_PERCENT, 40)
}


/*
 * ----------------
 * Meeting Functions
 * ----------------
 */


define_function userShutdown ()
{
	userShutdownSystemToEndMeeting = true
	shutdownAvSystem ()
}


define_function meetingEnded()
{
	userShutdownSystemToEndMeeting = false
	userInformedMeetingEndingSoon = false
	if (meetingInSession == true)
	{
		shutdownAvSystem ()
	}
}


define_function meetingStarted()
{
	// cancel digital signage and lights off wait statement
	CANCEL_WAIT 'WAITING TO SHOW SIGNAGE'
	
	showCurrentMeetingInfoOnTableSplashScreen ()
	
	if (meetingInSession == false)
	{
		meetingInSession = true
		lightsSetLevelWithFade (cLightAddressBoardroom, 100, 1)
		// show the "Welcome to the Boardroom" blanking image on both outputs
		if (dvx.videoOutputs[dvDvxVidOutMonitorLeft.port].testPattern != DVX_TEST_PATTERN_LOGO_3)
		{
			dvxSetVideoOutputTestPattern (dvDvxVidOutMonitorLeft, DVX_TEST_PATTERN_LOGO_3)
			dvx.videoOutputs[dvDvxVidOutMonitorLeft.port].testPattern = DVX_TEST_PATTERN_LOGO_3
		}
		if (dvx.videoOutputs[dvDvxVidOutMonitorRight.port].testPattern != DVX_TEST_PATTERN_LOGO_3)
		{
			dvxSetVideoOutputTestPattern (dvDvxVidOutMonitorRight, DVX_TEST_PATTERN_LOGO_3)
			dvx.videoOutputs[dvDvxVidOutMonitorRight.port].testPattern = DVX_TEST_PATTERN_LOGO_3
		}
		// switch the "none" video input to both monitor outputs
		dvxSwitchVideoOnly(dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorLeft.port)
		dvxSwitchVideoOnly(dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorRight.port)
	}
}




/*
 * --------------------
 * Override dvx-listener callback functions
 * --------------------
 */


#define INCLUDE_DVX_NOTIFY_VIDEO_OUTPUT_TEST_PATTERN_CALLBACK
define_function dvxNotifyVideoOutputTestPattern (dev dvxVideoOutput, char testPattern[])
{
	// dvxVideoOutput is the D:P:S of the output port on the DVX switcher. The output number can be taken from dvxVideoOutput.PORT
	// testPattern is the test pattern (DVX_TEST_PATTERN_OFF | DVX_TEST_PATTERN_COLOR_BAR | DVX_TEST_PATTERN_GRAY_RAMP | DVX_TEST_PATTERN_SMPTE_BAR | DVX_TEST_PATTERN_HILO_TRACK | DVX_TEST_PATTERN_PLUGE | DVX_TEST_PATTERN_X_HATCH | DVX_TEST_PATTERN_LOGO_1 | DVX_TEST_PATTERN_LOGO_2 | DVX_TEST_PATTERN_LOGO_3)
	//dvx.videoOutputs[dvxVideoOutput.port].testPattern = testPattern
}

#define INCLUDE_DVX_NOTIFY_SWITCH_CALLBACK
define_function dvxNotifySwitch (dev dvxPort1, char signalType[], integer input, integer output)
{
	// dvxPort1 is port 1 on the DVX.
	// signalType contains the type of signal that was switched ('AUDIO' or 'VIDEO')
	// input contains the source input number that was switched to the destination
	// output contains the destination output number that the source was switched to

	switch (signalType)
	{
		case SIGNAL_TYPE_VIDEO:
		{
			select
			{
				active (output == dvDvxVidOutMonitorLeft.port):     selectedVideoInputMonitorLeft = input

				active (output == dvDvxVidOutMonitorRight.port):    selectedVideoInputMonitorRight = input
			}
		}
		case SIGNAL_TYPE_AUDIO:
		{
			select
			{
				active (output == dvDvxAudOutSpeakers.port):    selectedAudioInput = input
			}
		}
	}
}


#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_NAME_CALLBACK
define_function dvxNotifyVideoInputName (dev dvxVideoInput, char name[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// name is the name of the video input

	dvx.videoInputs[dvxVideoInput.port].name = name
}


#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_STATUS_CALLBACK
define_function dvxNotifyVideoInputStatus (dev dvxVideoInput, char signalStatus[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// signalStatus is the input signal status (DVX_SIGNAL_STATUS_NO_SIGNAL | DVX_SIGNAL_STATUS_UNKNOWN | DVX_SIGNAL_STATUS_VALID_SIGNAL)

	stack_var char oldSignalStatus[50]

	oldSignalStatus = dvx.videoInputs[dvxVideoInput.port].status

	if (signalStatus != oldSignalStatus)
	{
		dvx.videoInputs[dvxVideoInput.port].status = signalStatus
	}


	switch (signalStatus)
	{
		case DVX_SIGNAL_STATUS_NO_SIGNAL:
		case DVX_SIGNAL_STATUS_UNKNOWN:
		{
		}
		case DVX_SIGNAL_STATUS_VALID_SIGNAL:
		{
		}
	}

	if (dvxVideoInput.port == selectedVideoInputMonitorLeft)
	{
		signalStatusDvxInputMonitorLeft = signalStatus
	}
	if (dvxVideoInput.port == selectedVideoInputMonitorRight)
	{
		signalStatusDvxInputMonitorRight = signalStatus
	}

	// Energy saving - switch off monitors when signal has been disconnected for some time
	// if signal
	switch (signalStatus)
	{
		case DVX_SIGNAL_STATUS_VALID_SIGNAL:
		{
			if (dvxVideoInput.port == selectedVideoInputMonitorLeft)
			{
				cancel_wait 'WAIT_FOR_SIGNAL_OF_INPUT_ROUTED_TO_LEFT_MONITOR_TO_RETURN'

			}
			if (dvxVideoInput.port == selectedVideoInputMonitorRight)
			{
				cancel_wait 'WAIT_FOR_SIGNAL_OF_INPUT_ROUTED_TO_RIGHT_MONITOR_TO_RETURN'
			}
		}
		case DVX_SIGNAL_STATUS_NO_SIGNAL:
		{
			if (dvxVideoInput.port == selectedVideoInputMonitorLeft)
			{
				wait waitTimeValidSignal 'WAIT_FOR_SIGNAL_OF_INPUT_ROUTED_TO_LEFT_MONITOR_TO_RETURN'
				{
					necMonitorSetPowerOff (vdvMonitorLeft)
					dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorLeft.port)
					if (dvx.videoOutputs[dvDvxVidOutMonitorLeft.port].testPattern != DVX_TEST_PATTERN_LOGO_3)
					{
						dvxSetVideoOutputTestPattern (dvDvxVidOutMonitorLeft, DVX_TEST_PATTERN_LOGO_3)
						dvx.videoOutputs[dvDvxVidOutMonitorLeft.port].testPattern = DVX_TEST_PATTERN_LOGO_3
					}
					off [selectedVideoInputMonitorLeft]
					
					if (audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port)
					{
						if (signalStatusDvxInputMonitorRight == DVX_SIGNAL_STATUS_VALID_SIGNAL)
						{
							dvxSwitchAudioOnly (dvDvxMain, selectedVideoInputMonitorRight, dvDvxAudOutSpeakers.port)
							audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
						}
						else
						{
							dvxSwitchAudioOnly (dvDvxMain, DVX_PORT_AUD_IN_NONE, dvDvxAudOutSpeakers.port)
							dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
							off [selectedAudioInput]
							off [audioFollowingVideoOutput]
						}
					}
				}
			}

			if (dvxVideoInput.port == selectedVideoInputMonitorRight)
			{
				wait waitTimeValidSignal 'WAIT_FOR_SIGNAL_OF_INPUT_ROUTED_TO_RIGHT_MONITOR_TO_RETURN'
				{
					necMonitorSetPowerOff (vdvMonitorRight)
					dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorRight.port)
					if (dvx.videoOutputs[dvDvxVidOutMonitorRight.port].testPattern != DVX_TEST_PATTERN_LOGO_3)
					{
						dvxSetVideoOutputTestPattern (dvDvxVidOutMonitorRight, DVX_TEST_PATTERN_LOGO_3)
						dvx.videoOutputs[dvDvxVidOutMonitorRight.port].testPattern = DVX_TEST_PATTERN_LOGO_3
					}
					off [selectedVideoInputMonitorRight]

					if (audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port)
					{
						if (signalStatusDvxInputMonitorLeft == DVX_SIGNAL_STATUS_VALID_SIGNAL)
						{
							dvxSwitchAudioOnly (dvDvxMain, selectedVideoInputMonitorLeft, dvDvxAudOutSpeakers.port)
							audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
						}
						else
						{
							dvxSwitchAudioOnly (dvDvxMain, DVX_PORT_AUD_IN_NONE, dvDvxAudOutSpeakers.port)
							dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
							off [selectedAudioInput]
							off [audioFollowingVideoOutput]
						}
					}
				}
			}
		}
	}
}


#define INCLUDE_DVX_NOTIFY_AUDIO_OUT_MUTE_CALLBACK
define_function dvxNotifyAudioOutMute (dev dvxAudioOutput, char muteStatus[])
{
	// dvxAudioOutput is the D:P:S of the video output port on the DVX switcher. The output number can be taken from dvDvxAudioOutput.PORT
	// muteStatus is the mute status (STATUS_ENABLE | STATUS_DISABLE)

	dvx.audioOutputs[dvxAudioOutput.port].muteStatus = muteStatus

	if (dvxAudioOutput == dvDvxAudOutSpeakers)
	{
		switch (muteStatus)
		{
			case STATUS_ENABLE:    moderoEnableButtonFeedback (dvTpTableAudio, BTN_AUDIO_VOLUME_MUTE)
			
			case STATUS_DISABLE:   moderoDisableButtonFeedback (dvTpTableAudio, BTN_AUDIO_VOLUME_MUTE)
		}
	}
}


#define INCLUDE_DVX_NOTIFY_AUDIO_OUT_VOLUME_CALLBACK
define_function dvxNotifyAudioOutVolume (dev dvxAudioOutput, integer volume)
{
	// dvxAudioOutput is the D:P:S of the video output port on the DVX switcher. The output number can be taken from dvDvxAudioOutput.PORT
	// volume is the volume value (range: 0 to 100)

	dvx.audioOutputs[dvxAudioOutput.port].volume = volume

	if (dvxAudioOutput == dvDvxAudOutSpeakers)
	{
		send_level dvTpTableAudio, BTN_LVL_VOLUME_DISPLAY, volume
	}
}

#define INCLUDE_DVX_NOTIFY_AUDIO_OUT_MAXIMUM_VOLUME_CALLBACK
define_function dvxNotifyAudioOutMaximumVolume (dev dvxAudioOutput, integer maxVol)
{
	// dvxAudioOutput is the D:P:S of the video output port on the DVX switcher. The output number can be taken from dvDvxAudioOutput.PORT
	// maxVol is the maximum volume setting for the audio output port (range: 0 to 100)

	if (dvxAudioOutput == dvDvxAudOutSpeakers)
	{
		moderoSetButtonBargraphUpperLimit (dvTpTableAudio, BTN_ADR_VOLUME_BARGRAPH_CONTROL, /*MODERO_BUTTON_STATE_ALL,*/ maxVol)
		moderoSetButtonBargraphUpperLimit (dvTpTableAudio, BTN_ADR_VOLUME_BARGRAPH_DISPLAY, /*MODERO_BUTTON_STATE_ALL,*/ maxVol)
	}
}


/*
 * --------------------
 * Override dxlink-listener callback functions
 * --------------------
 */


#define INCLUDE_DXLINK_NOTIFY_RX_VIDEO_OUTPUT_RESOLUTION_CALLBACK
define_function dxlinkNotifyRxVideoOutputResolution (dev dxlinkRxVideoOutput, char resolution[])
{
	// dxlinkRxVideoOutput is the D:P:S of the video output port on the DXLink receiver
	// cResolution is the video output resolution and refresh (HORxVER,REF)

	select
	{
		active(dxlinkRxVideoOutput == dvRxMonitorLeftVidOut):
		{
			moderoSetButtonText(dvTpTableDxlink,
					BTN_ADR_DXLINK_RX_OUTPUT_RESOLUTION_MONITOR_LEFT,
					MODERO_BUTTON_STATE_ALL,
					resolution)
		}

		active(dxlinkRxVideoOutput == dvRxMonitorRightVidOut):
			moderoSetButtonText (dvTpTableDxlink, BTN_ADR_DXLINK_RX_OUTPUT_RESOLUTION_MONITOR_RIGHT, MODERO_BUTTON_STATE_ALL, resolution)
	}
}


#define INCLUDE_DXLINK_NOTIFY_RX_VIDEO_OUTPUT_SCALE_MODE_CALLBACK
define_function dxlinkNotifyRxVideoOutputScaleMode (dev dxlinkRxVideoOutput, char scaleMode[])
{
	// dxlinkRxVideoOutput is the D:P:S of the video output port on the DXLink receiver
	// scaleMode contains the scaler mode (DXLINK_SCALE_MODE_AUTO | DXLINK_SCALE_MODE_BYPASS | DXLINK_SCALE_MODE_MANUAL)

	select
	{
		active(dxlinkRxVideoOutput == dvRxMonitorLeftVidOut):
		{
			switch (scaleMode)
			{
				case DXLINK_SCALE_MODE_AUTO:    moderoEnableButtonFeedback(dvTpTableDxlink, BTN_DXLINK_RX_SCALER_AUTO_MONITOR_LEFT)
				case DXLINK_SCALE_MODE_BYPASS:  moderoEnableButtonFeedback( dvTpTableDxlink, BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_LEFT)
				case DXLINK_SCALE_MODE_MANUAL:  moderoEnableButtonFeedback( dvTpTableDxlink, BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_LEFT)
			}
		}

		active(dxlinkRxVideoOutput == dvRxMonitorRightVidOut):
		{
			switch (scaleMode)
			{
				case DXLINK_SCALE_MODE_AUTO:    moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_SCALER_AUTO_MONITOR_RIGHT)
				case DXLINK_SCALE_MODE_BYPASS:  moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_RIGHT)
				case DXLINK_SCALE_MODE_MANUAL:  moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_RIGHT)
			}
		}
	}
}


#define INCLUDE_DXLINK_NOTIFY_RX_VIDEO_OUTPUT_ASPECT_RATIO_CALLBACK
define_function dxlinkNotifyRxVideoOutputAspectRatio (dev dxlinkRxVideoOutput, char aspectRatio[])
{
	// dxlinkRxVideoOutput is the D:P:S of the video output port on the DXLink receiver
	// cAspectRatio is the aspect ratio (DXLINK_ASPECT_RATIO_ANAMORPHIC | DXLINK_ASPECT_RATIO_MAINTAIN | DXLINK_ASPECT_RATIO_STRETCH | DXLINK_ASPECT_RATIO_ZOOM)

	select
	{
		active(dxlinkRxVideoOutput == dvRxMonitorLeftVidOut):
		{
			switch (aspectRatio)
			{
				case DXLINK_ASPECT_RATIO_ANAMORPHIC:    moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_LEFT)
				case DXLINK_ASPECT_RATIO_MAINTAIN:      moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_LEFT)
				case DXLINK_ASPECT_RATIO_STRETCH:       moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_LEFT)
				case DXLINK_ASPECT_RATIO_ZOOM:          moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_LEFT)
			}
		}

		active(dxlinkRxVideoOutput == dvRxMonitorRightVidOut):
		{
			switch (aspectRatio)
			{
				case DXLINK_ASPECT_RATIO_ANAMORPHIC:    moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_RIGHT)
				case DXLINK_ASPECT_RATIO_MAINTAIN:      moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_RIGHT)
				case DXLINK_ASPECT_RATIO_STRETCH:       moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_RIGHT)
				case DXLINK_ASPECT_RATIO_ZOOM:          moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_RIGHT)
			}
		}
	}
}


#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_AUTO_SELECT_CALLBACK
define_function dxlinkNotifyTxVideoInputAutoSelect (dev dxlinkTxPort1, char status[])
{
	// dvDxlinkTxPort1 is the port #1 on the DXLink Tx
	// cStatus contains the auto video input select status (STATUS_ENABLE | STATUS_DISABLE)

	switch (status)
	{
		case STATUS_ENABLE:
		{
			select
			{
				active (dxlinkTxPort1 == dvTxTable1Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_1)
				active (dxlinkTxPort1 == dvTxTable2Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_2)
				active (dxlinkTxPort1 == dvTxTable3Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_3)
				active (dxlinkTxPort1 == dvTxTable4Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_4)
			}
		}
		case STATUS_DISABLE:
		{
			select
			{
				active (dxlinkTxPort1 == dvTxTable1Main):   moderoDisableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_1)
				active (dxlinkTxPort1 == dvTxTable2Main):   moderoDisableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_2)
				active (dxlinkTxPort1 == dvTxTable3Main):   moderoDisableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_3)
				active (dxlinkTxPort1 == dvTxTable4Main):   moderoDisableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_AUTO_4)
			}
		}
	}
}


#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_STATUS_ANALOG_CALLBACK
define_function dxlinkNotifyTxVideoInputStatusAnalog (dev dxlinkTxAnalogVideoInput, char signalStatus[])
{
	// dxlinkTxAnalogVideoInput is the analog video input port on the DXLink Tx
	// signalStatus is the input signal status (DXLINK_SIGNAL_STATUS_NO_SIGNAL | DXLINK_SIGNAL_STATUS_UNKNOWN | DXLINK_SIGNAL_STATUS_VALID_SIGNAL)

	switch (signalStatus)
	{
		case DXLINK_SIGNAL_STATUS_UNKNOWN:    {}

		case DXLINK_SIGNAL_STATUS_NO_SIGNAL:  {}

		case DXLINK_SIGNAL_STATUS_VALID_SIGNAL:
		{
			tableInputDetected (dxlinkTxAnalogVideoInput)
		}
	}
}


#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_STATUS_DIGITAL_CALLBACK
define_function dxlinkNotifyTxVideoInputStatusDigital (dev dxlinkTxDigitalVideoInput, char signalStatus[])
{
	// dxlinkTxDigitalVideoInput is the digital video input port on the DXLink Tx
	// signalStatus is the input signal status (DXLINK_SIGNAL_STATUS_NO_SIGNAL | DXLINK_SIGNAL_STATUS_UNKNOWN | DXLINK_SIGNAL_STATUS_VALID_SIGNAL)

	switch (signalStatus)
	{
		case DXLINK_SIGNAL_STATUS_UNKNOWN:    {}

		case DXLINK_SIGNAL_STATUS_NO_SIGNAL:  {}

		case DXLINK_SIGNAL_STATUS_VALID_SIGNAL:
		{
			tableInputDetected (dxlinkTxDigitalVideoInput)
		}
	}
}

#define INCLUDE_DXLINK_NOTIFY_TX_SWITCH_CALLBACK
define_function dxlinkNotifyTxSwitch (dev dxlinkTxPort1, integer input, integer output)
{
	// dxlinkTxPort1 is port 1 on the DXLink Tx.
	// input contains the input port on the DXLink TX that has been selected (DXLINK_PORT_VIDEO_INPUT_ANALOG | DXLINK_PORT_VIDEO_INPUT_DIGITAL)
	// output contains the output of the DXLink TX. This is always DXLINK_PORT_VIDEO_OUTPUT.

	switch (input)
	{
		case DXLINK_PORT_VIDEO_INPUT_ANALOG:
		{
			select
			{
				active (dxlinkTxPort1 == dvTxTable1Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_VGA_1)
				active (dxlinkTxPort1 == dvTxTable2Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_VGA_2)
				active (dxlinkTxPort1 == dvTxTable3Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_VGA_3)
				active (dxlinkTxPort1 == dvTxTable4Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_VGA_4)
			}
		}
		case DXLINK_PORT_VIDEO_INPUT_DIGITAL:
		{
			select
			{
				active (dxlinkTxPort1 == dvTxTable1Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_HDMI_1)
				active (dxlinkTxPort1 == dvTxTable2Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_HDMI_2)
				active (dxlinkTxPort1 == dvTxTable3Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_HDMI_3)
				active (dxlinkTxPort1 == dvTxTable4Main):   moderoEnableButtonFeedback (dvTpTableDxlink, BTN_DXLINK_TX_HDMI_4)
			}
		}
	}
}


/*
 * --------------------
 * Override pdu-listener callback functions
 * --------------------
 */



#define INCLUDE_PDU_NOTIFY_POWER_SENSE_TRIGGER_CALLBACK
define_function pduNotifyPowerSenseTrigger (dev pduPort1, integer outlet, float triggerValue)
{
	// pduPort1 is port 1 on the PDU
	// outlet is the outlet of the PDU which is reporting the power sense trigger value
	// triggerValue is the power sense trigger value

	moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_TRIGGER[outlet], MODERO_BUTTON_STATE_ALL, ftoa(triggerValue))
}


#define INCLUDE_PDU_NOTIFY_OUTLET_OVER_POWER_SENSE_TRIGGER_CALLBACK
define_function pduNotifyOutletOverPowerSenseTrigger (dev pduOutletPort)
{
	// dvPduOutlet is an outlet device on the PDU which has gone over the power sense trigger value
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[1], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[2], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[3], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[4], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[5], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[6], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[7], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[8], MODERO_BUTTON_STATE_ALL, 'Above')
	}
}


#define INCLUDE_PDU_NOTIFY_OUTLET_UNDER_POWER_SENSE_TRIGGER_CALLBACK
define_function pduNotifyOutletUnderPowerSenseTrigger (dev pduOutletPort)
{
	// pduOutletPort is an outlet device on the PDU which has gone under the power sense trigger value
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[1], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[2], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[3], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[4], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[5], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[6], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[7], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[8], MODERO_BUTTON_STATE_ALL, 'Below')
	}
}


#define INCLUDE_PDU_NOTIFY_OUTLET_RELAY_CALLBACK
define_function pduNotifyOutletRelay (dev pduOutletPort, integer relayStatus)
{
	// dvPduOutlet is an outlet device on the PDU
	// nRelayStatus indicates whether the relay is on (TRUE) or off (FALSE)
	switch (relayStatus)
	{
		case TRUE:
		{
			select
			{
				active (pduOutletPort == dvPduOutlet1):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[1], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet2):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[2], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet3):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[3], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet4):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[4], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet5):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[5], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet6):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[6], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet7):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[7], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet8):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[8], MODERO_BUTTON_STATE_ALL, 'On')
			}
		}
		case FALSE:
		{
			select
			{
				active (pduOutletPort == dvPduOutlet1):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[1], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet2):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[2], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet3):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[3], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet4):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[4], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet5):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[5], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet6):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[6], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet7):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[7], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet8):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[8], MODERO_BUTTON_STATE_ALL, 'Off')
			}
		}
	}
}



#define INCLUDE_PDU_NOTIFY_INPUT_VOLTAGE_CALLBACK
define_function pduNotifyInputVoltage (dev pduPort1, float voltage)
{
	// pduPort1 is the first device on the PDU
	// voltage is the input voltage (V): Resolution to 0.1V (data scale factor = 10)
	moderoSetButtonText (dvTpTablePower, BTN_ADR_POWER_INPUT_VOLTAGE, MODERO_BUTTON_STATE_ALL, ftoa(voltage))
}


#define INCLUDE_PDU_NOTIFY_TEMPERATURE_CALLBACK
define_function pduNotifyTemperature (dev pduPort1, float temperature)
{
	// pduPort1 is the first device on the PDU
	// temperature is the temperature (degrees C or F): Resolution to 0.1C (data scale factor = 10)
	moderoSetButtonText (dvTpTablePower, BTN_ADR_POWER_TEMPERATURE, MODERO_BUTTON_STATE_ALL, ftoa(temperature))
}


#define INCLUDE_PDU_NOTIFY_OUTLET_POWER_CALLBACK
define_function pduNotifyOutletPower (dev pduOutletPort, float wattage)
{
	// pduOutletPort is the outlet on the PDU reporting its power
	// wattage is the power (W): Resolution to 0.1W (data scale factor = 10)
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[1], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[2], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[3], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[4], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[5], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[6], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[7], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[8], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
	}
}


#define INCLUDE_PDU_NOTIFY_OUTLET_CURRENT_CALLBACK
define_function pduNotifyOutletCurrent (dev pduOutletPort, float current)
{
	// pduOutletPort is the outlet on the PDU reporting its current
	// current is the curren (A): Resolution to 0.1A (data scale factor = 10)
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[1], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[2], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[3], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[4], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[5], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[6], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[7], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[8], MODERO_BUTTON_STATE_ALL, ftoa(current))
	}
}



#define INCLUDE_PDU_NOTIFY_OUTLET_POWER_CALLBACK
define_function pduNotifyOutletEnergy (dev pduOutletPort, float accumulatedEnergy)
{
	// pduOutletPort is the outlet on the PDU reporting its accumulated energy
	// accumulatedEnergy is the accumulated energy reading or power over time (W-hr): Resolution to 0.1W-hr (data scale factor = 10)
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[1], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[2], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[3], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[4], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[5], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[6], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[7], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[8], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
	}
}


#define INCLUDE_PDU_NOTIFY_AXLINK_VOLTAGE_CALLBACK
define_function pduNotifyAxlinkVoltage (dev pduPort2, float voltage)
{
	// pduPort2 is an Axlink bus on the PDU
	// voltage is the voltage (V): Resolution to 0.1V (data scale factor = 10)
	moderoSetButtonText (dvTpTablePower, BTN_ADR_POWER_AXLINK_VOLTAGE, MODERO_BUTTON_STATE_ALL, ftoa(voltage))
}







/*
 * --------------------
 * Override controlports-listener callback functions
 * --------------------
 */


#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_ON_CALLBACK
define_function amxControlPortNotifyIoInputOn (dev ioPort, integer ioChanCde)
{
	// ioPort is the IO port.
	// ioChanCde is the IO channel code.

	if (ioPort == dvDvxIos)
	{
		switch (ioChanCde)
		{
			case IO_OCCUPANCY_SENSOR:
			{
				// occupancy has been detected - meaning the room was previously vacant
				isRoomOccupied = TRUE

				// Set lights to "all on" mode as people have entered the room
				lightsEnablePresetAllOn ()

				// wake up the touch panel
				moderoWake (dvTpTableMain)
			}
		}
	}
}



#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_OFF_CALLBACK
define_function amxControlPortNotifyIoInputOff (dev ioPort, integer ioChanCde)
{
	// ioPort is the IO port.
	// ioChanCde is the IO channel code.

	if (ioPort == dvDvxIos)
	{
		switch (ioChanCde)
		{
			case IO_OCCUPANCY_SENSOR:
			{
				// room is now unoccupied (note: Will take 8 minutes minimum to trigger after person leaves room)
				isRoomOccupied = FALSE

				// Set lights to "all off" mode as there have been no people in the room for at least 8 minutes
				lightsEnablePresetAllOff ()

				// Flip the touch panel to the splash screen
				moderoSetPage (dvTpTableMain, PAGE_NAME_SPLASH_SCREEN)

				// Send the panel to sleep
				moderoSleep (dvTpTableMain)

				// Stop taking snapshots
				//stopMultiPreviewSnapshots ()

				// shutdown the system if it was being used (i.e., someone just walked away without pressing the shutdown button on the panel)
				if (isSystemAvInUse)
				{
					countTimesPeopleLeftWithoutShuttingDownSystem++
					shutdownAvSystem ()
				}
			}
		}
	}
}




/*
 * --------------------
 * Override RmsSchedulingEventListener callback functions
 * --------------------
 */



(***********************************************************)
(* Name:  RmsEventSchedulingActiveResponse                 *)
(* Args:                                                   *)
(* CHAR isDefaultLocation - boolean, TRUE if the location  *)
(* in the response is the default location                 *)
(*                                                         *)
(* INTEGER recordIndex - The index position of this record *)
(*                                                         *)
(* INTEGER recordCount - Total record count                *)
(*                                                         *)
(* CHAR bookingId[] - The booking ID string                *)
(*                                                         *)
(* RmsEventBookingResponse eventBookingResponse - A        *)
(* structure with additional booking information           *)
(*                                                         *)
(* Desc:  Implementations of this method will be called    *)
(* in response to a query for the current active booking   *)
(*                                                         *)
(***********************************************************)
#DEFINE INCLUDE_SCHEDULING_ACTIVE_RESPONSE_CALLBACK
DEFINE_FUNCTION RmsEventSchedulingActiveResponse(CHAR isDefaultLocation, 
												 INTEGER recordIndex, 
												 INTEGER recordCount, 
												 CHAR bookingId[], 
												 RmsEventBookingResponse eventBookingResponse)
{
	debugPrint ("'******************** FUNCTION - RmsEventSchedulingActiveResponse(...)'")
	debugPrint ("'isDefaultLocation = ',itoa(isDefaultLocation)")
	debugPrint ("'recordIndex = ',itoa(recordIndex)")
	debugPrint ("'recordCount = ',itoa(recordCount)")
	debugPrint ("'bookingId = ',bookingId")
	debugPrintRmsEventBookingResponse (eventBookingResponse)
	debugPrint ("'******************************** END FUNCTION ********************************'")
	
	
	updateCurrentMeetingInfo (eventBookingResponse)
}

(***********************************************************)
(* Name:  RmsEventSchedulingNextActiveResponse             *)
(* Args:                                                   *)
(* CHAR isDefaultLocation - boolean, TRUE if the location  *)
(* in the response is the default location                 *)
(*                                                         *)
(* INTEGER recordIndex - The index position of this record *)
(*                                                         *)
(* INTEGER recordCount - Total record count                *)
(*                                                         *)
(* CHAR bookingId[] - The booking ID string                *)
(*                                                         *)
(* RmsEventBookingResponse eventBookingResponse - A        *)
(* structure with additional booking information           *)
(*                                                         *)
(* Desc:  Implementations of this method will be called    *)
(* in response to a query for the next active booking      *)
(*                                                         *)
(***********************************************************)
#DEFINE INCLUDE_SCHEDULING_NEXT_ACTIVE_RESPONSE_CALLBACK
DEFINE_FUNCTION RmsEventSchedulingNextActiveResponse(CHAR isDefaultLocation, 
													INTEGER recordIndex, 
													INTEGER recordCount, 
													CHAR bookingId[], 
													RmsEventBookingResponse eventBookingResponse)
{
	debugPrint ("'******************** FUNCTION - RmsEventSchedulingNextActiveResponse(...)'")
	debugPrint ("'isDefaultLocation = ',itoa(isDefaultLocation)")
	debugPrint ("'recordIndex = ',itoa(recordIndex)")
	debugPrint ("'recordCount = ',itoa(recordCount)")
	debugPrint ("'bookingId = ',bookingId")
	debugPrintRmsEventBookingResponse (eventBookingResponse)
	debugPrint ("'******************************** END FUNCTION ********************************'")
	
	
	updateNextMeetingInfo (eventBookingResponse)
}



define_function updateCurrentMeetingInfo (RmsEventBookingResponse eventBookingResponse)
{
	stack_var char subject[RMS_MAX_PARAM_LEN]
	
	// make a copy of the details field so we are not altering the value that was passed through
	subject = eventBookingResponse.subject
	
	if (find_string(subject,adHocBookingSubjectHeader,1) == 1)
	{
		remove_string (subject,adHocBookingSubjectHeader,1)
		rmsSchedule.currentMeetingOrganizerName = subject
	}
	else
	{
		rmsSchedule.currentMeetingOrganizerName = eventBookingResponse.organizer
	}

	rmsSchedule.bookingIdCurrentMeeting = eventBookingResponse.bookingId
	#warn 'code NFC'
	rmsSchedule.currentMeetingOrganizerNfcUid = ''
	
	rmsSchedule.currentMeetingRemainingMinutes = eventBookingResponse.remainingMinutes
	rmsSchedule.currentMeetingElapsedMinutes = eventBookingResponse.elapsedMinutes
	rmsSchedule.currentMeetingStartTime = eventBookingResponse.startTime
	rmsSchedule.currentMeetingEndTime = eventBookingResponse.endTime
	rmsSchedule.currentMeetingStartDate = eventBookingResponse.startDate
	rmsSchedule.currentMeetingEndDate = eventBookingResponse.endDate
    rmsSchedule.currentMeetingSubject = eventBookingResponse.subject
    rmsSchedule.currentMeetingDetails = eventBookingResponse.details
}


define_function updateNextMeetingInfo (RmsEventBookingResponse eventBookingResponse)
{
	stack_var char subject[RMS_MAX_PARAM_LEN]
	
	// make a copy of the details field so we are not altering the value that was passed through
	subject = eventBookingResponse.subject
	
	if (find_string(subject,adHocBookingSubjectHeader,1) == 1)
	{
		remove_string (subject,adHocBookingSubjectHeader,1)
		rmsSchedule.nextMeetingOrganizerName = subject
	}
	else
	{
		rmsSchedule.nextMeetingOrganizerName = eventBookingResponse.organizer
	}
	
	rmsSchedule.bookingIdNextMeeting = eventBookingResponse.bookingId
	#warn 'code NFC'
	rmsSchedule.nextMeetingOrganizerNfcUid = ''
	
	rmsSchedule.nextMeetingMinutesUntilStart = eventBookingResponse.minutesUntilStart
	rmsSchedule.nextMeetingStartTime = eventBookingResponse.startTime
	rmsSchedule.nextMeetingEndTime = eventBookingResponse.endTime
	rmsSchedule.nextMeetingStartDate = eventBookingResponse.startDate
	rmsSchedule.nextMeetingEndDate = eventBookingResponse.endDate
    rmsSchedule.nextMeetingSubject = eventBookingResponse.subject
    rmsSchedule.nextMeetingDetails = eventBookingResponse.details
}


define_function clearCurrentMeetingInfo ()
{
	rmsSchedule.bookingIdCurrentMeeting = ''
	rmsSchedule.currentMeetingOrganizerName = ''
	rmsSchedule.currentMeetingOrganizerNfcUid = ''
	rmsSchedule.currentMeetingRemainingMinutes = 0
	rmsSchedule.currentMeetingElapsedMinutes = 0
	rmsSchedule.currentMeetingStartTime = ''
	rmsSchedule.currentMeetingEndTime = ''
	rmsSchedule.currentMeetingStartDate = ''
	rmsSchedule.currentMeetingEndDate = ''
    rmsSchedule.currentMeetingSubject = ''
    rmsSchedule.currentMeetingDetails = ''
}

define_function clearNextMeetingInfo ()
{
	rmsSchedule.bookingIdNextMeeting = ''
	rmsSchedule.nextMeetingOrganizerName = ''
	rmsSchedule.nextMeetingOrganizerNfcUid = ''
	rmsSchedule.nextMeetingMinutesUntilStart = 0
	rmsSchedule.nextMeetingStartTime = ''
	rmsSchedule.nextMeetingEndTime = ''
	rmsSchedule.nextMeetingStartDate = ''
	rmsSchedule.nextMeetingEndDate = ''
	rmsSchedule.nextMeetingSubject = ''
	rmsSchedule.nextMeetingDetails = ''
}

(***********************************************************)
(* Name:  RmsEventSchedulingCreateResponse                 *)
(* Args:                                                   *)
(* CHAR isDefaultLocation - boolean, TRUE if th location   *)
(* in the response is the default location                 *)
(*                                                         *)
(* CHAR responseText[] - Booking ID if successful else     *)
(* some error information.                                 *)
(*                                                         *)
(* RmsEventBookingResponse eventBookingResponse - A        *)
(* structure with additional booking information           *)
(*                                                         *)
(* Desc:  Implementations of this method will be called    *)
(* in response to a booking creation request               *)
(*                                                         *)
(***********************************************************)
#DEFINE INCLUDE_SCHEDULING_CREATE_RESPONSE_CALLBACK
DEFINE_FUNCTION RmsEventSchedulingCreateResponse(CHAR isDefaultLocation, 
												 CHAR responseText[], 
											     RmsEventBookingResponse eventBookingResponse)
{
	debugPrint ("'******************** FUNCTION - RmsEventSchedulingCreateResponse(...)'")
	debugPrint ("'isDefaultLocation = ',itoa(isDefaultLocation)")
	debugPrint ("'responseText = ',responseText")
	debugPrintRmsEventBookingResponse (eventBookingResponse)
	debugPrint ("'******************************** END FUNCTION ********************************'")
	
	waitingForAdhocBookingResponse = false
	
	startTimerLockWelcomePanel ()
	
	if (eventBookingResponse.isSuccessful) // attempt to create a booking was successful
	{
		moderoEnablePopupOnPage (dvTpSchedulingMain, popupBookingSuccessful, pageWelcomePanelUnlocked)
		
		if (schedulingPanelInUse == true)
		{
			schedulingPanelShowingBookingSucceededMessageWhileInUse = true
		}
		
		if (rmsSchedule.bookingIdCurrentMeeting != '')// there is a meeting currently in session
		{
			// This is not an ad-hoc booking for now (NEXT | LATER)
			if ((eventBookingResponse.startDate == rmsSchedule.currentMeetingEndDate) and (eventBookingResponse.startTime == rmsSchedule.currentMeetingEndTime)) // created meeting starts exactly when current meeting ends
			{
				// this is the new "next" meeting (NEXT)
				updateNextMeetingInfo (eventBookingResponse)
			}
			else // created meeting does not start exactly when current meeting ends
			{
				if (rmsSchedule.bookingIdNextMeeting != '') // there is currently a "next" meeting scheduled for later today
				{
					stack_var char createdMeetingStartShortDate[8]
					stack_var char nextMeetingStartShortDate[8]
					
					createdMeetingStartShortDate = "left_string(eventBookingResponse.startDate,2),'/',
					                               mid_string(eventBookingResponse.startDate,4,2),'/',
											       right_string(eventBookingResponse.startDate,2)"
					
					nextMeetingStartShortDate = "left_string(rmsSchedule.nextMeetingStartDate,2),'/',
					                           mid_string(rmsSchedule.nextMeetingStartDate,4,2),'/',
											   right_string(rmsSchedule.nextMeetingStartDate,2)"
					
					if ( getDateTimeEncoding(createdMeetingStartShortDate, eventBookingResponse.StartTime) < getDateTimeEncoding(nextMeetingStartShortDate, rmsSchedule.nextMeetingStartTime) ) // created meeting starts before the "next" meeting
					{
						// this is the new "next" meeting (NEXT)
						updateNextMeetingInfo (eventBookingResponse)
					}
					else // created meeting does not start before the next meeting
					{
						// this meeting is for later today - just ignore as we only care about the "current" and "next" meeting
					}
				}
				else // no meetings scheduled
				{
					// this is the new "next" meeting (NEXT)
					updateNextMeetingInfo (eventBookingResponse)
				}
			}
		}
		else // there is no current meeting in session
		{
			// This could be a booking for any time (NOW | NEXT | LATER)
			if (getDifferenceInMinutesIgnoreSeconds(eventBookingResponse.startTime, time) <= 1) // created booking start time within 1 minute of system time
			{
				// this is the new "now" meeting (NOW)
				updateCurrentMeetingInfo (eventBookingResponse)
				//meeting is yet to officially start but lets kick it off early since the room is free and the meeting just created was for "now"
				meetingStarted()
			}
			else // created booking start time is not within 1 minute of system time
			{
				if (rmsSchedule.bookingIdNextMeeting != '') // there is currently a "next" meeting scheduled for later today
				{
					stack_var char createdMeetingStartShortDate[8]
					stack_var char nextMeetingStartShortDate[8]
					
					createdMeetingStartShortDate = "left_string(eventBookingResponse.startDate,2),'/',
					                               mid_string(eventBookingResponse.startDate,4,2),'/',
											       right_string(eventBookingResponse.startDate,2)"
					
					nextMeetingStartShortDate = "left_string(rmsSchedule.nextMeetingStartDate,2),'/',
					                           mid_string(rmsSchedule.nextMeetingStartDate,4,2),'/',
											   right_string(rmsSchedule.nextMeetingStartDate,2)"
					
					if ( getDateTimeEncoding(createdMeetingStartShortDate, eventBookingResponse.StartTime) < getDateTimeEncoding(nextMeetingStartShortDate, rmsSchedule.nextMeetingStartTime) ) // created meeting starts before the "next" meeting
					{
						// this is the new "next" meeting (NEXT)
						updateNextMeetingInfo (eventBookingResponse)
					}
					else // created meeting does not start before the next meeting
					{
						// this meeting is for later today - just ignore as we only care about the "current" and "next" meeting
					}
				}
				else // no meetings scheduled
				{
					// this is the new "next" meeting (NEXT)
					updateNextMeetingInfo (eventBookingResponse)
				}
			}
		}
	}
	else	// attempt to create a booking failed
	{
		moderoEnablePopupOnPage (dvTpSchedulingMain, popupBookingUnsuccessful, pageWelcomePanelUnlocked)
	}
}

(***********************************************************)
(* Name:  RmsEventSchedulingExtendResponse                 *)
(* Args:                                                   *)
(* CHAR isDefaultLocation - boolean, TRUE if the location  *)
(* in the response is the default location                 *)
(*                                                         *)
(* CHAR responseText[] - Booking ID if successful else     *)
(* some error information.                                 *)
(*                                                         *)
(* RmsEventBookingResponse eventBookingResponse - A        *)
(* structure with additional booking information           *)
(*                                                         *)
(* Desc:  Implementations of this method will be called    *)
(* in response to a extending a booking event              *)
(*                                                         *)
(***********************************************************)
#DEFINE INCLUDE_SCHEDULING_EXTEND_RESPONSE_CALLBACK
DEFINE_FUNCTION RmsEventSchedulingExtendResponse(CHAR isDefaultLocation, 
												 CHAR responseText[], 
												 RmsEventBookingResponse eventBookingResponse)
{
	debugPrint ("'******************** FUNCTION - RmsEventSchedulingExtendResponse(...)'")
	debugPrint ("'isDefaultLocation = ',itoa(isDefaultLocation)")
	debugPrint ("'responseText = ',responseText")
	debugPrintRmsEventBookingResponse (eventBookingResponse)
	debugPrint ("'******************************** END FUNCTION ********************************'")
	
	switch (eventBookingResponse.isSuccessful)
	{
		case false:
		{
			// deactivate the source selection drag areas
			disableDragItemsAll (vdvDragAndDropTpTable)
			moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_MEETING_TIME_REMAINING, MODERO_BUTTON_STATE_ALL, getFuzzyTimeString(eventBookingResponse.endTime))
			moderoEnablePopupOnPage (dvTpTableMain, POPUP_NAME_MEETING_EXTEND_FAILURE, PAGE_NAME_MAIN_USER)
			// play a sound that indicates failure
			moderoPlaySoundFile (dvTpTableMain, soundFileInvalidId)
		}
		case true:
		{
			// deactivate the source selection drag areas
			disableDragItemsAll (vdvDragAndDropTpTable)
			//moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_MEETING_END_TIME, MODERO_BUTTON_STATE_ALL, endTime12HourFormat)
			moderoSetButtonText (dvTpTableRmsCustom, BTN_ADR_TABLE_PANEL_MEETING_END_TIME, MODERO_BUTTON_STATE_ALL, getTimeString12HourFormatAmPm (eventBookingResponse.endTime))
			moderoEnablePopupOnPage (dvTpTableMain, POPUP_NAME_MEETING_EXTEND_SUCCESS, PAGE_NAME_MAIN_USER)
			// play a sound that indicates success
			moderoPlaySoundFile (dvTpTableMain, soundFileValidId)
		}
	}
}


(***********************************************************)
(* Name:  RmsEventSchedulingActiveUpdated                  *)
(* Args:                                                   *)
(* CHAR bookingId[] - The booking ID string                *)
(*                                                         *)
(* RmsEventBookingResponse eventBookingResponse - A        *)
(* structure with additional booking information           *)
(*                                                         *)
(* Desc:  Implementations of this method will be called    *)
(* when RMS indicates there was an update to an active     *)
(* booking event                                           *)
(*                                                         *)
(***********************************************************)
#DEFINE INCLUDE_SCHEDULING_ACTIVE_UPDATED_CALLBACK
DEFINE_FUNCTION RmsEventSchedulingActiveUpdated(CHAR bookingId[], 
												RmsEventBookingResponse eventBookingResponse)
{
	debugPrint ("'******************** FUNCTION - RmsEventSchedulingActiveUpdated(...)'")
	debugPrint ("'bookingId = ',bookingId")
	debugPrintRmsEventBookingResponse (eventBookingResponse)
	debugPrint ("'******************************** END FUNCTION ********************************'")
	
	
	updateCurrentMeetingInfo (eventBookingResponse)
	
	if (userShutdownSystemToEndMeeting == false)
	{
		showCurrentMeetingInfoOnTableSplashScreen ()
		showCurrentMeetingInfoCardOnWelcomePanel ()
	}
	else
	{
		if (rmsSchedule.bookingIdNextMeeting != '')
			showNextMeetingInfoCardOnWelcomePanel ()
		else
			hideMeetingInfoCardOnWelcomePanel()
	}
	
	
	if (rmsSchedule.currentMeetingRemainingMinutes == minutesRemainingToNotifyUserAboutBookingEnd)
	{
		// check that we haven't already done this for this meeting (this function sometimes gets called multiple times within a minute in which case it will have the
		// same values 2 times in a row - we don't want to annoy the user and have the "meeting ending soon" message display again if they've already dismissed it
		if ((userInformedMeetingEndingSoon == false) and (tablePanelInUse == true))
		{
			userInformedMeetingEndingSoon = true
		
			if (rmsSchedule.bookingIdNextMeeting == '')	// no upcoming meetings
			{
				// deactivate the source selection drag areas
				disableDragItemsAll (vdvDragAndDropTpTable)
				moderoEnablePopupOnPage (dvTpTableMain, POPUP_NAME_MEETING_ENDING_WITH_EXTEND_OPTION, PAGE_NAME_MAIN_USER)
			}
			else	// there is at least one meeting booked after this current meeting
			{
				// check if there is enough time to extend the meeting for another 5 minutes
				if (getDifferenceInMinutesIgnoreSeconds(rmsSchedule.currentMeetingEndTime, rmsSchedule.nextMeetingStartTime) > minutesToExtendBooking) // enough time
				{
					// deactivate the source selection drag areas
					disableDragItemsAll (vdvDragAndDropTpTable)
					moderoEnablePopupOnPage (dvTpTableMain, POPUP_NAME_MEETING_ENDING_WITH_EXTEND_OPTION, PAGE_NAME_MAIN_USER)
				}
				else // not enough time
				{
					// deactivate the source selection drag areas
					disableDragItemsAll (vdvDragAndDropTpTable)
					moderoEnablePopupOnPage (dvTpTableMain, POPUP_NAME_MEETING_ENDING_NO_EXTEND_OPTION, PAGE_NAME_MAIN_USER)
				}
			}
			moderoPlaySoundFile (dvTpTableMain,soundFileNotifyUserOfMessage)
		}
	}
	
	updateSchedulingPanelToShowCorrectBookingOption ()
}

(***********************************************************)
(* Name:  RmsEventSchedulingNextActiveUpdated              *)
(* Args:                                                   *)
(* CHAR bookingId[] - The booking ID string                *)
(*                                                         *)
(* RmsEventBookingResponse eventBookingResponse - A        *)
(* structure with additional booking information           *)
(*                                                         *)
(* Desc:  Implementations of this method will be called    *)
(* when RMS indicates there was an update to a next active *)
(* booking event                                           *)
(*                                                         *)
(***********************************************************)
#DEFINE INCLUDE_SCHEDULING_NEXT_ACTIVE_UPDATED_CALLBACK
DEFINE_FUNCTION RmsEventSchedulingNextActiveUpdated(CHAR bookingId[], 
													RmsEventBookingResponse eventBookingResponse)
{
	debugPrint ("'******************** FUNCTION - RmsEventSchedulingNextActiveUpdated(...)'")
	debugPrint ("'bookingId = ',bookingId")
	debugPrintRmsEventBookingResponse (eventBookingResponse)
	debugPrint ("'******************************** END FUNCTION ********************************'")
	
	
	updateNextMeetingInfo (eventBookingResponse)
	
	if (rmsSchedule.bookingIdCurrentMeeting == '')	// not in a meeting currently
	{
		showNextMeetingInfoCardOnWelcomePanel ()
		showNextMeetingInfoOnTableSplashScreen ()
	}
	else if (userShutdownSystemToEndMeeting == true)
	{
		showNextMeetingInfoCardOnWelcomePanel ()
		showNextMeetingInfoOnTableSplashScreen ()
	}
	
	updateSchedulingPanelToShowCorrectBookingOption ()
	
}

(***********************************************************)
(* Name:  RmsEventSchedulingEventEnded                     *)
(* Args:                                                   *)
(* CHAR bookingId[] - The booking ID string                *)
(*                                                         *)
(* RmsEventBookingResponse eventBookingResponse - A        *)
(* structure with additional booking information           *)
(*                                                         *)
(* Desc:  Implementations of this method will be called    *)
(* when RMS indicates a booking event has ended            *)
(*                                                         *)
(***********************************************************)
#DEFINE INCLUDE_SCHEDULING_EVENT_ENDED_CALLBACK
DEFINE_FUNCTION RmsEventSchedulingEventEnded(CHAR bookingId[], 
											 RmsEventBookingResponse eventBookingResponse)
{
	debugPrint ("'******************** FUNCTION - RmsEventSchedulingEventEnded(...)'")
	debugPrint ("'bookingId = ',bookingId")
	debugPrintRmsEventBookingResponse (eventBookingResponse)
	debugPrint ("'******************************** END FUNCTION ********************************'")
	
	
	clearCurrentMeetingInfo ()
	
	meetingEnded()
	
	
	if (rmsSchedule.bookingIdNextMeeting != '')
		showNextMeetingInfoCardOnWelcomePanel ()
	else
		hideMeetingInfoCardOnWelcomePanel()
	
	updateSchedulingPanelToShowCorrectBookingOption ()
}

(***********************************************************)
(* Name:  RmsEventSchedulingEventStarted                   *)
(* Args:                                                   *)
(* CHAR bookingId[] - The booking ID string                *)
(*                                                         *)
(* RmsEventBookingResponse eventBookingResponse - A        *)
(* structure with additional booking information           *)
(*                                                         *)
(* Desc:  Implementations of this method will be called    *)
(* when RMS indicates a booking event has started          *)
(*                                                         *)
(***********************************************************)
#DEFINE INCLUDE_SCHEDULING_EVENT_STARTED_CALLBACK
DEFINE_FUNCTION RmsEventSchedulingEventStarted(CHAR bookingId[], 
											   RmsEventBookingResponse eventBookingResponse)
{
	debugPrint ("'******************** FUNCTION - RmsEventSchedulingEventStarted(...)'")
	debugPrint ("'bookingId = ',bookingId")
	debugPrintRmsEventBookingResponse (eventBookingResponse)
	debugPrint ("'******************************** END FUNCTION ********************************'")
	
	
	updateCurrentMeetingInfo (eventBookingResponse)
	
	
	// a bit of clean up.
	// Because we are sometimes copying the created booking info the next booking fields it's possible that the next booking info stored won't have a booking ID yet.
	// In that case, just compare the start date/time.
	if ( (eventBookingResponse.bookingId == rmsSchedule.bookingIdNextMeeting) or 
	   ( (eventBookingResponse.startDate == rmsSchedule.nextMeetingStartDate) and (eventBookingResponse.startTime == rmsSchedule.nextMeetingStartTime) ) )
	{
		clearNextMeetingInfo ()
	}
	
	meetingStarted()
	
	showCurrentMeetingInfoCardOnWelcomePanel ()
	
	updateSchedulingPanelToShowCorrectBookingOption ()
}

define_function debugPrintRmsEventBookingResponse (RmsEventBookingResponse eventBookingResponse)
{
	debugPrint ("'eventBookingResponse.bookingId = ',eventBookingResponse.bookingId")
	debugPrint ("'eventBookingResponse.location = ',itoa(eventBookingResponse.location)")
	debugPrint ("'eventBookingResponse.isPrivateEvent = ',itoa(eventBookingResponse.isPrivateEvent)")
	debugPrint ("'eventBookingResponse.startDate = ',eventBookingResponse.startDate")
	debugPrint ("'eventBookingResponse.startTime = ',eventBookingResponse.startTime")
	debugPrint ("'eventBookingResponse.endDate = ',eventBookingResponse.endDate")
	debugPrint ("'eventBookingResponse.endTime = ',eventBookingResponse.endTime")
	debugPrint ("'eventBookingResponse.subject = ',eventBookingResponse.subject")
	debugPrint ("'eventBookingResponse.details = ',eventBookingResponse.details")
	debugPrint ("'eventBookingResponse.clientGatewayUid = ',eventBookingResponse.clientGatewayUid")
	debugPrint ("'eventBookingResponse.isAllDayEvent = ',itoa(eventBookingResponse.isAllDayEvent)")
	debugPrint ("'eventBookingResponse.organizer = ',eventBookingResponse.organizer")
	debugPrint ("'eventBookingResponse.elapsedMinutes = ',itoa(eventBookingResponse.elapsedMinutes)")
	debugPrint ("'eventBookingResponse.minutesUntilStart = ',itoa(eventBookingResponse.minutesUntilStart)")
	debugPrint ("'eventBookingResponse.remainingMinutes = ',itoa(eventBookingResponse.remainingMinutes)")
	debugPrint ("'eventBookingResponse.onBehalfOf = ',eventBookingResponse.onBehalfOf")
	debugPrint ("'eventBookingResponse.attendees = ',eventBookingResponse.attendees")
	debugPrint ("'eventBookingResponse.isSuccessful = ',itoa(eventBookingResponse.isSuccessful)")
	debugPrint ("'eventBookingResponse.failureDescription = ',eventBookingResponse.failureDescription")
	debugPrint ("'eventBookingResponse.totalAttendeeCount = ',itoa(eventBookingResponse.totalAttendeeCount)")
}


define_function updateSchedulingPanelToShowCorrectBookingOption ()
{
	if (waitingForAdhocBookingResponse == false)
	{
		select
		{
			// NO ACTIVE MEETING IN SESSION - NO MEETINGS SCHEDULED FOR LATER TODAY
			active ((rmsSchedule.bookingIdCurrentMeeting == '') and (rmsSchedule.bookingIdNextMeeting == '')):
			{
				if ( (schedulingPanelInUse = false) or ((schedulingPanelInUse == true) and (schedulingPanelShowingBookingSucceededMessageWhileInUse == false)) )
				{
					moderoEnablePopupOnPage (dvTpSchedulingMain, popupBookNow, pageWelcomePanelUnlocked)
				}
				else
				{
					cancel_wait  'WAITING FOR USER TO GO AWAY FROM SCHEDULING PANEL'
					wait_until (schedulingPanelInUse = false)  'WAITING FOR USER TO GO AWAY FROM SCHEDULING PANEL'
					{
						moderoEnablePopupOnPage (dvTpSchedulingMain, popupBookNow, pageWelcomePanelUnlocked)
						schedulingPanelShowingSelectBookingDurationMessage = false
					}
				}
			}
			
			
			
			// ACTIVE MEETING IN SESSION - MEETING SCHEDULED FOR LATER TODAY
			active ((rmsSchedule.bookingIdCurrentMeeting == '') and (rmsSchedule.bookingIdNextMeeting != '')):
			{
				if (rmsSchedule.nextMeetingMinutesUntilStart <= bookingTime)	// not enough time to squeeze in a meeting between now and the next scheduled meeting
				{
					if ( (schedulingPanelInUse = false) or ((schedulingPanelInUse == true) and (schedulingPanelShowingBookingSucceededMessageWhileInUse == false)) )
					{
						moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_BOOKING_MSG, MODERO_BUTTON_STATE_ALL, "'Next meeting will begin in ', getFuzzyTimeString(rmsSchedule.nextMeetingMinutesUntilStart)")
						
						moderoDisablePopupOnPage (dvTpSchedulingMain, popupBookNext, pageWelcomePanelUnlocked)	// this will hide all popups in the same group as nfcBookNext
						moderoDisablePopupOnPage (dvTpSchedulingMain, popupBookingSuccessful, pageWelcomePanelUnlocked)	// this will hide all popups in the same group as nfcBookNext
					}
					else
					{
						cancel_wait  'WAITING FOR USER TO GO AWAY FROM SCHEDULING PANEL'
						wait_until (schedulingPanelInUse = false)  'WAITING FOR USER TO GO AWAY FROM SCHEDULING PANEL'
						{
							moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_BOOKING_MSG, MODERO_BUTTON_STATE_ALL, "'Next meeting will begin in ', getFuzzyTimeString(rmsSchedule.nextMeetingMinutesUntilStart)")
							
							moderoDisablePopupOnPage (dvTpSchedulingMain, popupBookNext, pageWelcomePanelUnlocked)	// this will hide all popups in the same group as nfcBookNext
							moderoDisablePopupOnPage (dvTpSchedulingMain, popupBookingSuccessful, pageWelcomePanelUnlocked)	// this will hide all popups in the same group as nfcBookNext
						}
					}
				}
				else	// there's enough time to sqeeze in a meeting between now and the next scheduled meeting
				{
					if ( (schedulingPanelInUse = false) or ((schedulingPanelInUse == true) and (schedulingPanelShowingBookingSucceededMessageWhileInUse == false)) )
					{
						moderoEnablePopupOnPage (dvTpSchedulingMain, popupBookNow, pageWelcomePanelUnlocked)
					}
					else
					{
						cancel_wait  'WAITING FOR USER TO GO AWAY FROM SCHEDULING PANEL'
						wait_until ( schedulingPanelInUse = false )  'WAITING FOR USER TO GO AWAY FROM SCHEDULING PANEL'
						{
							moderoEnablePopupOnPage (dvTpSchedulingMain, popupBookNow, pageWelcomePanelUnlocked)
						}
					}
				}
			}
			
			
			
			// ACTIVE MEETING IN SESSION - NO MEETINGS SCHEDULED FOR LATER TODAY
			active ((rmsSchedule.bookingIdCurrentMeeting != '') and (rmsSchedule.bookingIdNextMeeting == '')):
			{
				if ( (schedulingPanelInUse = false) or ((schedulingPanelInUse == true) and (schedulingPanelShowingBookingSucceededMessageWhileInUse == false)) )
				{
					moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_NEXT_MEETING_START_TIME, MODERO_BUTTON_STATE_ALL, getTimeString12HourFormatAmPm(rmsSchedule.currentMeetingEndTime))
					moderoEnablePopupOnPage (dvTpSchedulingMain, popupBookNext, pageWelcomePanelUnlocked)
				}
				else
				{
					cancel_wait  'WAITING FOR USER TO GO AWAY FROM SCHEDULING PANEL'
					wait_until (schedulingPanelInUse = false) 'WAITING FOR USER TO GO AWAY FROM SCHEDULING PANEL'
					{
						moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_NEXT_MEETING_START_TIME, MODERO_BUTTON_STATE_ALL, getTimeString12HourFormatAmPm(rmsSchedule.currentMeetingEndTime))
						moderoEnablePopupOnPage (dvTpSchedulingMain, popupBookNext, pageWelcomePanelUnlocked)
					}
				}
			}
			
			
			
			// ACTIVE MEETING IN SESSION - MEETING SCHEDULED FOR LATER TODAY
			active ((rmsSchedule.bookingIdCurrentMeeting != '') and (rmsSchedule.bookingIdNextMeeting != '')):
			{
				if (rmsSchedule.nextMeetingMinutesUntilStart <= (rmsSchedule.currentMeetingRemainingMinutes + bookingTime))	// not enough time to squeeze in a meeting between the current meeting and the next scheduled meeting
				{
					if ( (schedulingPanelInUse = false) or ((schedulingPanelInUse == true) and (schedulingPanelShowingBookingSucceededMessageWhileInUse == false)) )
					{
						moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_BOOKING_MSG, MODERO_BUTTON_STATE_ALL, "'Room in use and next session booked'")
						
						moderoDisablePopupOnPage (dvTpSchedulingMain, popupBookNext, pageWelcomePanelUnlocked)	// this will hide all popups in the same group as nfcBookNext
						moderoDisablePopupOnPage (dvTpSchedulingMain, popupBookingSuccessful, pageWelcomePanelUnlocked)	// this will hide all popups in the same group as nfcBookNext
					}
					else
					{
						cancel_wait  'WAITING FOR USER TO GO AWAY FROM SCHEDULING PANEL'
						wait_until ( schedulingPanelInUse = false ) 'WAITING FOR USER TO GO AWAY FROM SCHEDULING PANEL'
						{
							moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_BOOKING_MSG, MODERO_BUTTON_STATE_ALL, "'Room in use and next session booked'")
							
							moderoDisablePopupOnPage (dvTpSchedulingMain, popupBookNext, pageWelcomePanelUnlocked)	// this will hide all popups in the same group as nfcBookNext
							moderoDisablePopupOnPage (dvTpSchedulingMain, popupBookingSuccessful, pageWelcomePanelUnlocked)	// this will hide all popups in the same group as nfcBookNext
						}
					}
				}
				else	// there's enough time to sqeeze in a meeting between the current meeting and the next scheduled meeting
				{
					if ( (schedulingPanelInUse = false) or ((schedulingPanelInUse == true) and (schedulingPanelShowingBookingSucceededMessageWhileInUse == false)) )
					{
						moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_NEXT_MEETING_START_TIME, MODERO_BUTTON_STATE_ALL, getTimeString12HourFormatAmPm(rmsSchedule.currentMeetingEndTime))
						moderoEnablePopupOnPage (dvTpSchedulingMain, popupBookNext, pageWelcomePanelUnlocked)
					}
					else
					{
						cancel_wait  'WAITING FOR USER TO GO AWAY FROM SCHEDULING PANEL'
						wait_until ( schedulingPanelInUse = false ) 'WAITING FOR USER TO GO AWAY FROM SCHEDULING PANEL'
						{
							moderoSetButtonText (dvTpSchedulingRmsCustom, BTN_ADR_SCHEDULING_NEXT_MEETING_START_TIME, MODERO_BUTTON_STATE_ALL, getTimeString12HourFormatAmPm(rmsSchedule.currentMeetingEndTime))
							moderoEnablePopupOnPage (dvTpSchedulingMain, popupBookNext, pageWelcomePanelUnlocked)
						}
					}
				}
			}
		}
	}
}



#end_if