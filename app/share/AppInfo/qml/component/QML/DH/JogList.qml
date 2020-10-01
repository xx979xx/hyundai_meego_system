import QtQuick 1.0
import "../../system/DH" as MSystem
//import "../../Dmb" as MList

Rectangle {
    id:jogMainList
    width: 470
    height: 554
    MSystem.ColorInfo{id:colorInfo}
    MSystem.ImageInfo{id:imageInfo}
    property string imageFolderRadio: imageInfo.imgFolderRadio
    //property int focusSub: 1
    property int selectButton: 1
    property string focusButton: "jogListButton"+focusSub
    property int sg: 1


    color: colorInfo.transparent

    MList.DmbChannelList {id:channelListModel}
    Image{
        source:imageFolderRadio+"bg_preset_03.png"
    }
    Column{
        y:4
        x:17
        spacing: 0

        /**1 List*//////////////////////////

        Button{
            id:jogListButton1
            buttonName: "jogListButton"+selectButton
            width:417
            height: 78
            bgImage:imageFolderRadio+"btn_preset_jog_01_n.png"
            bgImagePressed:imageFolderRadio+"btn_preset_jog_01_s.png"
            active:activeButton==buttonName
            Rectangle{
                x:19
                y:41-18-4
                width: 39
                height:36
                color: colorInfo.transparent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: listIndex+1
                    font.family: "HDR"
                    font.pixelSize: 36
                    color:jogListButton1.active ?"black":colorInfo.brightGrey
                }
            }
            Image {
                x:68
                y:7
                source: jogListButton1.active ? imageFolderRadio+"preset_divider_s.png":imageFolderRadio+"preset_divider_n.png"
            }
            Rectangle{
                x:19+39+24
                y:41-18-4
                width: 290
                height:36
                color: colorInfo.transparent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    text:channelListModel.channelList
                    font.family: "HDR"
                    font.pixelSize: 36
                    color:jogListButton1.active ?"black":colorInfo.brightGrey
                }
            }
            Image{
                x:-5
                y:-6
                visible: parent.buttonName == focusButton
                source:imageFolderRadio+"bg_preset_jog_01_f.png"
            }
            onClicked: {
                activeButton="jogListButton1"
            }
        }

        /**2 List*//////////////////////////

        Button{
            id:jogListButton2
            buttonName: "jogListButton2"
            width:417
            height: 78
            bgImage:imageFolderRadio+"btn_preset_jog_02_n.png"
            bgImagePressed:imageFolderRadio+"btn_preset_jog_02_s.png"
            active: activeButton==buttonName
            Rectangle{
                x:19
                y:41-18-4
                width: 39
                height:36
                color: colorInfo.transparent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: listIndex+2
                    font.family: "HDR"
                    font.pixelSize: 36
                    color:jogListButton2.active ?"black":colorInfo.brightGrey
                }
            }
            Image {
                x:68
                y:7
                source: jogListButton2.active ? imageFolderRadio+"preset_divider_s.png":imageFolderRadio+"preset_divider_n.png"
            }
            Rectangle{
                x:19+39+24
                y:41-18-4
                width: 290
                height:36
                color: colorInfo.transparent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    text: channelListModel.channelList+listIndex+1
                    font.family: "HDR"
                    font.pixelSize: 36
                    color:jogListButton2.active ?"black":colorInfo.brightGrey
                }
            }
            Image{
                x:-5
                y:-6
                visible: parent.buttonName == focusButton
                source:imageFolderRadio+"bg_preset_jog_02_f.png"
            }
            onClicked: {
                activeButton="jogListButton2"
            }
        }

        /**3 List*//////////////////////////

        Button{
            id:jogListButton3
            buttonName: "jogListButton3"
            width:417
            height: 78
            bgImage:imageFolderRadio+"btn_preset_jog_03_n.png"
            bgImagePressed:imageFolderRadio+"btn_preset_jog_03_s.png"
            active:activeButton==buttonName
            Rectangle{
                x:19
                y:41-18-4
                width: 39
                height:36
                color: colorInfo.transparent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: listIndex+3
                    font.family: "HDR"
                    font.pixelSize: 36
                    color:jogListButton3.active ?"black":colorInfo.brightGrey
                }
            }
            Image {
                x:68
                y:7
                source: jogListButton3.active ? imageFolderRadio+"preset_divider_s.png":imageFolderRadio+"preset_divider_n.png"
            }
            Rectangle{
                x:19+39+24
                y:41-18-4
                width: 290
                height:36
                color: colorInfo.transparent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    text: channelListModel.channelList+listIndex
                    font.family: "HDR"
                    font.pixelSize: 36
                    color:jogListButton3.active ?"black":colorInfo.brightGrey
                }
            }
            Image{
                x:-5
                y:-6
                visible: parent.buttonName == focusButton
                source:imageFolderRadio+"bg_preset_jog_03_f.png"
            }
            onClicked: {
                activeButton="jogListButton3"
            }
        }

        /**4 List*//////////////////////////

        Button{
            id:jogListButton4
            buttonName: "jogListButton4"
            width:417
            height: 78
            bgImage:imageFolderRadio+"btn_preset_jog_04_n.png"
            bgImagePressed:imageFolderRadio+"btn_preset_jog_04_s.png"
            active:activeButton==buttonName
            Rectangle{
                x:19
                y:41-18-4
                width: 39
                height:36
                color: colorInfo.transparent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: listIndex+4
                    font.family: "HDR"
                    font.pixelSize: 36
                    color:jogListButton4.active ?"black":colorInfo.brightGrey
                }
            }
            Image {
                x:68
                y:7
                source: jogListButton4.active ? imageFolderRadio+"preset_divider_s.png":imageFolderRadio+"preset_divider_n.png"
            }
            Rectangle{
                x:19+39+24
                y:41-18-4
                width: 290
                height:36
                color: colorInfo.transparent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    text: "1"
                    font.family: "HDR"
                    font.pixelSize: 36
                    color:jogListButton4.active ?"black":colorInfo.brightGrey
                }
            }
            Image{
                x:-5
                y:-6
                visible: parent.buttonName == focusButton
                source:imageFolderRadio+"bg_preset_jog_04_f.png"
            }
            onClicked: {
                activeButton="jogListButton4"
            }
        }

        /**5 List*//////////////////////////

        Button{
            id:jogListButton5
            buttonName: "jogListButton5"
            width:417
            height: 78
            bgImage:imageFolderRadio+"btn_preset_jog_05_n.png"
            bgImagePressed:imageFolderRadio+"btn_preset_jog_05_s.png"
            active:activeButton==buttonName
            Rectangle{
                x:19
                y:41-18-4
                width: 39
                height:36
                color: colorInfo.transparent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: listIndex+5
                    font.family: "HDR"
                    font.pixelSize: 36
                    color:jogListButton5.active ?"black":colorInfo.brightGrey
                }
            }
            Image {
                x:68
                y:7
                source: jogListButton5.active ? imageFolderRadio+"preset_divider_s.png":imageFolderRadio+"preset_divider_n.png"
            }
            Rectangle{
                x:19+39+24
                y:41-18-4
                width: 290
                height:36
                color: colorInfo.transparent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    text: "1"

                    font.family: "HDR"
                    font.pixelSize: 36
                    color:jogListButton5.active ?"black":colorInfo.brightGrey
                }
            }
            Image{
                x:-5
                y:-6
                visible: parent.buttonName == focusButton
                source:imageFolderRadio+"bg_preset_jog_05_f.png"
            }
            onClicked: {
                activeButton="jogListButton5"
            }
            Image{
                x:-5
                y:-6
                visible: parent.buttonName == focusButton
                source:imageFolderRadio+"bg_preset_jog_05_f.png"
            }
        }
        Button{
            id:jogListButton6
            buttonName: "jogListButton6"
            width:417
            height: 78
            bgImage:imageFolderRadio+"btn_preset_jog_06_n.png"
            bgImagePressed:imageFolderRadio+"btn_preset_jog_06_s.png"
            active:activeButton==buttonName
            Rectangle{
                x:19
                y:41-18-4
                width: 39
                height:36
                color: colorInfo.transparent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: listIndex+6
                    font.family: "HDR"
                    font.pixelSize: 36
                    color:jogListButton6.active ?"black":colorInfo.brightGrey
                }
            }
            Image {
                x:68
                y:7
                source: jogListButton6.active ? imageFolderRadio+"preset_divider_s.png":imageFolderRadio+"preset_divider_n.png"
            }
            Rectangle{
                x:19+39+24
                y:41-18-4
                width: 290
                height:36
                color: colorInfo.transparent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    text: "1"
                    font.family: "HDR"
                    font.pixelSize: 36
                    color:jogListButton6.active ?"black":colorInfo.brightGrey
                }
            }
            Image{
                x:-5
                y:-6
                visible: parent.buttonName == focusButton
                source:imageFolderRadio+"bg_preset_jog_06_f.png"
            }
            onClicked: {

                activeButton="jogListButton6"

            }
        }

        /**7 List*//////////////////////////

        Button{
            id:jogListButton7
            buttonName: "jogListButton7"
            width:417
            height: 78
            bgImage:imageFolderRadio+"btn_preset_jog_07_n.png"
            bgImagePressed:imageFolderRadio+"btn_preset_jog_07_s.png"
            active:activeButton==buttonName
            Rectangle{
                x:19
                y:41-18-4
                width: 39
                height:36
                color: colorInfo.transparent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: listIndex+7
                    font.family: "HDR"
                    font.pixelSize: 36
                    color:jogListButton7.active ?"black":colorInfo.brightGrey
                }
            }
            Image {
                x:68
                y:7
                source: jogListButton7.active ? imageFolderRadio+"preset_divider_s.png":imageFolderRadio+"preset_divider_n.png"
            }
            Rectangle{
                x:19+39+24
                y:41-18-4
                width: 290
                height:36
                color: colorInfo.transparent
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    text: "1"

                    font.family: "HDR"
                    font.pixelSize: 36
                    color:jogListButton7.active ?"black":colorInfo.brightGrey
                }
            }
            Image{
                x:-5
                y:-6
                visible: parent.buttonName == focusButton
                source:imageFolderRadio+"bg_preset_jog_07_f.png"
            }
            onClicked: {
                activeButton="jogListButton7"
            }
        }
    }
}
