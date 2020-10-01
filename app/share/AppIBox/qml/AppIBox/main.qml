import QtQuick 1.0
import QtGStreamer 0.10
import QmlStatusBar 1.0
import "DRSPopUp.js" as DRSPopUp

Item {

    id: root
    y:0; width: 1280; height: 720


    VideoItem {
        id: video
        width: 1280
        height: 720
        surface: videoSurface
    }

//    Rectangle {
//        id: hideVideo

//        x:0; y:0; width: 1280; height: 720

//        color: "#000000"
//        visible: true
//    }

    Connections {
        target: EngineListener

        //onSigShowVideo: hideVideo.visible = false
        //onSigHideVideo: hideVideo.visible = true
        onSigStatusBar: statusBar.visible = bShow
    }

    Loader {
        id: popup_loader
        anchors.fill: parent
    }

    QmlStatusBar {
        id: statusBar
        x: 0; y: 0; width: 1280; height: 93
        homeType: "button"
        middleEast: (UIListener.GetCountryVariantFromQML() == 4) ? true : false
    }

    function loadDRSPopUp()
    {
        popup_loader.source = "DRSPopUp.qml";
    }

    function loadDRSPopUp_DownloadApps()
    {
        popup_loader.source = "DRSPopUp_DownloadApps.qml";
    }

    function loadDRSPopUp_DLNA()
    {
        popup_loader.source = "DRSPopUp_DLNA.qml";
    }

    function unloadDRSPopUp()
    {
        popup_loader.source = "";
    }

    /*
    Connections
    {
        target: popup_loader.item
        onButtonClicked:
        {
            console.log("buttonId=" + buttonId);
            switch (buttonId)
            {
            case DRSPopUp.const_BUTTON_PREV:
            {
                ViewWidgetController.setDecrementTrackPosition();
                break;
            }
            case DRSPopUp.const_BUTTON_PLAY:
            {
                ViewWidgetController.setPlayPause( true );
                break;
            }
            case DRSPopUp.const_BUTTON_STOP:
            {
                ViewWidgetController.setPlayPause( false );
                break;
            }
            case DRSPopUp.const_BUTTON_NEXT:
            {
                ViewWidgetController.setIncrementTrackPosition();
                break;
            }
            case DRSPopUp.const_BUTTON_LIST:
            {
                ViewWidgetController.showDLNAList();
                break;
            }
            case DRSPopUp.const_BUTTON_BACK:
            {
                ViewWidgetController.backFromDRSPopup();
                break;
            }
            }
        }
        onStateChanged:
        {
            console.log("state=" + state)
        }
    }
    */
}



