import Qt 4.7
import "../../QML/DH" as MComp

FocusScope {
    id:xm_engineeringlist_keypad

    MComp.BtnEngNumKeypad {
        id : xm_EngMode_Keypad
        focus:true
    }

    function onChangeValue(value) {
        if(selectEdit == "Latitude")
            selectNumLat = value;
        else if(selectEdit == "Longitude")
            selectNumLon = value;
    }

    function resetValue ()
    {
        xm_EngMode_Keypad.resetValue()
    }
}
