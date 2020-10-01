import Qt 4.7

FocusScope {

    id: checkBox
    width: background.width;
    height: background.height

    property bool on: (state=="on")?true:false//false
    property string imgFolderMusic: imageInfo.imgFolderMusic

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
    function setOn()
    {
        state = "on";
    }
    function setOff()
    {
        state = "off";
    }

    //-------------------- View the background
    Image {
        id: background
        //source: imgFolderMusic+"checkbox_uncheck.png"
//        source: imageInfo.imgFolderGeneral+"checkbox_uncheck.png"
        MouseArea {
            anchors.fill: parent;
            onClicked: {
                UIListener.playAudioBeep();
                toggle()
            }
        }
    }
    //-------------------- View the check
    Image {
        id: check
//        source: imageInfo.imgFolderGeneral+"checkbox_check.png"
        visible: false
        MouseArea {
            anchors.fill: parent;
            onClicked: {
                UIListener.playAudioBeep();
                toggle()
            }
        }
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
