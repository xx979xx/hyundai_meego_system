import QtQuick 1.0
import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
MComp.MComponent{
    id: idLogListStart

    x:20
    y:10
    width:1280 - 480
    height:550
    clip:true
    focus: true
    MSystem.SystemInfo { id: systemInfo }
    Text
    {
         x:50; y:190
        id:empty_text
        height:50
        font.family: UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("Log Level Setting UI(Application List ) : Clik List ICON")
        verticalAlignment: Text.AlignVCenter

    }
}
