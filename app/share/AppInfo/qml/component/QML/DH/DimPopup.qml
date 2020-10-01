import Qt 4.7
import "../../system/DH" as MSystem

Item{
    id: idDimPopup
    x: 265; y:333-systemInfo.statusBarHeight
    width: 750; height: 190

    property string imgFolderPopup : imageInfo.imgFolderPopup
    property string messages1: "input messages"
    signal popupTimeout();

    MSystem.SystemInfo { id:systemInfo }
    MSystem.ColorInfo { id:colorInfo }
    MSystem.ImageInfo { id:imageInfo }

    //************************ Under Screen Disable ***// 20120103-KEH
    MouseArea{
        x: -265; y: -(333-systemInfo.statusBarHeight)
        width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
        onClicked: {
            idDimPopupTimer.running = false // jyjeon_20120220
            popupTimeout();
        }
    }

    //**************************************** Background Image
    Image {
        source: imgFolderPopup + "popup_bg_dim.png"
    }
    //**************************************** Messages Line 1
    Label {
        text: messages1
        txtAlign: "Center"
        fontSize: 34
        fontColor: colorInfo.brightGrey
    }

    Timer {
        id: idDimPopupTimer
        interval: 2000
        running: false
        repeat: false
        onTriggered:
        {
            popupTimeout();
        }
    }

    // Loading Completed!!
    Component.onCompleted: {
        idDimPopupTimer.running = true
    }

    onVisibleChanged: {
        if(visible){
            idDimPopupTimer.running = true
        }
    }
} // End FocusScope
