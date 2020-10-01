/**
 * FileName: DABPlayerInfoIcon.qml
 * Author: DaeHyungE
 * Time: 2013-0-17
 *
 * - 2012-0-17 Initial Crated by HyungE
 */

import Qt 4.7

FocusScope {
    id : idDABPlayerInfoIcon

    property int loadingImgCount        : 1
    property int loadingImgCountMax     : 16
    property bool isLoadingImg          : true

    Item {
        id : idScanItem
        x : 1198
        y : 0
        width : 67
        height : 67

        SequentialAnimation {
            id : anim
            loops : Animation.Infinite
            running : (m_bListScanningOn || m_bPresetScanningOn)

            NumberAnimation {
                target : idScanImg
                property : "visible"
                from : 0
                to : 1
                duration : 500
            }

            NumberAnimation {
                target : idScanImg
                property : "visible"
                from : 1
                to : 0
                duration : 500
            }
        }

        Image {
            id: idScanImg
            source : imageInfo.imgBtScan
            visible : (m_bListScanningOn || m_bPresetScanningOn)
        }
    }

    Image{
        id: idDABtoDABItem
        source : imageInfo.imgBgTA_N
        anchors.fill: idScanItem
        visible : false

        Text {
            id : idDABtoDABText1
            x: 3; y: 21-26/2
            width: 61; height: font.pixelSize
            text : "DAB"
            font.family : idAppMain.fonts_HDB
            font.pixelSize : 26
            color : Qt.rgba( 149/255, 153/255, 160/255, 1)
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment:Text.AlignHCenter
        }
        Text {
            id : idDABtoDABText2
            x: 3; y: 21+28-26/2
            width: 61; height: font.pixelSize
            text : "DAB"
            font.family : idAppMain.fonts_HDB
            font.pixelSize : 26
            color : Qt.rgba( 149/255, 153/255, 160/255, 1)
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment:Text.AlignHCenter
        }
    }

    Image{
        id: idDABtoFMItem
        source : imageInfo.imgBgTA_N
        anchors.fill: idScanItem
        visible : false

        Text {
            id : idDABtoFMText1
            x: 3; y: 21-26/2
            width: 61; height: font.pixelSize
            text : "DAB"
            font.family : idAppMain.fonts_HDB
            font.pixelSize : 26
            color : Qt.rgba( 149/255, 153/255, 160/255, 1)
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment:Text.AlignHCenter
        }
        Text {
            id : idDABtoFMText2
            x: 3; y: 21+28-26/2
            width: 61; height: font.pixelSize
            text : "FM"
            font.family : idAppMain.fonts_HDB
            font.pixelSize : 26
            color : Qt.rgba( 149/255, 153/255, 160/255, 1)
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment:Text.AlignHCenter
        }
    }

    Image{
        id: idloadingItem
        source : imageInfo.imgBgTA_N
        anchors.fill: idScanItem
        visible : false

        Image {
            id: idIcon_loading
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: imageInfo.imgFolderRadio_Rds + "loading/loading_01.png";         
            property bool on: parent.visible;
            NumberAnimation on rotation { running: idloadingItem.visible; from: 0; to: 360; loops: Animation.Infinite; duration: 2400 }
        }
    }

    states: [
        State {
            name : "DABtoDABOn"
            when : m_bDABtoDABOn
            PropertyChanges { target : idDABtoDABItem; visible : true}
        },
        State {
            name : "DABtoFMOn"
            when : m_bDABtoFMOn
            PropertyChanges { target : idDABtoFMItem; visible : true}
        },
        State {
            name : "ListScanning"
            when : (m_bListScanningOn || m_bPresetScanningOn)
            PropertyChanges { target : idloadingItem; visible : false }
        }
    ]
}
