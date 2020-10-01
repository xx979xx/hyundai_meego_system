import Qt 4.7

import "../System" as MSystem

Item {
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ImageInfo { id: imageInfo }

    id: container

    property string buttonName: "NOT SET"
    property string target: "NOT SET"
    property string text: ""
    property string subText: ""
    property string fontName: "HDR"
    property int fontSize: 18
    property int fontX: 0
    property int fontY: 0
    property int imgX: 60
    property int imgY: 17
    property bool shadowColor: false
    property string txtAlign: "Center"

    property color fontColor: "#fafafa"
    property color fontColorShadow: "#000000"
    property color fontColorPressed: "#fafafa"
    property color fontColorPressedShadow: "#000000"
    property color fontColorActived: "#fafafa"
    property color fontColorActivedShadow: "#000000"

    property bool active: false
    property string imgFolderBt_phone : imageInfo.imgFolderBt_phone
    property string bgImage: imgFolderBt_phone+"btn_keypad_n.png"
    property string bgImagePressed: imgFolderBt_phone+"btn_keypad_p.png"
    property string bgImageActive: bgImagePressed
    property string dialNumImg: imgFolderBt_phone+"keypad_num_"+container.text+".png"

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
            bgTxtShadow.opacity = 0
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
        source: dialNumImg
        x:imgX; y:imgY
        width:50; height:47
        //fillMode: imgFillMode
        //anchors.fill: parent
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
        x:fontX;y:67

        font {
            family: container.fontName
            pixelSize: container.fontSize
        }
        text: container.subText
        color:fontColor
        //font.bold:true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            //console.debug(bgTxt.width);
            container.clicked(container.target, container.buttonName);
        }
        onPressAndHold: {
            container.pressAndHold(container.target, container.buttonName);
        }
    }

    states: [
        State {
            name: 'pressed'; when: mouseArea.pressed
            PropertyChanges {
                target: background; source: bgImagePressed;
            }
            PropertyChanges {
                target: bgTxt; color:fontColorPressed;
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
                target: bgTxt; color:fontColorActived;
            }
            PropertyChanges {
                target: bgTxtShadow; color:fontColorActivedShadow;
            }
        }
    ]


}
