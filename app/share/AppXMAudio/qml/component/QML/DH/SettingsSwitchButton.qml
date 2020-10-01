import Qt 4.7

FocusScope {
    id: container

    property string buttonName: "NOT SET"
    property string target: "NOT SET"
    property string text: ""
    property string fontName: systemInfo.font_NewHDR
    property int fontSize: 34
    property int textYPostion: 123
    property int textfontHeight: 0
    property int imgWidthOffset: 0
    property int imgHeightOffset: 0
    property int testWidth: 0
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

    property string imgFolderSettings : imageInfo.imgFolderSettings
    property string bgImage: imgFolderSettings+"bg_switch.png"
    property string bgImageToggle: imgFolderSettings+"switch.png"
    property string bgImageFocus: ""
    property string imgFillMode: "PreserveAspectFit"
    property int knobX : 1
    property int knobY : 1

    signal clicked(string target, string button)
    width: 123+105+6//parent.width
    height: 62//parent.height

    opacity: enabled ? 1.0 : 0.5

    property bool showFocus: false;

    property bool on: false
    function toggle() {
        if (container.state == "on"){
            container.state = "off";
            container.clicked(container,"off")
        }
        else{
            container.state = "on";
            container.clicked(container,"off")
        }
    }
    function releaseSwitch() {
        if (knob.x == 0) {
            if (container.state == "off") return;
        }
        if (knob.x == 131) {
            if (container.state == "on") return;
        }
        toggle();
    }

    Image {
        id: background
        source: bgImage
        MouseArea { anchors.fill: parent; onClicked: toggle() }
        width: parent.width - imgWidthOffset
        height: parent.height - imgHeightOffset
    }

    Text{
        x:6;y:0
        width: background.width/2
        height: textfontHeight
        text:"ON"
        color:colorInfo.brightGrey
        font { family: systemInfo.font_NewHDR; pixelSize: fontSize}
        verticalAlignment:Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
    Text{
        x:textYPostion;y:0
        width: background.width/2
        height: textfontHeight
        text:"OFF"
        color:colorInfo.brightGrey
        font { family: systemInfo.font_NewHDR; pixelSize: fontSize}
        verticalAlignment:Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Image {
        id: knob
        x: knobX; y: knobY
        source: bgImageToggle
        width: background.width/2
        height: background.height

        MouseArea {
            anchors.fill: parent
            drag.target: knob; drag.axis: Drag.XAxis; drag.minimumX: 0; drag.maximumX: background.width/2
            onClicked: toggle()
            onReleased: releaseSwitch()
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
            PropertyChanges { target: knob; x: background.width/2 }
            PropertyChanges { target: container; on: true }
        },
        State {
            name: "off"
            PropertyChanges { target: knob; x: knobX }
            PropertyChanges { target: container; on: false }
        }
    ]
    transitions: Transition {
        NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 100 }
    }
}
