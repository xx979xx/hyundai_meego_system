import Qt 4.7

import "../../system/DH" as MSystem

//FocusScope {
MComponent {
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
    property color fontColor: "#2f2f2f"
    property color fontColorShadow: "#fafafa"
    property color fontColorPressed: "#2f2f2f"
    property color fontColorPressedShadow: "#fafafa"
    property color fontColorActived: "#2f2f2f"
    property color fontColorActivedShadow: "#fafafa"

    property bool active: false
    //property string imgFillMode:Image.TileHorizontally
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderRadio : imageInfo.imgFolderRadio
//    property string focusImg : imgFolderRadio+"bg_jog_soft_key_f.png"
    property string customFocusImg : "";
    property string bgImage: imgFolderGeneral+"btn_bottom_n.png"
    property string bgImagePressed: imgFolderGeneral+"btn_bottom_p.png"
    property string bgImageActive: bgImagePressed
    property string modeImage: ""
    property string modeImagePressed: ""
    property string imgFillMode: "TileHorizontally"

    property int focusImageX:0;
    property int focusImageY:0;

    //width: 50
    //height: 50

    opacity: enabled ? 1.0 : 0.5
    Component.onCompleted: {
        if(txtAlign==="Center") {
            // It must be checked..
            //fontX=(background.width - bgTxt.width)/2;
            //fontY=(background.height - bgTxt.height)/2;
        }
        if(!shadowColor) {
            bgTxtShadow.opacity = 0
        }
    }
    Image {
        id: idCustomFocusImage
        source: customFocusImg;
        //smooth: true
        x: focusImageX;
        y: focusImageY; z:1
        visible: customFocusImg != "" && showFocus && container.activeFocus
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
    Text {
        id:bgTxtShadow
        //x:fontX+1;y:fontY+1
        x:bgTxt.x+1; y:bgTxt.y+1
        width:bgTxt.width; height:bgTxt.height;
        font {
            family: container.fontName
            pixelSize: container.fontSize
        }
        text: container.text
        color:fontColorShadow

        //font.bold:true
        //elide: Text.ElideRight
        horizontalAlignment : Text.AlignHCenter; //Default Center
        verticalAlignment : Text.AlignVCenter;
        wrapMode:Text.Wrap
        //onPaintedHeightChanged: {
        onTextChanged: {
            if(paintedHeight > height){
                font.pixelSize = (font.pixelSize*0.8);
            }else{
                font.pixelSize = container.fontSize
            }
        }
    }
    Text {
        id:bgTxt
        x:fontX;y:fontY
        width:parent.width;
        height:parent.height;

        font {
            family: container.fontName
            pixelSize: container.fontSize
        }
        text: container.text
        color:fontColor
        horizontalAlignment : Text.AlignHCenter; //Default Center
        verticalAlignment : Text.AlignVCenter;
        wrapMode:Text.Wrap

        //onPaintedHeightChanged: {
        onTextChanged: {
            //console.log("Command Button lineCount:" + lineCount + " - "+text)
            if(paintedHeight > height){
                font.pixelSize = ((font.pixelSize*0.8));
            }else{
                font.pixelSize = container.fontSize
            }
        }
    }
//    BorderImage {
//        id: idFocusDefaultImage
//        source: focusImg;
//        smooth: true
//        x: -12; y:-12; z:1
//        width:parent.width + 24; height: parent.height +24
//        border.left: 20; border.top: 20
//        border.right: 20; border.bottom: 20
//        visible: showFocus && container.activeFocus
//    } // End BorderImage

    states: [
        State {
            name: 'pressed'; when: isMousePressed() //mouseArea.pressed //(mouseArea.pressed & !container.dimmed)
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
                target: modeImg; source:modeImagePressed;
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
        },
        State {
            name: 'dimmed'; when: container.dimmed
            PropertyChanges {
                target: bgTxt; color:fontColorShadow;
            }
            PropertyChanges {
                target: bgTxtShadow; color:fontColorActivedShadow;
            }
        }
    ]
}
