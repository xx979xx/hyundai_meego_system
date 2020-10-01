import QtQuick 1.0
import "../../system/DH" as MSystem

Rectangle {
    id:jogDialMain
    width: 253
    height: 253
    MSystem.ColorInfo{id:colorInfo}
    MSystem.ImageInfo{id:imageInfo}
    property string imaFolderVisual: imageInfo.imgFolderVisual_cue
    color: colorInfo.transparent

    Image{
        source: imaFolderVisual+"bg_visual_cue.png"
        Image{
            id:imgJogUp
            x:106
            y:72
            source: imaFolderVisual+idDmbMain.arrowImgUp
        }
        Image{
            id:imgJogLeft
            x:76
            y:106
            source: imaFolderVisual+idDmbMain.arrowImgLeft
        }
        Image{
            id:imgJogRight
            x:106+37
            y:106
            source: imaFolderVisual+idDmbMain.arrowImgRight
        }
        Image{
            id:imgJogDown
            x:105
            y:106+39
            source: imaFolderVisual+idDmbMain.arrowImgDown
        }
    }
}

