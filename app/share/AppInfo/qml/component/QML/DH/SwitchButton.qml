import Qt 4.7

import "../../system/DH" as MSystem

MComponent {
    id: container
    state:toggleInfo

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ImageInfo { id: imageInfo }

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
    property string toggleInfo

    property color fontColor: "#fafafa"
    property color fontColorShadow: "#000000"
    property color fontColorPressed: "#fafafa"
    property color fontColorPressedShadow: "#000000"
    property color fontColorActived: "#fafafa"
    property color fontColorActivedShadow: "#000000"

    property bool active: false

    property string imgFolderSettings : imageInfo.imgFolderSettings
    property string bgImage: imgFolderSettings+"bg_switch.png"
    property string bgImageToggle: imgFolderSettings+"switch.png"
    property string bgImageFocus: ""
    property string imgFillMode: "PreserveAspectFit"
    property int knobX : 1
    property int knobY : 1

    width: 123+105+6//parent.width
    height: 62//parent.height

    opacity: enabled ? 1.0 : 0.5

    property bool showFocus: false;

    property bool on: false

    signal releasedSwitch()

    Image {
        id: background
        source: bgImage
        MouseArea { anchors.fill: parent; onReleased: {releasedSwitch();}}
        width: parent.width
        height: parent.height
    }

    Text{
        x:6;y:0
        width: 105
        height: 66
        text:"On"
        color:colorInfo.brightGrey
        font { family: "HDR"; pixelSize: 36}
        verticalAlignment:Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
    Text{
        x:123;y:0
        width: 105
        height: 66
        text:"Off"
        color:colorInfo.brightGrey
        font { family: "HDR"; pixelSize: 36}
        verticalAlignment:Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Image {
        id: knob
        x: knobX; y: knobY
        source: bgImageToggle
        width: parent.width/2
        height: parent.height

        MouseArea {
            anchors.fill: parent
            drag.target: knob; drag.axis: Drag.XAxis; drag.minimumX: 0; drag.maximumX: parent.width/2
            onReleased: {
                releasedSwitch()
            }
        }
    }
    Image {
        id: backgroundFocus
        x:-12; y:-12
        source: imageInfo.imgFolderSettings+"bg_switch_f.png"
        visible: showFocus && container.activeFocus
    }
    states: [
        State {
            name: "on"
            PropertyChanges { target: knob; x: parent.width/2 }
            PropertyChanges { target: container; on: true }
        },
        State {
            name: "off"
            PropertyChanges { target: knob; x: knobX }
            PropertyChanges { target: container; on: false }
        }
    ]
    transitions: Transition {
        NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 200 }
    }
}
