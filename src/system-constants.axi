PROGRAM_NAME='system-constants'

#if_not_defined __SYSTEM_CONSTANTS__
#define __SYSTEM_CONSTANTS__


/*
 * --------------------
 * Constant definitions
 * --------------------
 */
 
define_constant

/*
 * --------------------
 * Drag and drop panel button channel/address/level codes
 * --------------------
 */


// Drag Items

// Drop Items
integer BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_LEFT  = 61
integer BTN_DROP_AREA_TP_TABLE_HIGHLIGHT_MONITOR_RIGHT = 62



/*
 * --------------------
 * Keypad button channel/address/level codes
 * --------------------
 */

// channel codes
integer BTN_KP_OFF              = 1
integer BTN_KP_LIGHTS           = 2
integer BTN_KP_BLOCKOUTS        = 3
integer BTN_KP_SHADES           = 4
integer BTN_KP_AV_OFF           = 5
integer BTN_KP_WHITEBOARD       = 6
integer BTN_KP_CURSOR_UP        = 7
integer BTN_KP_CURSOR_DN        = 8
integer BTN_KP_CURSOR_LT        = 9
integer BTN_KP_CURSOR_RT        = 10
integer BTN_KP_ENTER            = 11
integer BTN_KP_WHEEL_ROTATE_LT  = 12
integer BTN_KP_WHEEL_ROTATE_RT  = 13
// level codes
integer nLVL_KP_JOG_WHEEL       = 1


/*
 * --------------------
 * Scheduling touch panel button channel/address/level codes
 * --------------------
 */


integer BTN_SCHEDULING_AVAILABLE_FB = 1300	// on port 9

integer BTN_ADR_SCHEDULING_BOOKING_MSG = 31

integer BTN_SCHEDULING_USER_LOG_OUT = 10
integer BTN_ADR_SCHEDULING_USER_WELCOME_MESSAGE = 11
integer BTN_SCHEDULING_USER_PHOTO = 12
integer BTN_ADR_SCHEDULING_USER_PHOTO = 12
integer BTN_SCHEDULING_MAKE_RESERVATION = 212	// for overriding default behaviour of RmsGui

integer BTN_ADR_SCHEDULING_MEETING_CARD_INFO_SUBJECT = 1
integer BTN_ADR_SCHEDULING_MEETING_CARD_INFO_ORGANIZER = 2
integer BTN_ADR_SCHEDULING_MEETING_CARD_INFO_START_TIME = 3
integer BTN_ADR_SCHEDULING_MEETING_CARD_INFO_TIME_REMAINING = 4
integer BTN_ADR_SCHEDULING_MEETING_CARD_INFO_DESCRIPTION = 5
integer BTN_ADR_SCHEDULING_MEETING_CARD_INFO_CARD_HEADER = 6

integer BTN_ADR_SCHEDULING_NEXT_MEETING_START_TIME = 13

/*
 * --------------------
 * Table touch panel button RMS channel/address/level codes
 * --------------------
 */


integer BTN_ADR_TABLE_PANEL_USER_PHOTO = 12
integer BTN_ADR_TABLE_PANEL_USER_PHOTO_BACKGROUND = 13
integer BTN_ADR_TABLE_PANEL_TAP_ON_INDICATOR = 15
integer BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_1 = 16
integer BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_2 = 17
integer BTN_ADR_TABLE_PANEL_RESERVATION_MESSAGE_3 = 18
integer BTN_ADR_TABLE_PANEL_MEETING_END_TIME = 19
integer BTN_ADR_TABLE_PANEL_MEETING_TIME_REMAINING = 21
integer BTN_TABLE_PANEL_EXTEND_MEETING = 20



/*
 * --------------------
 * Touch panel button channel/address/level codes
 * --------------------
 */

// Main System
integer BTN_MAIN_SHUT_DOWN  = 1
integer BTN_MAIN_SPLASH_SCREEN = 2

// Debug
integer BTN_DEBUG_REBUILD_EVENT_TABLE   = 1
integer BTN_DEBUG_WAKE_ON_LAN_PC        = 2

