PROGRAM_NAME='system-start'

#if_not_defined __SYSTEM_START__
#define __SYSTEM_START__

#include 'system-devices'
#include 'system-structures'
#include 'system-constants'
#include 'system-variables'
#include 'system-functions'
#include 'system-library-api'
#include 'system-library-control'
#include 'system-rms-api'

/*
 * --------------------
 * Startup code
 * --------------------
 */
define_start


rmsSchedule.locationId = 64


initArea (dropAreasTpTable[dvDvxVidOutMonitorLeft.port], 438, 164, 320, 180)
initArea (dropAreasTpTable[dvDvxVidOutMonitorRight.port], 1163, 164, 320, 180)
initArea (dropAreasTpTable[dvDvxVidOutMultiPreview.port], 771, 164, 379, 180)

initArea (dragAreasTpTable[dvDvxVidInEnzo.port], 658, 376, 134, 105)
initArea (dragAreasTpTable[dvDvxVidInAppleTv.port], 815, 376, 134, 105)
initArea (dragAreasTpTable[dvDvxVidInTx3.port], 972,376, 134, 105)
initArea (dragAreasTpTable[dvDvxVidInTx4.port], 1129,376, 134, 105)


{
    stack_var integer i
    
    i = 1
    
    for (i = 1; i <= DVX_MAX_VIDEO_INPUTS; i++)
    {
	draggablePopupsTpTable[i] = "'draggable-source-',itoa(i)"
    }
}


// rebuild the event table after setting the variable device and channel code array values
//rebuild_event()   // not needed unless assigning values to dev or dev array variables during runtime


#end_if