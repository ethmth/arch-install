ToggleMic(){
; 3 is my mic id number, run findmicid.ahk to find yours and replace 3 for your id
SoundSet, +1, MASTER, mute,3 
SoundGet, master_mute, , mute, 3

; uncomment bellow to show tooltips
; ToolTip, Mute %master_mute% 
; SetTimer, RemoveToolTip, 1000
; return

; RemoveToolTip:
; SetTimer, RemoveToolTip, Off
; ToolTip
; return
}
