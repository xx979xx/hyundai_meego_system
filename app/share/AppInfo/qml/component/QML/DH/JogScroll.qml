import QtQuick 1.0
import "../../system/DH" as MSystem

Rectangle {
    id:jogScroll
    x:0
    z:100
    y:0
    width: 34
    height: 493
    color:colorInfo.transparent

    property int viewPo
    property int listCount
    property int viewHeight : (493/listCount)*7
    property string imgFolderRadio: imageInfo.imgFolderRadio

    MSystem.ColorInfo {id:colorInfo}
    MSystem.ImageInfo {id:imageInfo}
    MSystem.SystemInfo {id:systemInfo}
    Rectangle{
        width: 34
        height:viewHeight
        x:0
        y:viewPo
        clip: true
        color: colorInfo.transparent
        Image{
            id:imgJogScrollBG
            height:493
            width:34
            y:-parent.y
            x:0
            source: imgFolderRadio+"radio_jog_scroll.png"
        }
    }
}

