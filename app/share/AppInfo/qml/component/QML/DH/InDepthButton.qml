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
    property string fontName: "HDR"
    property int fontSize: 34
    property int fontX: 0
    property int fontY: 0

    property bool shadowColor: true
    property string txtAlign: "Center"
    property color fontColor: "#000000"
    property color fontColorShadow: "#d4d4d4"
    property color fontColorPressed: "#000000"
    property color fontColorPressedShadow: "#d4d4d4"
    property color fontColorActived: "#000000"
    property color fontColorActivedShadow: "#d4d4d4"

    property bool active: false
    //property string imgFillMode:Image.TileHorizontally
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
//    property string focusImage: imageInfo.imgFolderRadio + "bg_jog_soft_key_f.png"
    //property string focusImage: imageInfo.imgFolderRadio_Dab + "bg_bottom_f.png"
    property string bgImage: imgFolderGeneral+"btn_indepth_bottom_n.png"
    property string bgImagePressed: imgFolderGeneral+"btn_indepth_bottom_p.png"
    property string bgImageActive: bgImagePressed
    property string imgFillMode: "Stretch"

    //width: 50
    //height: 50

    opacity: enabled ? 1.0 : 0.5
    Component.onCompleted: {
        if(txtAlign==="Center") {
//            fontX=(background.width - bgTxt.width)/2;
//            fontY=(background.height - 26 - bgTxt.height)/2;
        }
        if(!shadowColor) {
            bgTxtShadow.opacity = 0
        }
    }
    BorderImage {
        id: idFocusImage
        x:-12; y:-12
        source: focusImage
        width: parent.width+24; height: parent.height-20+24;
        border.left: 20; border.top: 20
        border.right: 20; border.bottom: 20
        visible: showFocus && container.activeFocus;
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
        //x:fontX-1;y:fontY-1
        x:bgTxt.x-1; y:bgTxt.y-1;
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
        height:parent.height-26;

        font {
            family: container.fontName
            pixelSize: container.fontSize
        }
        text: container.text
        color:fontColor
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

    states: [
        State {
            name: 'pressed'; when: isMousePressed() //mouseArea.pressed
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
