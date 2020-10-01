import Qt 4.7

import "../../system/DH" as MSystem

MComponent {
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ImageInfo { id: imageInfo }

    id: checkBox
    width: background.width;
    height: background.height

    property bool on: (state=="on")?true:false//false

    property bool showFocus : idAppMain.focusOn;
    
    signal checkBoxChecked();
    signal checkBoxUnchecked();

    function toggle() {
        if (checkBox.state == "on"){
            checkBox.state = "off";
            checkBoxUnchecked();
        }
        else{
            checkBox.state = "on";
            checkBoxChecked();
        }
        on = !on;
    }
    Image {
        id: focusedImage
        x:-3;y:-3
        source: imgFolderGeneral+"checkbox_f.png"
        width:48
        height:48
        visible: showFocus && checkBox.activeFocus
    }
    //-------------------- View the background
    Image {
        id: background
        source: imgFolderGeneral+"checkbox_uncheck_n.png"
    }
    //-------------------- View the check
    Image {
        id: check
        source: imgFolderGeneral+"checkbox_check_n.png"
        visible: false
    }

    states: [
        State {
            name: "on"
            PropertyChanges { target: check; visible: true }
        },
        State {
            name: "off"
            PropertyChanges { target: check; visible:false }
        }
    ]
}
