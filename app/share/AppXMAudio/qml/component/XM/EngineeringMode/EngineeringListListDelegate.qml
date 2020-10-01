import Qt 4.7
import "../../QML/DH" as MComp

FocusScope {
    id: delegate
    width: delegate.GridView.view.width
    height: 50
    smooth: true
    focus:true

    property string engNameColor: colorInfo.dimmedGrey
    property string engContextColor: colorInfo.brightGrey
    
    // Engineering Name
    Text {
        id:idSXMRadioEngName
        x: 10; y: 12+13-(font.pixelSize/2)
        width: 148; height: 20
        font.pixelSize: 20
        font.family : systemInfo.font_NewHDB
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        color: engNameColor
        text : EngModName
    }

    // Engineering Context
    Text {
        id:idSXMRadioEngContext
        x: 159; y: 12+13-(font.pixelSize/2)
        width: 158; height: 18
        font.pixelSize: 18
        font.family : systemInfo.font_NewHDB
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        color: engContextColor
        text : EngModContext
    }

    Image {
        id : imgListLine
        x: 0; y : parent.height - imgListLine.height
        width: parent.width
        source : imageInfo.imgFolderRadio_SXM + "line_list.png"
    }
}
