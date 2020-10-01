import Qt 4.7

import "../../system/DH" as MSystem

FocusScope {
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ImageInfo { id: imageInfo }

    id: checkBox
    width: background.width;
    height: background.height

    property bool on: (state=="on")?true:false

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

    //-------------------- View the background
    Image {
        id: background
        source: imgFolderGeneral+"checkbox_uncheck.png"
        MouseArea { anchors.fill: parent; onClicked: toggle() }
    }
    //-------------------- View the check
    Image {
        id: check
        source: imgFolderGeneral+"checkbox_check.png"
        visible: false
        MouseArea { anchors.fill: parent; onClicked: toggle() }
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
