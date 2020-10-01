import Qt 4.7

FocusScope {
    id: checkBox
    width: background.width;
    height: background.height

    property bool notUsedCheckBox : false
    property bool on: (state == "on")? true : false

    property bool showFocus : idAppMain.focusOn;
    
    signal checkBoxChecked();
    signal checkBoxUnchecked();
    signal checkBoxNotUsed();

    function toggle() {
        if (checkBox.state == "on")
        {
            checkBox.state = "off";
            checkBoxUnchecked();
        }
        else
        {
            checkBox.state = "on";
            checkBoxChecked();
        }
        on = !on;
    }

    //-------------------- View the background
    Image {
        id: background
//        source: imageInfo.imgFolderGeneral+"checkbox_uncheck.png"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(notUsedCheckBox == false) toggle();
                else checkBoxNotUsed();
            }
        }
    }
    //-------------------- View the check
    Image {
        id: check
//        source: imageInfo.imgFolderGeneral+"checkbox_check.png"
        visible: false
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(notUsedCheckBox == false) toggle();
                else checkBoxNotUsed();
            }
        }
    }

//    states: [
//        State {
//            name: "on"
//            PropertyChanges { target: check; visible: true }
//        },
//        State {
//            name: "off"
//            PropertyChanges { target: check; visible:false }
//        }
//    ]
}
