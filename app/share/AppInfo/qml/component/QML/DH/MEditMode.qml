/**
 * FileName: MEditMode.qml
 * Author: David.Bae
 * Time: 2012-04-02
 *
 * - 2012-04-02 Initial Crated by Problem Kang
 */

import Qt 4.7
import "../../system/DH" as MSystem

MComponent{

    id:idEditMode
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.ColorInfo { id: colorInfo }

    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property int buttonNumber: 4
    width:250
    height:systemInfo.lcdHeight-166
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    property string buttonText1 : "Btn1Line"
    property string buttonText2 : "Btn2Line"
    property string buttonText3 : "Btn3Line"
    property string buttonText4 : "Btn4Line"

    signal clickButton1()
    signal clickButton2()
    signal clickButton3()
    signal clickButton4()

    Image{
        anchors.fill: parent
        source:imgFolderGeneral+"bg_edit_mode.png"

        MButton{
            id:editButton1
            x:28
            y:buttonNumber==3?79:9
            focus:true
            width:214
            height:129
            bgImage:imgFolderGeneral+"btn_edit_mode_n.png"
            bgImagePress: imgFolderGeneral+"btn_edit_mode_p.png"
            bgImageFocus: imgFolderGeneral+"btn_edit_mode_f.png"
            bgImageFocusPress: imgFolderGeneral+"btn_edit_mode_fp.png"

            firstText: buttonText1
            firstTextWidth: 202
            firstTextX: 6
            firstTextY: 64
            firstTextSize: 32
            firstTextColor: colorInfo.brightGrey
            firstTextStyle: "HDB"
            firstTextAlies: "Center"

            onClickOrKeySelected: {
                clickButton1()
            }
            KeyNavigation.down:editButton2
        }

        MButton{
            id:editButton2
            x:28
            anchors.top:editButton1.bottom
            anchors.topMargin: 5
            width:214
            height:129
            bgImage:imgFolderGeneral+"btn_edit_mode_n.png"
            bgImagePress: imgFolderGeneral+"btn_edit_mode_p.png"
            bgImageFocus: imgFolderGeneral+"btn_edit_mode_f.png"
            bgImageFocusPress: imgFolderGeneral+"btn_edit_mode_fp.png"

            firstText: buttonText2
            firstTextWidth: 202
            firstTextX: 6
            firstTextY: 64
            firstTextSize:32
            firstTextColor: colorInfo.brightGrey
            firstTextStyle: "HDB"
            firstTextAlies: "Center"

            onClickOrKeySelected: {
                clickButton2()
            }
            KeyNavigation.up:editButton1
            KeyNavigation.down:editButton3
        }

        MButton{
            id:editButton3
            x:28
            anchors.top:editButton2.bottom
            anchors.topMargin: 5
            width:214
            height:129
            bgImage:imgFolderGeneral+"btn_edit_mode_n.png"
            bgImagePress: imgFolderGeneral+"btn_edit_mode_p.png"
            bgImageFocus: imgFolderGeneral+"btn_edit_mode_f.png"
            bgImageFocusPress: imgFolderGeneral+"btn_edit_mode_fp.png"

            firstText: buttonText3
            firstTextWidth: 202
            firstTextX: 6
            firstTextY: 64
            firstTextSize:32
            firstTextColor: colorInfo.brightGrey
            firstTextStyle: "HDB"
            firstTextAlies: "Center"

            onClickOrKeySelected: {
                clickButton3()
            }
            KeyNavigation.up:editButton2
            KeyNavigation.down:buttonNumber==3?editButton3:editButton4
        }

        MButton{
            id:editButton4
            x:28
            anchors.top:editButton3.bottom
            anchors.topMargin: 5
            visible:buttonNumber==3?false:true
            width:214
            height:129
            bgImage:imgFolderGeneral+"btn_edit_mode_n.png"
            bgImagePress: imgFolderGeneral+"btn_edit_mode_p.png"
            bgImageFocus: imgFolderGeneral+"btn_edit_mode_f.png"
            bgImageFocusPress: imgFolderGeneral+"btn_edit_mode_fp.png"

            firstText: buttonText4
            firstTextWidth: 202
            firstTextX: 6
            firstTextY: 64
            firstTextSize:32
            firstTextColor: colorInfo.brightGrey
            firstTextStyle: "HDB"
            firstTextAlies: "Center"

            onClickOrKeySelected: {
                clickButton4()
            }
            KeyNavigation.up:editButton3
        }
    }
}