// Lighting Control
integer BTN_LIGHTING_PRESET_ALL_OFF         = 1
integer BTN_LIGHTING_PRESET_ALL_ON          = 2
integer BTN_LIGHTING_PRESET_ALL_DIM         = 3
integer BTN_LIGHTING_PRESET_VC_MODE         = 4
integer BTN_LIGHTING_AREA_WHITEBOARD_ON     = 5
integer BTN_LIGHTING_AREA_WHITEBOARD_OFF    = 6
integer BTN_LIGHTING_AREA_FRONT_UP          = 7
integer BTN_LIGHTING_AREA_FRONT_DN          = 8
integer BTN_LIGHTING_AREA_SIDE_AND_BACK_UP  = 9
integer BTN_LIGHTING_AREA_SIDE_AND_BACK_DN  = 10
integer BTN_LIGHTING_AREA_TABLE_UP          = 11
integer BTN_LIGHTING_AREA_TABLE_DN          = 12

// Enzo Control
integer BTN_ENZO_HOME = 1
integer BTN_ENZO_ENTER = 2	// aka "Select"
integer BTN_ENZO_CLOSE_OPEN_APP = 3
integer BTN_ENZO_START_SESSION = 4
integer BTN_ENZO_END_SESSION = 5
integer BTN_ENZO_UP = 6
integer BTN_ENZO_DOWN = 7
integer BTN_ENZO_LEFT = 8
integer BTN_ENZO_RIGHT = 9
integer BTN_ENZO_LAUNCH_APP_WEB_BROWSER = 21
integer BTN_ENZO_LAUNCH_APP_DROPBOX     = 22
integer BTN_ENZO_LAUNCH_APP_MIRROR_OP   = 23
integer BTN_ENZO_PLAY = 24
integer BTN_ENZO_PAUSE = 25
integer BTN_ENZO_STOP = 26
integer BTN_ENZO_FFWD = 27
integer BTN_ENZO_REWIND = 28
integer BTN_ENZO_BACK = 29
integer BTN_ENZO_PAGE_UP = 30
integer BTN_ENZO_PAGE_DOWN = 31
integer BTN_ENZO_PREVIOUS = 32
integer BTN_ENZO_NEXT = 33

// Apple TV Control
integer BTN_APPLE_TV_PLAY_PAUSE = 1
integer BTN_APPLE_TV_MENU       = 2
integer BTN_APPLE_TV_SELECT     = 3
integer BTN_APPLE_TV_UP         = 4
integer BTN_APPLE_TV_DOWN       = 5
integer BTN_APPLE_TV_LEFT       = 6
integer BTN_APPLE_TV_RIGHT      = 7

// Video Control
INTEGER BTN_ADR_VIDEO_PREVIEW_VIDEO = 200
INTEGER BTN_ADR_VIDEO_MONITOR_LEFT_PREVIEW_SNAPSHOT = 201
INTEGER BTN_ADR_VIDEO_MONITOR_RIGHT_PREVIEW_SNAPSHOT = 202
INTEGER BTN_ADR_VIDEO_MONITOR_LEFT_PREVIEW_LABEL = 203//201	// using same button as snapshot
INTEGER BTN_ADR_VIDEO_MONITOR_RIGHT_PREVIEW_LABEL = 204//202	// using same button as snapshot


integer BTN_VIDEO_MONITOR_LEFT_OFF          = 1
integer BTN_VIDEO_MONITOR_LEFT_ON           = 2
integer BTN_VIDEO_MONITOR_RIGHT_OFF         = 3
integer BTN_VIDEO_MONITOR_RIGHT_ON          = 4


integer BTN_VIDEO_QUERY_LYNC_CALL_YES   = 31
integer BTN_VIDEO_QUERY_LYNC_CALL_NO    = 32
integer BTN_VIDEO_LYNC_MONITOR_LEFT     = 33
integer BTN_VIDEO_LYNC_MONITOR_RIGHT    = 34
// Address Codes
integer BTN_ADR_VIDEO_LOADING_PREVIEW           = 30
integer BTN_ADR_VIDEO_PREVIEW_WINDOW            = 31
integer BTN_VIDEO_PREVIEW_LOADING_BAR           = 32
integer BTN_ADR_VIDEO_PREVIEW_LOADING_BAR       = 32

integer BTN_USER_ACKNOWLEDGE_SEND_INPUT_NO_SIGNAL_TO_MONITOR_NO = 35
integer BTN_USER_ACKNOWLEDGE_SEND_INPUT_NO_SIGNAL_TO_MONITOR_YES = 36


