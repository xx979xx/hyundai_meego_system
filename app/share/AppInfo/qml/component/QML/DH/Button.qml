import Qt 4.7

import "../../system/DH" as MSystem

//FocusScope {
MComponent {
    id: container

    MSystem.SystemInfo { id: systemInfo }
    MSystem.ImageInfo { id:imageInfo }

    property string buttonName: "NOT SET"
    property string target: "NOT SET"
    property string text: ""
    property string fontName: "HDR"
    property int fontSize: 34
    property int fontX: 0
    property int fontY: 0
    //property int fontWidth: container.width//rds setting`s menu text 2011.11.24

    property bool shadowColor: true
    property string txtAlign: "Center"

    property color fontColor: "#fafafa"
    property color fontColorShadow: "#000000"
    property color fontColorPressed: "#fafafa"
    property color fontColorPressedShadow: "#000000"
    property color fontColorActived: "#fafafa"
    property color fontColorActivedShadow: "#000000"

    property bool active: false
    property string bgImage: ""
    property string bgImagePressed: ""
    property string bgImageActive: bgImagePressed
    property string bgImageFocused: imageInfo.imgFolderGeneral+"bg_top_btn_f.png"
    property string imgFillMode: "PreserveAspectFit"
    property string buttonImg: ""
    property string buttonclickImg: ""
    property string press: "black"
    property int buttonImagWidth:0
    property int buttonImagHeight:0
    property int buttonImagX:0
    property int buttonImagY:0

    //width: 50
    //height: 50

    opacity: enabled ? 1.0 : 0.5
    Component.onCompleted: {
        if(txtAlign=="Center") {
            if(bgImage ===""&&bgImagePressed ==="") {
                fontX=0;
                fontY=0;
                width=bgTxt.width;
                height=bgTxt.height;
            }
            else {
//                fontX=(background.width - bgTxt.width)/2;
//                fontY=(background.height - bgTxt.height)/2;
                fontX=0;
                fontY=0;
                width=background.width;
                height=background.height;
            }
//            bgTxt.horizontalAlignment = Text.AlignHCenter;
//            bgTxt.verticalAlignment = Text.AlignVCenter;
//            bgTxtShadow.horizontalAlignment = Text.AlignHCenter;
//            bgTxtShadow.verticalAlignment = Text.AlignVCenter;
        }
        if(!shadowColor) {
            bgTxtShadow.opacity = 0
        }
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
    Image {
        id: background
        source: bgImage;
        fillMode: imgFillMode
        anchors.fill: parent
        //width: parent.width
        //height: parent.height
        smooth: true

    }

    Image{
        id:nomalButtonImg
        width:buttonImagWidth
        height:buttonImagHeight
        x:buttonImagX
        y:buttonImagY
        source: buttonImg
    }

    Text {
        id:bgTxtShadow
//	x:fontX-1;y:fontY-1
//	width: fontWidth
        x:bgTxt.x+1;y:bgTxt.y+1
        width:bgTxt.width;height:bgTxt.height;

        font {
            family: container.fontName
            pixelSize: container.fontSize
        }
        text: container.text
        color:fontColorShadow
        //elide: Text.ElideRight
        //font.bold:true
        horizontalAlignment : Text.AlignHCenter; //Default Center
        verticalAlignment : Text.AlignVCenter;
        wrapMode:Text.Wrap
        //onPaintedHeightChanged: {
        onTextChanged: {
            font.pixelSize = container.fontSize
            if(paintedHeight > height){
                font.pixelSize = (font.pixelSize*0.8);
            }
        }
    }
    Text {
        id:bgTxt
        x:fontX;y:fontY
        //width: fontWidth
        width:container.width;
        height:container.height;
        //x:fontX;y:fontY
//        anchors.fill: parent;

        font {
            family: container.fontName
            pixelSize: container.fontSize
        }
        text: container.text
        color:fontColor
        //elide: Text.ElideRight
        //font.bold:true
        horizontalAlignment : Text.AlignHCenter; //Default Center
        verticalAlignment : Text.AlignVCenter;
        wrapMode:Text.Wrap
        //onPaintedHeightChanged: {
        onTextChanged: {
            font.pixelSize = container.fontSize
            if(paintedHeight > height){
                font.pixelSize = (font.pixelSize*0.8);
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
            PropertyChanges {
                target: nomalButtonImg; source:buttonclickImg;
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
