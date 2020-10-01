import Qt 4.7

import "../../system/DH" as MSystem

Item {
    id: container

    MSystem.SystemInfo { id: systemInfo }
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

    property color fontColor: "#d4d4d4"
    property color fontColorShadow: "#000000"
    property color fontColorPressed: "#d4d4d4"
    property color fontColorPressedShadow: "black"
    property color fontColorActived: "#2f2f2f"
    property color fontColorActivedShadow: "#d4d4d4"

    property bool active: false
    //property string imgFillMode:Image.TileHorizontally
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string bgImage: imgFolderGeneral+"bottom_tab_n.png"
    property string bgImagePressed: imgFolderGeneral+"bottom_tab_p.png"
    property string bgImageActive: imgFolderGeneral+"bottom_tab_s.png"
    property string imgFillMode: "TileHorizontally"

    signal clicked(string target, string button)

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

    Text {
        id:bgTxtShadow
        x:fontX-1;y:fontY-1
        font {
            family: container.fontName
            pixelSize: container.fontSize
            // bold:true
        }
        text: container.text
        color:fontColorShadow
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
        //font.bold:true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            //console.debug(bgTxt.width);
            container.clicked(container.target, container.buttonName);
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
            PropertyChanges {
                target: bgTxtShadow; x:fontX+1;y:fontY+1;
            }
        }
    ]
}