// Audio Control
integer BTN_AUDIO_VOLUME_UP             = 1
integer BTN_AUDIO_VOLUME_DN             = 2
integer BTN_AUDIO_VOLUME_MUTE           = 3
integer BTN_AUDIO_INPUT_01              = 10
integer BTN_AUDIO_INPUT_02              = 11
integer BTN_AUDIO_INPUT_03              = 12
integer BTN_AUDIO_INPUT_04              = 13
integer BTN_AUDIO_INPUT_05              = 14
integer BTN_AUDIO_INPUT_06              = 15
integer BTN_AUDIO_INPUT_07              = 16
integer BTN_AUDIO_INPUT_08              = 17
integer BTN_AUDIO_INPUT_09              = 18
integer BTN_AUDIO_INPUT_10              = 19
integer BTN_AUDIO_FOLLOW_MONITOR_LEFT   = 20
integer BTN_AUDIO_FOLLOW_MONITOR_RIGHT  = 21
// Levels
integer BTN_LVL_VOLUME_CONTROL          = 31    // bargraph which user controls (invisible to user - overlayed over the display bargraph)
integer BTN_LVL_VOLUME_DISPLAY          = 32    // bargraph which displays the DVX's current volume
// Address codes
integer BTN_ADR_VOLUME_BARGRAPH_CONTROL = 31
integer BTN_ADR_VOLUME_BARGRAPH_DISPLAY = 32


// Power/Energy Control & Monitoring
integer BTN_POWER_TOGGLE_MONITOR_LEFT   = 1
integer BTN_POWER_TOGGLE_MONITOR_RIGHT  = 2
integer BTN_POWER_TOGGLE_PDXL2          = 3
integer BTN_POWER_TOGGLE_MULTI_PREVIEW  = 4
integer BTN_POWER_TOGGLE_PC             = 5
integer BTN_POWER_TOGGLE_DVX            = 6
integer BTN_POWER_TOGGLE_FAN_1          = 7
integer BTN_POWER_TOGGLE_FAN_2          = 8
integer BTNS_POWER_CONTROL[]            = {1,2,3,4,5,6,7,8}
// address codes
integer BTNS_ADR_POWER_CURRENT_DRAW[]   = {51,52,53,54,55,56,57,58}
integer BTNS_ADR_POWER_CONSUMPTION[]    = {61,62,63,64,65,66,67,68}
integer BTNS_ADR_POWER_ENERGY_USAGE[]   = {71,72,73,74,75,76,77,78}
integer BTN_ADR_POWER_INPUT_VOLTAGE[]   = 80
integer BTN_ADR_POWER_AXLINK_VOLTAGE[]  = 81
integer BTN_ADR_POWER_TEMPERATURE[]     = 82
integer BTN_ADR_POWER_OUTLET_LABEL_1    = 11
integer BTN_ADR_POWER_OUTLET_LABEL_2    = 12
integer BTN_ADR_POWER_OUTLET_LABEL_3    = 13
integer BTN_ADR_POWER_OUTLET_LABEL_4    = 14
integer BTN_ADR_POWER_OUTLET_LABEL_5    = 15
integer BTN_ADR_POWER_OUTLET_LABEL_6    = 16
integer BTN_ADR_POWER_OUTLET_LABEL_7    = 17
integer BTN_ADR_POWER_OUTLET_LABEL_8    = 18
integer BTNS_ADR_POWER_OUTLET_LABELS[]  = {11,12,13,14,15,16,17,18}
integer BTN_ADR_POWER_RELAY_STATUS_1    = 21
integer BTN_ADR_POWER_RELAY_STATUS_2    = 22
integer BTN_ADR_POWER_RELAY_STATUS_3    = 23
integer BTN_ADR_POWER_RELAY_STATUS_4    = 24
integer BTN_ADR_POWER_RELAY_STATUS_5    = 25
integer BTN_ADR_POWER_RELAY_STATUS_6    = 26
integer BTN_ADR_POWER_RELAY_STATUS_7    = 27
integer BTN_ADR_POWER_RELAY_STATUS_8    = 28
integer BTNS_ADR_POWER_RELAY_STATUS[]   = {21,22,23,24,25,26,27,28}
integer BTN_ADR_POWER_SENSE_STATUS_1    = 31
integer BTN_ADR_POWER_SENSE_STATUS_2    = 32
integer BTN_ADR_POWER_SENSE_STATUS_3    = 33
integer BTN_ADR_POWER_SENSE_STATUS_4    = 34
integer BTN_ADR_POWER_SENSE_STATUS_5    = 35
integer BTN_ADR_POWER_SENSE_STATUS_6    = 36
integer BTN_ADR_POWER_SENSE_STATUS_7    = 37
integer BTN_ADR_POWER_SENSE_STATUS_8    = 38
integer BTNS_ADR_POWER_SENSE_STATUS[]   = {31,32,33,34,35,36,37,38}
integer BTN_ADR_POWER_SENSE_TRIGGER_1   = 41
integer BTN_ADR_POWER_SENSE_TRIGGER_2   = 42
integer BTN_ADR_POWER_SENSE_TRIGGER_3   = 43
integer BTN_ADR_POWER_SENSE_TRIGGER_4   = 44
integer BTN_ADR_POWER_SENSE_TRIGGER_5   = 45
integer BTN_ADR_POWER_SENSE_TRIGGER_6   = 46
integer BTN_ADR_POWER_SENSE_TRIGGER_7   = 47
integer BTN_ADR_POWER_SENSE_TRIGGER_8   = 48
integer BTNS_ADR_POWER_SENSE_TRIGGER[]  = {41,42,43,44,45,46,47,48}
//integer BTNS_ADR_POWER_CURRENT_DRAW
integer BTN_ADR_POWER_OUTLET_LABEL_MONITOR_LEFT = BTN_ADR_POWER_OUTLET_LABEL_1

