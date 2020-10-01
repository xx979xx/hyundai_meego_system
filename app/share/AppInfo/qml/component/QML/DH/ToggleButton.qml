import Qt 4.7

import "../../system/DH" as MSystem

Button {
    id: toggleKey
    width: background.width;
    height: background.height

    MSystem.SystemInfo { id: systemInfo }
    MSystem.ImageInfo { id: imageInfo }

    property bool on: false
    property string settingImg :imageInfo.imgFolderSettings
    property string bgImage: ""
    property string bgImagePressed: ""
    property string buttonImage: ""
    property string buttonImagepress: ""
    property string bgImageFocused: ""

    property int buttonImagWidth:0
    property int buttonImagHeight:0
    property int buttonImagX:0
    property int buttonImagY:0

    function toggle() {
        if (toggleKey.state == "on")
            toggleKey.state = "off";
        else
            toggleKey.state = "on";
    }

    //-------------------- View the background
    Image {
        width: parent.width
        height: parent.height
        id: background
        source: bgImage
        Image {
            x:buttonImagX
            y:buttonImagY
            width: buttonImagWidth
            height: buttonImagHeight
            id: buttonImg
            source: buttonImage
        }
    }

    //-------------------- hold press
    Image {
        width:parent.width
        height:parent.height
        id: press
        source: bgImagePressed
        visible: false
        Image {
            x:buttonImagX
            y:buttonImagY
            width: buttonImagWidth
            height: buttonImagHeight
            id: buttonImgpress
            source: buttonImagepress
            visible: false
        }
    }
    BorderImage {
        id: idFocusImage
        x:-8; y:-8;
        source: bgImageFocused;
        width:parent.width + 16; height: parent.height +16
        border.left: 20; border.top: 20
        border.right: 20; border.bottom: 20
        visible: showFocus && toggleKey.activeFocus
    }

    //// hold press
    states: [
        State {
            name: "on"
            PropertyChanges { target: press; visible: true; }
            PropertyChanges { target: buttonImgpress; visible: true; }
//            PropertyChanges { target: buttonImgpress; visible: true}
//            PropertyChanges { target: buttonImg; visible: false}
        },
        State {
            name: "off"
            PropertyChanges { target: press; visible:false }
            PropertyChanges { target: buttonImgpress; visible: false; }
//            PropertyChanges { target: buttonImgpress; visible:false }
//            PropertyChanges { target: buttonImg; visible: true}

        }
    ]
}
