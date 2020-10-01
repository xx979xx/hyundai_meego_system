import QtQuick 1.0
import "../../component/system/DH" as MSystem
import "../../component/QML/DH" as MComp

MComp.MComponent{
    id : idInfoMenuButton
    focus: true
    width:parent.width; height:parent.height

    //--------------- Background Image(Property) #
    property string bgImage : "None"
    property int bgImageX: 170-73
    property int bgImageY: 315-289
    property int bgImageWidth: 189
    property int bgImageHeight: 189

    //--------------- Focus Image(Property) #
    property string fgImage : imgFolderAutocare+"bg_autocare_f.png"
    property int fgMargint: 26
    property int fgImageX: -fgMargint
    property int fgImageY: -fgMargint
    property int fgImageWidth: parent.width + fgMargint
    property int fgImageHeight: parent.height + fgMargint

    //--------------- Text Info(Property) #
    property string menuText: "None"
    property int menuTextSize: 26
    property string menuTextStyle: "HDR"
    property string menuTextColor: colorInfo.brightGrey
    property string menuTextAlies: "Center" // Right, Left, Center(default value)

    onActiveFocusChanged:{ console.debug(" # [InfoMenuButton][onActiveFocusChanged] activeFocus :",idInfoMenuButton.activeFocus) }

    //--------------- Background Image #
    Image{
        source: bgImage
        x: bgImageX; y: bgImageY
        width: bgImageWidth; height: bgImageHeight
    } // End Image

    //--------------- Focus Image #
    Image{
        source: fgImage
        x: fgImageX; y: fgImageY
        width: fgImageWidth; height: fgImageHeight
        visible: showFocus && idInfoMenuButton.activeFocus
    } // End Image

    //--------------- Text #
    Item{
        x:bgImageX; y:bgImageY+161-menuTextSize/2; z: 1
        width: bgImageWidth
        height: menuTextSize
        
        Text{
            text: menuText
            font.family: menuTextStyle
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: menuTextSize
            color: menuTextColor
            horizontalAlignment: {
                if(menuTextAlies=="Right"){Text.AlignRight}
                else if(menuTextAlies=="Left"){Text.AlignLeft}
                else if(menuTextAlies=="Center"){Text.AlignHCenter}
                else {Text.AlignHCenter}
            }
        } // End Text
    } // End Item
} // End ImgTxtButton