integer BTN_POWER_TEMPERATURE_SCALE_TOGGLE      = 100
integer BTN_POWER_TEMPERATURE_SCALE_CELCIUS     = 101
integer BTN_POWER_TEMPERATURE_SCALE_FAHRENHEIT  = 102


// Blinds & Shades Control
integer BTN_BLIND_1_UP      = 1
integer BTN_BLIND_1_DOWN    = 2
integer BTN_BLIND_1_STOP    = 3
integer BTN_BLIND_2_UP      = 4
integer BTN_BLIND_2_DOWN    = 5
integer BTN_BLIND_2_STOP    = 6
integer BTN_SHADE_1_UP      = 7
integer BTN_SHADE_1_DOWN    = 8
integer BTN_SHADE_1_STOP    = 9
integer BTN_SHADE_2_UP      = 10
integer BTN_SHADE_2_DOWN    = 11
integer BTN_SHADE_2_STOP    = 12


// Camera Control
integer BTN_CAMERA_ZOOM_IN      = 1
integer BTN_CAMERA_ZOOM_OUT     = 2
integer BTN_CAMERA_TILT_UP      = 3
integer BTN_CAMERA_TILT_DOWN    = 4
integer BTN_CAMERA_PAN_LEFT     = 5
integer BTN_CAMERA_PAN_RIGHT    = 6
integer BTN_CAMERA_FOCUS_NEAR   = 7
integer BTN_CAMERA_FOCUS_FAR    = 8
integer BTN_CAMERA_PRESET_1     = 11
integer BTN_CAMERA_PRESET_2     = 12
integer BTN_CAMERA_PRESET_3     = 13


// DXLink Control
integer BTN_DXLINK_TX_AUTO_1                            = 1
integer BTN_DXLINK_TX_AUTO_2                            = 2
integer BTN_DXLINK_TX_AUTO_3                            = 3
integer BTN_DXLINK_TX_AUTO_4                            = 4
integer BTN_DXLINK_TX_HDMI_1                            = 5
integer BTN_DXLINK_TX_HDMI_2                            = 6
integer BTN_DXLINK_TX_HDMI_3                            = 7
integer BTN_DXLINK_TX_HDMI_4                            = 8
integer BTN_DXLINK_TX_VGA_1                             = 9
integer BTN_DXLINK_TX_VGA_2                             = 10
integer BTN_DXLINK_TX_VGA_3                             = 11
integer BTN_DXLINK_TX_VGA_4                             = 12
integer BTN_DXLINK_RX_SCALER_AUTO_MONITOR_LEFT          = 13
integer BTN_DXLINK_RX_SCALER_AUTO_MONITOR_RIGHT         = 14
integer BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_LEFT        = 15
integer BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_RIGHT       = 16
integer BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_LEFT        = 17
integer BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_RIGHT       = 18
integer BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_LEFT      = 19
integer BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_RIGHT     = 20
integer BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_LEFT       = 21
integer BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_RIGHT      = 22
integer BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_LEFT          = 23
integer BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_RIGHT         = 24
integer BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_LEFT    = 25
integer BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_RIGHT   = 26
// Address codes
integer BTN_ADR_DXLINK_TX_INPUT_RESOLUTION_1                = 31
integer BTN_ADR_DXLINK_TX_INPUT_RESOLUTION_2                = 32
integer BTN_ADR_DXLINK_TX_INPUT_RESOLUTION_3                = 33
integer BTN_ADR_DXLINK_TX_INPUT_RESOLUTION_4                = 34
integer BTN_ADR_DXLINK_RX_OUTPUT_RESOLUTION_MONITOR_LEFT    = 35
integer BTN_ADR_DXLINK_RX_OUTPUT_RESOLUTION_MONITOR_RIGHT   = 36


