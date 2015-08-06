PROGRAM_NAME='integrate2015-boardroom-main'

/*
SYSTEM IP ADDRESSES
DVX: xxx.xxx.xxx.31
NMX Decoder: xxx.xxx.xxx.36
Enzo: xxx.xxx.xxx.37
SPX-1300: xxx.xxx.xxx.38
DX-TX1: xxx.xxx.xxx.39 (surface pro)
DX-TX2: xxx.xxx.xxx.40 (VGA laptop)
DX-RX: xxx.xxx.xxx.41
NMX Encoder: xxx.xxx.xxx.42
MXT-1001: xxx.xxx.xxx.32 (main)
MXD-1000P: xxx.xxx.xxx.33 (scheduling)
Alero: xxx.xxx.xxx.34

BDRM_SW1: xxx.xxx.xxx.233
BDRM_SW2: xxx.xxx.xxx.234
Programmers IP: xxx.xxx.xxx.232
*/

// IP address of DVX in boardroom demo at Integrate 2014: 192.168.251.81

/*
 * --------------------
 * System defines (always first!)
 * --------------------
 */
#include 'system-defines'



// Library Files
#include 'common'
#include 'debug'

#include 'system-library-api'
#include 'system-library-control'







#include 'system-devices'
#include 'system-structures'
#include 'system-constants'
#include 'system-variables'
#include 'system-mutual-exclusions'



/*
 * --------------------
 * 3rd party device includes
 * --------------------
 */

// special case agent-usb-ptz-web-cam needs to be declared above system variables
// as they reference constants within this include file
#include 'agent-usb-ptz-web-cam'	
// Need to declare the lighting include file after declaring the lighting devices
#include 'cbus-lighting'
// Need to declare the nec monitor include file after declaring the monitor devices
#include 'nec-monitor'
// Need to declare the wake-on-lan include file after declaring the wake-on-lan IP socket
#include 'wake-on-lan'
// Need to declare the rms-main include file after declaring the RMS virtual device
#include 'rms-main'


#include 'system-modules'
#include 'system-functions'
#include 'system-events'
#include 'system-start'
#include 'system-mainline'


/*
 * --------------------
 * Listener includes (always last!)
 * --------------------
 */

#include 'system-library-listener'


#include 'system-rms-api'

#include 'system-rms-listener'

