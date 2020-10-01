import QtQuick 1.1
import "../system" as MSystem

Rectangle {
    id: container
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    color: colorInfo.black

    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }
    MSystem.StringInfo {id:stringInfo}

    property int loadingImageNumber: 1

    Image {
        id: idBackgroundImage
        x: 73; y:97
        width: 1133; height: 526
        source: systemInfo.imageInternal+"bg_camera_loading.png"
    }

    Image {
        id: idImageContainer
        x: 575; y:242
        width: 118; height: 118
        source: systemInfo.imageInternal+"loading/loading_01.png"
    }

    Rectangle {
        x: 300; y:482-22
        width: 680;

        Text {
               id: idLoadingtxt
               y: 0; width: 680
               text: stringInfo.cameraLoadingTxt
               anchors.centerIn: parent
               horizontalAlignment : Text.AlignHCenter
               verticalAlignment:  Text.AlignVCenter
               color: colorInfo.brightGrey
               font.family: stringInfo.fontName
               font.pointSize : systemInfo.alertFontSize
               wrapMode: Text.WordWrap;  textFormat: Text.RichText
               clip: true
        }
    }

    Timer {
        id: idLoadingImageTimer
        interval: 125
        running: false
        repeat: true

        onTriggered:
        {
            loadingImageNumber++;

            if (loadingImageNumber<10) {
                idImageContainer.source = systemInfo.imageInternal+"loading/loading_0"+ loadingImageNumber +".png"
            }
            else {
                idImageContainer.source = systemInfo.imageInternal+"loading/loading_"+ loadingImageNumber +".png"
            }

            //console.log("img no:" + loadingImageNumber);

            if(loadingImageNumber == 16)
            {
                loadingImageNumber = 0;
            }
        }
    }

    onVisibleChanged: {

        if(visible)
        {
            idLoadingImageTimer.start();
        }
        else
        {
            idLoadingImageTimer.stop();
            loadingImageNumber = 1;
            idImageContainer.source = systemInfo.imageInternal+"loading/loading_01.png"
        }
    }
}