// Device Info
// Channel Codes
integer BTN_DEV_INFO_ONLINE_MASTER                  = 1
integer BTN_DEV_INFO_ONLINE_CONTROLLER              = 2
integer BTN_DEV_INFO_ONLINE_SWITCHER                = 3
integer BTN_DEV_INFO_ONLINE_PDU                     = 4
integer BTN_DEV_INFO_ONLINE_PANEL_TABLE             = 5
integer BTN_DEV_INFO_ONLINE_DXLINK_TX_1             = 6
integer BTN_DEV_INFO_ONLINE_DXLINK_TX_2             = 7
integer BTN_DEV_INFO_ONLINE_DXLINK_TX_3             = 8
integer BTN_DEV_INFO_ONLINE_DXLINK_TX_4             = 9
integer BTN_DEV_INFO_ONLINE_DXLINK_RX_MONITOR_LEFT  = 10
integer BTN_DEV_INFO_ONLINE_DXLINK_RX_MONITOR_RIGHT = 11
// Address Codes
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_CONTROLLER  = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1
integer BTN_DEV_INFO_SERIAL_MASTER      = 1

// Occupancy Detection
integer BTN_OCCUPANCY_DETECTED  = 1


/*
 * --------------------
 * Relay channel codes
 * --------------------
 */

// Relay Channel codes for Relay Box relays
integer REL_BLOCKOUTS_CORNER_WINDOW_UP  = 1
integer REL_BLOCKOUTS_CORNER_WINDOW_DN  = 2

integer REL_SHADES_CORNER_WINDOW_UP = 3
integer REL_SHADES_CORNER_WINDOW_DN = 4

integer REL_BLOCKOUTS_WALL_WINDOW_UP    = 5
integer REL_BLOCKOUTS_WALL_WINDOW_DN    = 6

integer REL_SHADES_WALL_WINDOW_UP   = 7
integer REL_SHADES_WALL_WINDOW_DN   = 8

// Relay Channel codes for DVX relays
integer REL_DVX_BLOCKOUTS_CORNER_WINDOW_STOP    = 1
integer REL_DVX_SHADES_CORNER_WINDOW_STOP       = 2
integer REL_DVX_BLOCKOUTS_WALL_WINDOW_STOP      = 3
integer REL_DVX_SHADES_WALL_WINDOW_STOP         = 4



/*
 * --------------------
 * IR channel codes
 * --------------------
 */



integer IR_APPLE_TV_PLAY_PAUSE = 1
integer IR_APPLE_TV_SELECT     = 21
integer IR_APPLE_TV_UP         = 43
integer IR_APPLE_TV_DOWN       = 44
integer IR_APPLE_TV_RIGHT      = 45
integer IR_APPLE_TV_LEFT       = 46
integer IR_APPLE_TV_MENU       = 47


/*
 * --------------------
 * IO channel codes
 * --------------------
 */

// IO Channel Codes for Occupancy Sensor
integer IO_OCCUPANCY_SENSOR = 1


/*
 * --------------------
 * Lighting Addresses
 * --------------------
 */

char cLightAddressBoardroom[]		= '00:38:00'


/*
 * --------------------
 * PDU outlet labels
 * --------------------
 */

char LABELS_PDU_OUTLETS[][20]   =
{
	'L MON',
	'R MON',
	'PDXL2',
	'MPL',
	'PC',
	'DVX',
	'FAN 1',
	'FAN 2'
}


/*
 * --------------------
 * Page and popup page names
 * --------------------
 */

char POPUP_NAME_VIDEO_PREVIEW[]                 = 'popup-video-preview'
char POPUP_NAME_VIDEO_LOADING[]                 = 'popup-video-loading'
char POPUP_NAME_MESSAGE_QUERY_USER_LYNC_CALL[]  = 'popup-message-query-user-lync-call'
char PAGE_NAME_SPLASH_SCREEN[]                  = 'page-splash-screen'
char PAGE_NAME_MAIN_USER[]                      = 'page-main-user'
char POPUP_NAME_SOURCE_SELECTION[]              = 'popup-source-selection-drag-and-drop'
char POPUP_NAME_NO_SIGNAL_ARE_YOU_SURE[]        = 'popup-no-signal-are-you-sure'

