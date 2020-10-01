/**
 * /QML/DH/DDPlayAnimation.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


Image
{
    id: idPlayAnimationContainer
    source: ImagePath.imgFolderGeneral + "play/ico_play_01.png"
    width: 46
    height: 46
    visible: true

    // PROPERTIES
    SequentialAnimation on source {
        running: idPlayAnimationContainer.visible
        loops: Animation.Infinite

        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_01.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_02.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_03.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_04.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_05.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_06.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_07.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_08.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_09.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_10.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_11.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_12.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_13.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_14.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_15.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_16.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_17.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_18.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_19.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_20.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_21.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_22.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_23.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_24.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_25.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_26.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_27.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_28.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_29.png"; easing.type: Easing.Linear }
        PropertyAnimation { duration: 80; to: ImagePath.imgFolderGeneral + "play/ico_play_30.png"; easing.type: Easing.Linear }
    }
}
/* EOF */
