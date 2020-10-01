import Qt 4.7

import "../../system/DH" as MSystem

//FocusScope {
MComponent {
    id: container

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ImageInfo{ id: imageInfo }

    property string buttonName: "NOT SET"
    property string target: "NOT SET"
    property string text: ""
    property string fontName: "HDBa1"
    property int fontSize: 29
    property int fontX: 0
    property int fontY: 0

    property bool shadowColor: true
    property string txtAlign: "Center"
    property color fontColor: "#fafafa"
    property color fontColorShadow: "#000000"
    property color fontColorPressed: "#fafafa"
    property color fontColorPressedShadow: "#000000"
    property color fontColorActived: "#fafafa"
    property color fontColorActivedShadow: "#000000"

    property bool active: false
    //property string imgFillMode:Image.TileHorizontally
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string bgImage:imgFolderGeneral+"btn_mode_6_n.png"
    property string bgImagePressed:imgFolderGeneral+"btn_mode_p.png"
    property string bgImageActive: bgImagePressed
    property string bgImageFocused:imgFolderGeneral+"bg_top_btn_f.png"
    property string imgFillMode: "Stretch"

    width: 194
    height: 68

    opacity: enabled ? 1.0 : 0.5
    Component.onCompleted: {
        if(txtAlign==="Center") {
            //fontX=(background.width - bgTxt.width)/2;
            //fontY=(background.height - bgTxt.height)/2;
        }
        if(!shadowColor) {
            bgTxtShadow.opacity = 0
        }
    }

    Image {
        id: idFocusImage
	x:-8; y:-8; z:1
        source: bgImageFocused;
        //fillMode: imgFillMode
        visible: showFocus && container.activeFocus//;idFocusImage.activeFocus
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
        x:bgTxt.x+1; y:bgTxt.y+1
        width:bgTxt.width; height:bgTxt.height;

        font {
            family: container.fontName
            pixelSize: container.fontSize
        }
        text: container.text
        color:fontColorShadow
        //font.bold:true
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
        height:parent.height
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
