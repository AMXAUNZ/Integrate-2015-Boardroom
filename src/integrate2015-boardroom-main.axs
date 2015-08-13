PROGRAM_NAME='integrate2015-boardroom-main'

/*
SYSTEM IP ADDRESSES
DVX: 192.169.251.31
NMX Decoder: 192.169.251.3136
Enzo: 192.169.251.3137
SPX-1300: 192.169.251.3138
DX-TX1: 192.169.251.3139 (surface pro)
DX-TX2: 192.169.251.3140 (VGA laptop)
DX-RX: 192.169.251.3141
NMX Encoder: 192.169.251.3142
MXT-1001: 192.169.251.3132 (main)
MXD-1000P: 192.169.251.3133 (scheduling)
Alero: 192.169.251.3134

BDRM_SW1: 192.169.251.31233
BDRM_SW2: 192.169.251.31234
Programmers IP: 192.169.251.21
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

//Jeremy's Development Sandbox File
#warn 'Remove before system is put into production...'
#include 'dev-sandbox'


/*
 * --------------------
 * Listener includes (always last!)
 * --------------------
 */

#include 'system-library-listener'


#include 'system-rms-api'

#include 'system-rms-listener'

