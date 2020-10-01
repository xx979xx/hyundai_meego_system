import Qt 4.7

import "../../system/DH" as MSystem

//Item {
MComponent{
    id: container

    MSystem.SystemInfo{ id: systemInfo }

    property string buttonName: "NOT SET"
    property string target: "NOT SET"
    property string text: ""
    property string fontName: "HDR"
    property int fontSize: 34
    property int fontX: 0
    property int fontY: 0
    property int imgX: 0
    property int imgY: 0
    property int itemWidth: 0
    property int itemHeight: 0
    property bool shadowColor: true
    property string txtAlign: "Center"

    property color fontColor: "#fafafa"
    property color fontColorShadow: "#000000"
    property color fontColorPressed: "#fafafa"
    property color fontColorPressedShadow: "#000000"
    property color fontColorActived: "#fafafa"
    property color fontColorActivedShadow: "#000000"

    property bool active: false
    property bool itemFocus: false
    property string focusImg : bgImageFocus
    property string bgImage: imgFolderGeneral+"btn_bottom_n.png"
    property string bgImagePressed: imgFolderGeneral+"btn_bottom_n_transprent.png"
    property string bgImageActive: bgImagePressed
    property string bgImageFocus: bgImagePressed
    property string fgImg: ""
    property string fgImgPressed: ""
    property string imagePressed: ""
    property string imageFocused: ""
    property string imgFillMode: "PreserveAspectFit"

    //width: 50
    //height: 50

    opacity: enabled ? 1.0 : 0.5
    Component.onCompleted: {
        background.x=(itemWidth-background.width)/2
        if(txtAlign==="Center") {
            if(bgImage ===""&&bgImagePressed ==="") {
                fontX=0;
                //fontY==0?0:fontY;
                width=bgTxt.width;
                height=bgTxt.height;
            }
            else {
                fontX=(itemWidth - bgTxt.width)/2;
                fontY==0?fontY=(background.height - bgTxt.height)/2:fontY
                width=background.width;
                height=background.height;
            }
        }
        if(!shadowColor) {
            bgTxtShadow.opacity = 0
        }
    }

    BorderImage {
        id: focusImage
        source: focusImg;
        smooth: true
        x: -12; y:-12; z:1
        width:parent.width + 24; height: parent.height +24
        border.left: 20; border.top: 20
        border.right: 20; border.bottom: 20
        visible: showFocus && container.activeFocus
    } // End BorderImage

    Image {
        id: background
        //width:container.width;height:container.height
        source: bgImage;
        fillMode: imgFillMode
        anchors.fill: parent
        smooth: true
    }
    Image {
        id: foregroundImg
        x: imgX; y: imgY
        width: itemWidth; height: itemHeight
        source: fgImg;
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
        text: container.text
        color:fontColor
        //font.bold:true
    }

    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {
                target: background; source: bgImagePressed;
            }
            PropertyChanges {
                target: bgTxt; color:fontColorPressed;
            }
            PropertyChanges {
                target: bgTxtShadow; color:fontColorPressedShadow;
            }
            PropertyChanges {
                target: foregroundImg; source: fgImgPressed;
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
                target: foregroundImg; source: imagePressed;
            }
        },
        State {
            name: 'itemFocus'; when: container.itemFocus
            PropertyChanges {
                target: background; source: bgImageFocus;
            }
            PropertyChanges {
                target: bgTxt; color:fontColorActived;
            }
            PropertyChanges {
                target: bgTxtShadow; color:fontColorActivedShadow;
            }
            PropertyChanges {
                target: foregroundImg; source: imageFocused;
            }
        }
    ]
}
