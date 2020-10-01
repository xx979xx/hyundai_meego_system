import Qt 4.7

Item {
    id: container

    property string buttonName: "NOT SET"
    property string target: "NOT SET"
    property string text: ""
    property string fontName: systemInfo.font_NewHDR
    property int fontSize: 34
    property int fontX: 0
    property int fontY: 0
    property int txtLeftMargin: 0
    property string txtAlign: "Center"   // Left, Right, Center

    property string fontStyle: ""
    property color fontStyleColor: "#000000"
    property color fontColor: "#fafafa"
    property color subFontColor: "#000000"
    property color fontColorShadow: "#000000"

    property bool active: false
    property string bgImage: ""
    property string imgFillMode: "PreserveAspectFit"

    signal clicked(string target, string button)

    //width: 50
    //height: 50

    opacity: enabled ? 1.0 : 0.5
    Component.onCompleted: {
        if(txtAlign==="Center") {
            if(bgImage ==="") {
                fontX=(parent.width - bgTxt.width)/2;
                fontY = fontY== 0? fontY=(parent.height - bgTxt.height)/2: fontY;
                width=bgTxt.width;
                height=bgTxt.height;
            }
            else {
                fontX=(background.width - bgTxt.width)/2;
                fontY=(background.height - bgTxt.height)/2;
            }
        }
        else if(txtAlign==="Left"){
            if(bgImage ==="") {
                fontX=txtLeftMargin;
                fontY = fontY== 0? fontY=(parent.height - bgTxt.height)/2:fontY;
                width=bgTxt.width;
                height=bgTxt.height;
            }
            else {
                fontX=txtLeftMargin;
                fontY=(background.height - bgTxt.height)/2;
            }
        }
        else if(txtAlign==="Right"){
            if(bgImage ==="") {
                fontX=(parent.width - bgTxt.width);
                fontY=(parent.height - bgTxt.height)/2;
                width=bgTxt.width;
                height=bgTxt.height;
            }
            else {
                fontX=(background.width - bgTxt.width);
                fontY=(background.height - bgTxt.height)/2;
            }
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
        id:subText
        x:fontX+1;y:fontY+1

        font {
            family: container.fontName
            pixelSize: container.fontSize
        }
        text: container.text
        color:subFontColor
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
        style: fontStyle
        styleColor: fontStyleColor
    }
}
