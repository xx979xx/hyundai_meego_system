import Qt 4.7
import "../../system/DH" as MSystem

MComponent {
    MSystem.SystemInfo{
        id:sysemInfo
    }
    MSystem.ImageInfo{id:imageInfo}

    id: container
    property string imgFolderBt_phone : imageInfo.imgFolderBt_phone
    property string buttonName: "NOT SET"
    property string target: "NOT SET"
    property string text: ""
    property string subText: ""
    property string fontName: "HDR"
    property int fontSize: 18
    property int fontX: 114+51
    property int fontY: 27+36
    property int imgX: 114
    property int imgY: 27
    property bool shadowColor: false
    property string txtAlign: "Center"

    property color fontColor: "#fafafa"
    property color fontColorShadow: "#000000"
    property color fontColorPressed: "#fafafa"
    property color fontColorPressedShadow: "#000000"
    property color fontColorActived: "#fafafa"
    property color fontColorActivedShadow: "#000000"

    property bool active: false
    property string bgImage: imgFolderBt_phone+"btn_dial_keypad_n.png"
    property string bgImagePressed: imgFolderBt_phone+"btn_dial_keypad_p.png"
    property string bgImageActive: bgImagePressed
    property string bgImageFocused: bgImagePressed
    property string dialNumImg: ""
    property string dialNumImgActive: ""
    property int focusX: 0
    property int focusY: 0

    property string imgFillMode: "PreserveAspectFit"

    signal clicked(string target, string button)
    signal pressAndHold(string target, string button)
    //width: 50
    //height: 50

    opacity: enabled ? 1.0 : 0.5
    Component.onCompleted: {
        if(txtAlign==="Center") {
            if(bgImage ===""&&bgImagePressed ==="") {
                fontX=0;
                fontY=0;
                width=bgTxt.width;
                height=bgTxt.height;
            }
            else {
                fontX=(background.width - bgTxt.width)/2;
                //fontY=(background.height - bgTxt.height)/2;
                width=background.width;
                height=background.height;
            }
        }
        if(!shadowColor) {
            //bgTxtShadow.opacity = 0
        }
    }

    Image {
        id: background
        source: bgImage;
        fillMode: imgFillMode
        anchors.fill: parent
        smooth: true
    }
    Image {
        id:padNum
        source:dialNumImg;
        x:imgX
        y:imgY
        fillMode: imgFillMode
        smooth: true
    }

    Text {
        id:bgTxtShadow
        x:fontX-1;y:fontY-1

        font {
            family: container.fontName
            pixelSize: container.fontSize
        }
        text: container.text
        color:fontColorShadow
        //font.bold:true
    }
    Text {
        id:bgTxt
        x:fontX;y:fontY

        font {
            family: container.fontName
            pixelSize: container.fontSize
        }
        text: container.subText
        color:fontColor
        //font.bold:true
    }

    BorderImage {
        id: idFocusImage
        x:-8; y:-8;
        source: bgImageFocused;
        //fillMode: imgFillMode
        width:parent.width + 16; height: parent.height +16
        border.left: 20; border.top: 20
        border.right: 20; border.bottom: 20
        visible: showFocus && container.activeFocus
    }
    states: [
        State {
            name: 'pressed'; when: mouseArea.pressed
            PropertyChanges {
                target: background; source: bgImagePressed;
            }
            PropertyChanges {
                target: padNum; source:dialNumImgActive;
            }
            PropertyChanges {
                target: bgTxtShadow; color:fontColorPressedShadow;
            }
        },
        State {
            name: 'active'; when: container.active
            PropertyChanges {
                target: background; source: bgImageActive;
            }

            PropertyChanges {
                target: bgTxtShadow; color:fontColorActivedShadow;
            }
        }
    ]


}
