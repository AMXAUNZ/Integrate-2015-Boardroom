program_name='cbus-lighting'

#if_not_defined __CBUS_LIGHTING__
#define	__CBUS_LIGHTING__

#include 'amx-device-control'


define_device

#if_not_defined dvLight
//dvLight = 5001:1:0
dvLight = 0:3:0
#end_if

#if_not_defined vdvLight
vdvLight = 33001:1:0
#end_if


define_variable

char cLightStatus[255]


/*
 * --------------------
 * Lighting constants
 * --------------------
 */



define_constant

//char cLightAddressBoardroom[]		= '00:38:00'

// lighting levels by percentage 
INTEGER LIGHTING_LEVEL_0_PERCENT    = 0
INTEGER LIGHTING_LEVEL_10_PERCENT   = 25
INTEGER LIGHTING_LEVEL_20_PERCENT   = 51
INTEGER LIGHTING_LEVEL_30_PERCENT   = 76
INTEGER LIGHTING_LEVEL_40_PERCENT   = 102
INTEGER LIGHTING_LEVEL_50_PERCENT   = 127
INTEGER LIGHTING_LEVEL_60_PERCENT   = 153
INTEGER LIGHTING_LEVEL_70_PERCENT   = 178
INTEGER LIGHTING_LEVEL_80_PERCENT   = 204
INTEGER LIGHTING_LEVEL_90_PERCENT   = 230
INTEGER LIGHTING_LEVEL_100_PERCENT  = 255


//define_module 'CBus_Comm' mCbusNetLinx (vdvLight, dvLight, cLightStatus)

define_module 'Clipsal_CBus_Comm_dr1_0_0' mCbusDuet(vdvLight, dvLight)


/*
 * --------------------
 * Lighting Functions
 * --------------------
 */


define_function lightsPassThroughData (char strData[])
{
	sendCommand (vdvLight,"'PASSTHRU-',strData")
}

define_function lightsSetLevelAll(integer lightingLevel)
{
	sendCommand (vdvLight,"'LIGHTSYSTEMLEVEL-255:1:ALL,',itoa(lightingLevel)")
	
	if (lightingLevel == 0)
		channelOff (dvPduMain1,chanPduLightingIntegrate)
	else
		channelOn (dvPduMain1,chanPduLightingIntegrate)
}

define_function lightsSetLevel (char strLightAddress[], integer lightingLevel)
{
	sendCommand (vdvLight,"'LIGHTSYSTEMLEVEL-',strLightAddress,',',itoa(lightingLevel)")
	
	if (lightingLevel == 0)
		channelOff (dvPduMain1,chanPduLightingIntegrate)
	else
		channelOn (dvPduMain1,chanPduLightingIntegrate)
}

define_function lightsSetLevelWithFade (char strLightAddress[], integer lightingLevel, integer fadeRateInSeconds)
{
	sendCommand (vdvLight,"'LIGHTSYSTEMLEVEL-',strLightAddress,',',itoa(lightingLevel),',',itoa(fadeRateInSeconds)")
	
	if (lightingLevel == 0)
		channelOff (dvPduMain1,chanPduLightingIntegrate)
	else
		channelOn (dvPduMain1,chanPduLightingIntegrate)
}

define_function lightsToggle (char strLightAddress[])
{
	sendCommand (vdvLight,"'LIGHTSYSTEMSTATE-',strLightAddress,',TOGGLE'")
}

define_function lightsOn (char strLightAddress[])
{
	sendCommand (vdvLight,"'LIGHTSYSTEMSTATE-',strLightAddress,',ON'")
	channelOn (dvPduMain1,chanPduLightingIntegrate)
}

define_function lightsOff (char strLightAddress[])
{
	sendCommand (vdvLight,"'LIGHTSYSTEMSTATE-',strLightAddress,',OFF'")
	channelOff (dvPduMain1,chanPduLightingIntegrate)
}

define_function lightsEnableRampUp (char strLightAddress[])
{
	sendCommand (vdvLight, "'LIGHTSYSTEMRAMP-',strLightAddress,',UP'")
}

define_function lightsEnableRampDown (char strLightAddress[])
{
	sendCommand (vdvLight, "'LIGHTSYSTEMRAMP-',strLightAddress,',DOWN'")
}

define_function lightsDisableRamp (char strLightAddress[])
{
	sendCommand (vdvLight, "'LIGHTSYSTEMRAMP-',strLightAddress,',STOP'")
}

DEFINE_EVENT
DATA_EVENT[vdvLight]
{
	ONLINE:
	{
		SEND_COMMAND vdvLight,"'PROPERTY-IP_Address,192.168.251.82'"
		//SEND_COMMAND vdvLight, "'REINIT'"
	
		//SEND_COMMAND vdvLight, "'PROPERTY-IPADDRESS,192.168.251.82'"
		//SEND_COMMAND vdvLight, "'PROPERTY-IPPORT,10001'"
		//SEND_COMMAND vdvLight, "'REINIT'"
		//WAIT 50
		//SEND_COMMAND vdvLight, "'PROPERTY-SYNCH,3'"
	}
}






















#end_if