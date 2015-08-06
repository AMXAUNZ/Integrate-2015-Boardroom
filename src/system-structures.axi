PROGRAM_NAME='system-structures'



#if_not_defined __SYSTEM_STRUCTURES__
#define __SYSTEM_STRUCTURES__


define_type

structure _user
{
	char name[50]
	char email[100]
	char nfcTag[50]
	char photo[50]
}

structure _area
{
	integer left
	integer top
	integer width
	integer height
}


structure _rms_schedule
{
	long locationId
	char locationName[250]
	char locationAdditionalParameters[250]
	
	long locationIdNonDefault
	char  locationNameNonDefault[250]
	char locationAdditionalParametersNonDefault[250]
	
	char bookingIdCurrentMeeting[250]	// null value '' means no current meeting
	char bookingIdNextMeeting[250]		// null value '' means no next meeting
	char bookingIdMeetingJustEnded[250]	// null value '' means no meeting previous
	
	char currentMeetingOrganizerNfcUid[30]
	char currentMeetingOrganizerName[250]
	long currentMeetingRemainingMinutes
	long currentMeetingElapsedMinutes
	char currentMeetingStartTime[10]
	char currentMeetingEndTime[10]
	char currentMeetingStartDate[10]
	char currentMeetingEndDate[10]
    char currentMeetingSubject[250]
    char currentMeetingDetails[250]
	
	
	char nextMeetingOrganizerNfcUid[30]
	char nextMeetingOrganizerName[250]
	long nextMeetingMinutesUntilStart
	char nextMeetingStartTime[10]
	char nextMeetingEndTime[10]
	char nextMeetingStartDate[10]
	char nextMeetingEndDate[10]
    char nextMeetingSubject[250]
    char nextMeetingDetails[250]
}




#end_if