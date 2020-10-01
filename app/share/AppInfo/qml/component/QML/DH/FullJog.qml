import QtQuick 1.0
import "../../system/DH" as MSystem

Rectangle {
    width: 281
    height: 281
    MSystem.ColorInfo{id:colorInfo}
    MSystem.ImageInfo{id:imageInfo}
    property string visualImg: imageInfo.imgFolderVisual_cue
    color: colorInfo.transparent
    Image{
        source: visualImg+"bg_bt_visual_cue.png"

        ToggleButton{
            x:67
            y:68
            bgImage: visualImg+"btn_bt_center_n.png"
            bgImagePressed: visualImg+"btn_bt_center_p.png"
            buttonImage: visualImg+"icon_bt_mute n.png"
            buttonImagepress: visualImg+"icon_bt_mute_p.png"
            width: 147
            height: 147
            id: fullJogMute
            buttonImagWidth:45
            buttonImagHeight:40
            buttonImagX:123-67
            buttonImagY:123-68
        }
    }
    Image {
        x:34
        y:37
        id:jogTurnLeft
        source: visualImg+"icon_bt_wheel_l_n.png"
    }
    Image {
        x:34+93
        y:37
        id:jogTurnRight
        source: visualImg+"icon_bt_wheel_r_n.png"
    }
    Image {
        x:247
        y:121
        id:jogArrowRight
        source: visualImg+"icon_arrow_trans_r_n.png"
    }
    Item {
        anchors.fill: parent
        focus: true
        Keys.onPressed: {
            if (event.key == Qt.Key_Q) {
                jogTurnLeft.source= visualImg+"icon_bt_wheel_l_p.png"
                jogTurnRight.source= visualImg+"icon_bt_wheel_r_n.png"
                jogArrowRight.source= visualImg+"icon_arrow_trans_r_n.png"
            }

            else if (event.key == Qt.Key_S) {
                if(fullJogMute.state=="on")
                {
                    fullJogMute.state="off"
                }
                else
                    fullJogMute.state="on"
            }

            else if (event.key == Qt.Key_E) {
                jogTurnLeft.source= visualImg+"icon_bt_wheel_l_n.png"
                jogTurnRight.source= visualImg+"icon_bt_wheel_r_p.png"
                jogArrowRight.source= visualImg+"icon_arrow_trans_r_n.png"
            }

            else if (event.key == Qt.Key_D) {
                jogTurnLeft.source= visualImg+"icon_bt_wheel_l_n.png"
                jogTurnRight.source= visualImg+"icon_bt_wheel_r_n.png"
                jogArrowRight.source= visualImg+"icon_arrow_r_p.png"
            }
        }
        Keys.onReleased:{
            jogTurnLeft.source= visualImg+"icon_bt_wheel_l_n.png"
            jogTurnRight.source= visualImg+"icon_bt_wheel_r_n.png"
            jogArrowRight.source= visualImg+"icon_arrow_trans_r_n.png"
        }
    }
}
