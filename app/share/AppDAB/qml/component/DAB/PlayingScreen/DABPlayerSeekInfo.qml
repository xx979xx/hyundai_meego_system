/**
 * FileName: DABPlayerSeekInfo.qml
 * Author: DaeHyungE
 * Time: 2013-09-03
 *
 * - 2013-01-17 Initial Crated by HyungE
 */

import Qt 4.7

FocusScope {
    id : idDABPlayerSeekInfo

    Text {
        id : idServiceName
        x : 0
        y : 32 //60 - 56/2
        width : 776
        height : 56

        text : stringInfo.strPlayer_Searching
        font.family: idAppMain.fonts_HDR
        font.pixelSize : 56
        color: colorInfo.brightGrey
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment:Text.AlignLeft
    }

    Item {
        id : idArtistRect
        x : -10     //454 - 464
        y : 160     //495 - 335
        width : 785 //65 + 720
        height : 49

        Image {
            id : idArtistImg
            source : imageInfo.imgIcoArtist
            anchors.verticalCenter : parent.verticalCenter;
        }
    }

    Item {
        id : idSongRect
        x : -10             //454 - 464
        y : 216             //160 + 25 + 31   //495 - 335
        width : 785         //65 + 720
        height : 49

        Image {
            id : idSongImg
            source : imageInfo.imgIcoMusic
            anchors.verticalCenter : parent.verticalCenter;
        }
    }
}