char POPUP_NAME_SOURCE_CONTROL[]                = 'popup-source-control-background'

char POPUP_NAME_CONFIRM_SHUTDOWN[]              = 'popup-confirm-shutdown'

char POPUP_NAME_MEETING_ENDING_WITH_EXTEND_OPTION[]  = 'popup-meeting-ending-extend'
char POPUP_NAME_MEETING_ENDING_NO_EXTEND_OPTION[]    = 'popup-meeting-ending-no-extend' 
char POPUP_NAME_MEETING_EXTEND_REQUEST_IN_PROGRESS[] = 'popup-meeting-extend-requesting'
char POPUP_NAME_MEETING_EXTEND_SUCCESS[]             = 'popup-meeting-extend-success'
char POPUP_NAME_MEETING_EXTEND_FAILURE[]             = 'popup-meeting-extend-fail'



char POPUP_NAME_MEETING_INFO_CARD[]            = 'rmsMeetingInfoCard'
char POPUP_NAME_SELECT_DURATION_MEETING_NOW[]  = 'bookNowSelectDuration'
char POPUP_NAME_SELECT_DURATION_MEETING_NEXT[] = 'bookNextSelectDuration'

char PAGE_NAME_ROOM_STATUS[] = 'roomStatus'
char PAGE_NAME_RMS_SCHEDULING_CALENDAR[] = 'rmsSchedulingPage'

char POPUP_NAME_DRAGGABLE_SOURCES[][30] = 
{
	'draggable-source-1',
	'draggable-source-2',
	'draggable-source-3',
	'draggable-source-4',
	'draggable-source-5',
	'draggable-source-6',
	'draggable-source-7',
	'draggable-source-8',
	'draggable-source-9',
	'draggable-source-10'
}

char POPUP_NAME_SOURCE_CONTROL_BACKGROUNDS[][50] = 
{
	'popup-source-control-background-1',
	'popup-source-control-background-2',
	'popup-source-control-background-3',
	'popup-source-control-background-4',
	'popup-source-control-background-5',
	'popup-source-control-background-6',
	'popup-source-control-background-7',
	'popup-source-control-background-8',
	'popup-source-control-background-9',
	'popup-source-control-background-10'
}

char POPUP_NAME_SOURCE_CONTROL_ENZO[] = 'popup-source-control-enzo'
char POPUP_NAME_SOURCE_CONTROL_APPLE_TV[] = 'popup-source-control-apple-tv'
char POPUP_NAME_SOURCE_CONTROL_PC[] = 'popup-source-control-pc'
char POPUP_NAME_SOURCE_CONTROL_BLURAY_MENU[] = 'popup-source-control-bluray-menu'
char POPUP_NAME_SOURCE_CONTROL_BLURAY_NAVIGATION[] = 'popup-source-control-bluray-navigation'
char POPUP_NAME_SOURCE_CONTROL_BLURAY_TV_KEYPAD[] = 'popup-source-control-tv-keypad'
char POPUP_NAME_SOURCE_CONTROL_BLURAY_TV_MENU[] = 'popup-source-control-tv-menu'
char POPUP_NAME_SOURCE_CONTROL_BLURAY_TV_CHANNEL_LIST[] = 'popup-source-control-tv-channel-list'

/*
 * --------------------
 * Touch panel image files
 * --------------------
 */

char IMAGE_FILE_NAME_NO_IMAGE_ICON[]    = 'icon-novideo.png'
char IMAGE_FILE_NAME_NO_VIDEO_SIGNAL_ICON[]    = 'icon-novideo.png'
char IMAGE_FILE_NAME_NO_VIDEO_ROUTE_ICON[]    = 'icon-novideo.png'

/*
 * --------------------
 * Touch panel sound files
 * --------------------
 */

char SOUND_FILE_NAME_CHIME[] = 'chime.wav'


/*
 * --------------------
 * Special Users
 * --------------------
 */

char USER_NAME_MAINTENANCE[] = 'Maintenance'



/*
 * --------------------
 * Timeline ID's
 * --------------------
 */


/*
 * --------------------
 * Other useful constants
 * --------------------
 */








#end_if