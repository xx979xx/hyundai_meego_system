import Qt 4.7

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MComponent {
    id: container
    width: 234; height: 62
    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.ColorInfo { id: colorInfo }

    property string buttonName: "NOT SET"
    property string target: "NOT SET"
    property string text: ""
    property string fontName: "HDR"
    property int fontSize: 34
    property int fontX: 0
    property int fontY: 0
    property bool bOff: true
    property bool shadowColor: true
    property string txtAlign: "Center"

    property color fontColor: "#fafafa"
    property color fontColorShadow: "#000000"
    property color fontColorPressed: "#fafafa"
    property color fontColorPressedShadow: "#000000"
    property color fontColorActived: "#fafafa"
    property color fontColorActivedShadow: "#000000"

    property bool active: false
    property bool flagToggle : false
    property string imgFolderSettings : imageInfo.imgFolderSettings
    property string focusImg : imgFolderSettings + "bg_switch_f.png"
    property string bgImage: imgFolderSettings + "bg_switch.png"
    property string bgImageToggle: imgFolderSettings + "switch.png"
    property string imgFillMode: "PreserveAspectFit"

    //signal clicked(string target, string button)

    opacity: enabled ? 1.0 : 0.5

    property bool on: false
    function toggle() {
        if (container.state == "On"){
            container.state = "Off";
            flagToggle = false
        }
        else{
            container.state = "On";
            flagToggle = true
        }
    }
    function releaseSwitch() {
        if (knob.x == 0)
            if (container.state == "Off") return;
        if (knob.x == 128)
            if (container.state == "On") return;
        toggle();
    }
    Image {
        id: background
        width: parent.width; height: parent.height
        source: bgImage
        MouseArea { anchors.fill: parent; onClicked: toggle() }
    } // End Image
    Item{
        id: leftTxtItem
        x: 6; y:+2
        width: parent.width/2-6*2; height: parent.height

        Text {
            id: leftTxt
            text : "ON"
            font.family: "HDR"
            font.pixelSize: 34
            color: colorInfo.brightGrey
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        } // End Text
    } // End Item
    Item{
        id: rightTxtItem
        x: parent.width/2+6; y:+2
        width: parent.width/2-6*2; height: parent.height

        Text {
            id: rightTxt
            text : "OFF"
            font.family: "HDR"
            font.pixelSize: 36
            color: colorInfo.brightGrey
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        } // End Text
    } // End Item
    Image {
        id: focusImage
        source: focusImg;
        x: -12; y:-12; z: 1
        visible: container.activeFocus
    } // End Image

    Image {
        id: knob
        x: 0; y: 0
        width: parent.width/2; height: parent.height
        source: bgImageToggle

        MouseArea {
            anchors.fill: parent
            drag.target: knob; drag.axis: Drag.XAxis; drag.minimumX: 0; drag.maximumX: parent.width/2
            onClicked: toggle()
            onReleased: releaseSwitch()
        }
    }
    onClickOrKeySelected: {toggle()}
    states: [
        State {
            name: "On"
            PropertyChanges { target: knob; x: parent.width/2 }
            PropertyChanges { target: container; on: true }
        },
        State {
            name: "Off"
            PropertyChanges { target: knob; x: 0 }
            PropertyChanges { target: container; on: false }
        }
    ]
    transitions: Transition {
        NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 200 }
    }
}
