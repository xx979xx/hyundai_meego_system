/**
 * FileName: MBtCmdButton.qml
 * Author: Problem Kang
 * Time: 2012-03-26
 *
 * - 2012-02-03 Initial Crated by Problem Kang
 */

import Qt 4.7
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MComponent {
    id: idMAppMain

    //****************************** # For active(button select) by HYANG #
    property bool active: false
    property string buttonName: ""
    //****************************** # End #

    //button Info(width,height)
    property int buttonWidth: parent.width
    property int buttonHeight: parent.height
    property string bgImage: imgFolderBt_phone+"ico_call_add_n.png"
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""
    property string bgImageFocusPress: ""

    //Image Info
    property int fgImageX: 0
    property int fgImageY: 0
    property int fgImageWidth : 66
    property int fgImageHeight : 66
    property string fgImage:""
    property string fgImagePress: fgImage
    property string fgImageActive: fgImage
    property string fgImageFocus: fgImage
    property string fgImageFocusPress: fgImage

    //first Text Info
    property string firstText: ""
    property int firstTextSize: 0
    property int firstTextX: 0
    property int firstTextY: 0
    property int firstTextWidth: 0
    property int firstTextHeight: firstTextSize
    property string firstTextStyle: "HDR"
    property string firstTextAlies: "Left"
    //****************************** # For text (elide, visible) by HYANG #
    property string firstTextElide: "None"      // ex) "Right" >> ABCDEFG..
    property bool firstTextVisible: true
    //****************************** # End #
    property bool firstTextEnabled: true // <<---------- Added by WSH (Enabled)
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor : firstTextColor
    property string firstTextFocusPressColor : firstTextPressColor
    property string firstTextSelectedColor: "Black"
    property string firstDimmedTextColor: "red"//colorInfo.dimmedGrey
    opacity: enabled ? 1.0 : 0.5


    Component.onCompleted: {  //2012. 3. 12 Proplem Kang
        if(firstTextAlies=="Right"){txtFirstText.horizontalAlignment="AlignRight"}
        else if(firstTextAlies=="Left"){txtFirstText.horizontalAlignment="AlignLeft"}
        else if(firstTextAlies=="Center"){txtFirstText.horizontalAlignment="AlignHCenter"}

        if(secondTextAlies=="Right"){txtSecondText.horizontalAlignment="AlignRight"}
        else if(secondTextAlies=="Left"){txtSecondText.horizontalAlignment="AlignLeft"}
        else if(secondTextAlies=="Center"){txtSecondText.horizontalAlignment="AlignHCenter"}

        if(thirdTextAlies=="Right"){txtThirdText.horizontalAlignment="AlignRight"}
        else if(thirdTextAlies=="Left"){txtThirdText.horizontalAlignment="AlignLeft"}
        else if(thirdTextAlies=="Center"){txtThirdText.horizontalAlignment="AlignHCenter"}
    }

    //BackGround Image
    Image{
        id:backGround
        source: bgImage
        anchors.fill: parent
    }
    Item{
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width:79+txtFirstText.width
        height: 66
        Image {
            id: imgFgImage
            x:fgImageX
            y:fgImageY
            width:fgImageWidth
            height:fgImageHeight
            source: fgImage
        }
        Text {
            id: txtFirstText
            text: firstText
            x:firstTextX
            y:firstTextY-(firstTextSize/2)
            width: firstTextWidth
            height: firstTextHeight
            color:firstTextColor
            font.family: firstTextStyle
            font.pixelSize: firstTextSize
            verticalAlignment: Text.AlignVCenter
            //****************************** # For text (elide, visible) by HYANG #
            elide: {
                if(firstTextElide=="Right"){Text.ElideRight}
                else if(firstTextElide=="Left"){Text.ElideLeft}
                else if(firstTextElide=="Center"){Text.ElideMiddle}
                else /*if(firstTextElide=="None")*/{Text.ElideNone}
            }
            visible: firstTextVisible
            clip: true //jyjeon_20120221
            //****************************** # End #
            enabled: firstTextEnabled // <<---------- Added by WSH (Enabled)
        }
    }


    //Focus Image
    Image {
        anchors.fill: backGround
        id: idFocusImage
        source: bgImageFocus
        visible: showFocus && container.activeFocus
    }

    onSelectKeyPressed: (container.dimmed)? container.state="dimmed" : container.state="keyPress"
    onSelectKeyReleased: (container.dimmed)? container.state="dimmed" : (active==true?container.state="active":container.state="keyReless")
    onStateChanged: {console.debug("---------------------------------->> onStateChanged :" + state)}

    onClickOrKeySelected: {}
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: backGround; source: bgImagePress;}
            PropertyChanges {target: imgFgImage; source: fgImagePress;}
            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
            PropertyChanges {target: txtThirdText; color: thirdTextPressColor;}
        },
        State {
            name: 'active'; when: container.active
            PropertyChanges {target: backGround; source: bgImageActive;}
            PropertyChanges {target: imgFgImage; source: fgImageActive;}
            PropertyChanges {target: txtFirstText; color: firstTextSelectedColor;}
            PropertyChanges {target: txtSecondText; color: secondTextSelectedColor;}
            PropertyChanges {target: txtThirdText; color: thirdTextSelectedColor;}
        },
        State {
            name: 'keyPress';
            PropertyChanges {target: backGround; source: bgImageFocusPress;}
            PropertyChanges {target: imgFgImage; source: fgImageFocusPress;}
            PropertyChanges {target: txtFirstText; color: firstTextFocusPressColor;}
            PropertyChanges {target: txtSecondText; color: secondTextFocusPressColor;}
            PropertyChanges {target: txtThirdText; color: thirdTextFocusPressColor;}
        },
        State {
            name: 'keyReless';
            PropertyChanges {target: backGround; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: txtFirstText; color: firstTextColor;}
            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
            PropertyChanges {target: txtThirdText; color: thirdTextPressColor;}
        },
        State {
            name: 'dimmed'; when: container.dimmed
            PropertyChanges {target: txtFirstText; color: firstDimmedTextColor;}
            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
            PropertyChanges {target: txtThirdText; color: thirdTextPressColor;}
        }
    ]

}
