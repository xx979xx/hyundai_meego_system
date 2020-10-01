import Qt 4.7

import "../../system/DH" as MSystem

Item {
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ImageInfo { id: imageInfo }

    id: tabOnOff
    width: 31; height: 21

    property string imgFolderBt_phone: imageInfo.imgFolderBt_phone

    function toggle() {
        if (tabOnOff.state == "open")
            tabOnOff.state = "close";
        else
            tabOnOff.state = "open";
    }

    //-------------------- View the close image(default)
    Image {
        id: img_close
        source: imgFolderBt_phone+"tab_icon_close.png"
        MouseArea {
            anchors.fill: parent; onClicked: toggle()
        }
    }

    //-------------------- View the open image
    Image {
        id: img_open
        source: imgFolderBt_phone+"tab_icon_open.png"
        visible: false
        MouseArea {
            anchors.fill: parent; onClicked: toggle()
        }
    }

    states: [
        State {
            name: "open"
            PropertyChanges { target: img_close; visible: false }
            PropertyChanges { target: img_open; visible: true }
        },
        State {
            name: "close"
            PropertyChanges { target: img_close; visible:true }
            PropertyChanges { target: img_open; visible: false }
        }
    ]
}
