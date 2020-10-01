import QtQuick 1.1

Rectangle {
    id: container
    width: 1280; height: 720
    color: Qt.rgba(0,0,0,1) //colorInfo.black

    property int loadingImageNumber: 1
    property int langID: EngineListener.GetLanguageID()

    Image {
        id: idBackgroundImage
        x: 73; y:97
        width: 1133; height: 526
        source: "/app/share/images/AppStandBy/loading/bg_camera_loading.png"
    }

    Image {
        id: idImageContainer
        x: 575; y:242
        width: 130; height: 130
        source: "/app/share/images/AppStandBy/loading/loading_01.png"
    }

    Rectangle {
        x: 300; y:482-22
        width: 680;

        Text {
               id: idLoadingtxt
               y: 0; width: 680
               text:  qsTranslate( "main", "STR_STANDBY_LOADING" ) + EngineListener.empty
               anchors.centerIn: parent
               horizontalAlignment : Text.AlignHCenter
               verticalAlignment:  Text.AlignVCenter
               color:  Qt.rgba(250/255, 250/255, 250/255, 1) //colorInfo.brightGrey
               font.family: langID > 2 && langID < 5 ? "CHINESS_HDB" : "DH_HDB" // "DFHeiW5-A"
               font.pointSize : 32
               wrapMode: Text.WordWrap;  textFormat: Text.RichText
               clip: true
        }
    }

    Timer {
        id: idLoadingImageTimer
        interval: 125
        running: true
        repeat: true

        onTriggered:
        {
            loadingImageNumber++;

            if (loadingImageNumber<10) {
                idImageContainer.source = "/app/share/images/AppStandBy/loading/loading_0"+ loadingImageNumber +".png"
            }
            else {
                idImageContainer.source = "/app/share/images/AppStandBy/loading/loading_"+ loadingImageNumber +".png"
            }
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
            idImageContainer.source = "/app/share/images/AppStandBy/loading/loading_01.png"
        }
    }
    Connections
    {
        target: EngineListener
        onRetranslateUi:
        {
            langID = language
        }
    }
}
