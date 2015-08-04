PROGRAM_NAME='integrate2015-boardroom-main'
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/05/2006  AT: 09:00:25        *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvRelays 	= 5001:8:0
//Relay 1 = 
//Relay 2 = 
//Relay 3 = 
//Relay 4 =
//Relay 5 =
//Relay 6 =
//Relay 7 =
//Realy 8 =
dvProjector 	= 5001:1:0	//Projector

//IR Devices
dvVCR 		= 5001:9:0	//VCR
dvDVD 		= 5001:10:0	//DVD
dvFoxtel 	= 5001:11:0	//Foxtel STB
//IO Ports
dvIO		= 5001:17:0	//IO Ports
//Touchpanels
dvTP 		= 10001:1:0	//Touch Panel

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

CHAR cFlash				//flash button variable

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE BULLSHIT GO BELOW              *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)

// DEFINE_FUNCTION

(***********************************************************)
(*        STARTUP/MODULES CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(** Code to flash touch panel buttons
WAIT 3 													//speed of flash
	cFlash = !cFlash									//flash variable
	
[dvTP,TP_VOL_MUTE] = ([dvVolume, VOL_MUTE] && cFlash)	//devChan function links
**)

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

