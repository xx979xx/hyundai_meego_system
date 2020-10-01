import Qt 4.7

import "../../system/DH" as MSystem

MComponent {
    id: container

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }

    property string buttonName: "NOT SET"
    property string target: "NOT SET"
    property string text: ""
    property string fontName: "HDBa1"
    property int fontSize: 34
    property int fontX: 0
    property int fontY: 0

    property bool shadowColor: true
    property string txtAlign: "Center"
    property color fontColor: "#2f2f2f"
    property color fontColorShadow: "#fafafa"
    property color fontColorPressed: "#2f2f2f"
    property color fontColorPressedShadow: "#fafafa"
    property color fontColorActived: "#2f2f2f"
    property color fontColorActivedShadow: "#fafafa"

    property bool active: false
    //property string imgFillMode:Image.TileHorizontally
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string bgImage: imgFolderGeneral + "radio_off_n.png"
    property string bgImageFocus: imgFolderGeneral + "radio_f.png"
    property string bgImagePressed: imgFolderGeneral + "radio_on_n.png"
    property string bgImageActive: bgImagePressed
    property string modeImage: ""
    property string modeImagePressed: ""
    property string imgFillMode: "TileHorizontally"

    property alias bgsource : background.source //jsh

    signal clicked()//(string target, string button)

    property bool showFocus : idAppMain.focusOn;

    //width: 50
    //height: 50

    opacity: enabled ? 1.0 : 0.5
    Component.onCompleted: {
        if(txtAlign==="Center") {
            fontX=(background.width - bgTxt.width)/2;
            fontY=(background.height - bgTxt.height)/2;
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
        id:modeImg
        source:modeImage
        anchors {
            centerIn:background
        }
        smooth: true
    }
    Image {
        id:idFocusImage
        source: (showFocus && activeFocus)?bgImageFocus:""
        anchors {
            centerIn:background
        }
        //visible:false;
        smooth: true
    }

    Text {
        id:bgTxtShadow
        x:fontX+1;y:fontY+1

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
        text: container.text
        color:fontColor
        ////font.bold:true
    }

//    onClickOrKeySelected: {
//        selectedIndex = index
//    }

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
//            PropertyChanges {
//                target: modeImg; source:modeImagePressed;
//            }
        },
        State {
            name: 'active'; when: container.active
            PropertyChanges {
                target: background; source: bgImagePressed;
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
