#Requires AutoHotkey v2.0
#SingleInstance Force
ProcessSetPriority "High"
CoordMode("ToolTip","Screen")

SendMode("Event")
SetKeyDelay(-1,-1)
SetMouseDelay -1

f(CPS,limit := 50) { ;sleep is limitied in ahk, thus a multiplier has to be used to achieve higher CPS
    CPS := (CPS=0)+Abs(CPS)
    return [Ceil(CPS/limit),(Ceil(CPS/limit)*1000)/CPS] ;https://www.desmos.com/calculator/aefmbh27s4 made by me
}

global mt := f(50), mode := true ;mode true = hold, false = toggle

*!c::{
    global mt, mode
    while(!mode&&GetKeyState("c","P")) {
        Sleep 10
    }
    ToolTip("autoclicker on" (!mode?"`n`nhold alt c to turn off autoclicker":""),A_ScreenWidth*0.1,A_ScreenHeight*0.1)
    while((mode&&GetKeyState("c","P"))||(!mode&&!(GetKeyState("c","P")&&GetKeyState('Alt',"P")))) {
        loop mt[1] {
            Click
        }
        Sleep mt[2]
    }
    ToolTip()
}

customize() {
    global mt, mode
    try { ;try in case the user types in the wrong data type
        mt := f(Round(InputBox("CPS`n`nclicks per second",,,Round(mt[1]*(1000/mt[2]))).Value))
        mode := MsgBox("current autoclicker mode: " (mode?"HOLD":"TOGGLE") "`n`npress yes to keep current autoclicker mode`n`npress no to change to " (!mode?"HOLD":"TOGGLE"),,"YesNo")="Yes"? mode:!mode
    }
}

while true {
    customize()
    MsgBox("alt c to use autoclicker`n`npress somewhere else to hide this MsgBox`n`npress retry if you wanna change the autoclicker settings or cancel to exit",,"RetryCancel")="Cancel"? ExitApp():0
}

