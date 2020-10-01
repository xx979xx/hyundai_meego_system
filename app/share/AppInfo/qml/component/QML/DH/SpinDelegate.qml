import QtQuick 1.0

import "../../system/DH" as MSystem

Item {
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id:colorInfo }
    MSystem.ImageInfo { id: imageInfo }

    id:rect
    width:itemWidth; height: itemHeight
    property string imgFolderAutocare: imageInfo.imgFolderAutocare
    property string imgFolderSettings: imageInfo.imgFolderSettings
    property string focusImg : ""

    Image {
        id:bgImg
        x:0
        source: imgFolderAutocare + "bg_info_spin_ctrl.png"
        width: itemWidth; height:itemHeight
    }
    BorderImage {
        id: focusImage
        source: focusImg;
        smooth: true

        x: -12; y:-12; z:1
        width:parent.width + 24; height: parent.height +24
        border.left: 20; border.top: 20
        border.right: 20; border.bottom: 20
        visible: container.activeFocus
    } // End BorderImage

    Text {
        id:bgShadow
        anchors.centerIn: bgImg
        text: name;
        color: colorInfo.black

        font {
            pixelSize: 36;
            family: "HDR"
        }
    }
    Text {
        id:bgText
        x: bgShadow.x+1
        y: bgShadow.y+1
        text: name;
        color: colorInfo.brightGrey

        font {
            pixelSize: 36;
            family: "HDR"
        }
    }
    Image {
        id: btnLeft
        x:0
        height: 68
        width: 81
        source: imgFolderSettings + "btn_arrow_l_n.png"
        smooth: true
        MouseArea{
            anchors.fill: btnLeft
            onPressed:btnLeft.source= imgFolderSettings + "btn_arrow_l_p.png"
            onReleased:btnLeft.source= imgFolderSettings + "btn_arrow_l_n.png"
            onClicked: {
                if(spinListView.currentIndex != 0)
                    spinListView.decrementCurrentIndex()
                else
                    spinListView.currentIndex = itemCount -1
            }
        }
    }
    Image {
        id: btnRight
        x:itemWidth-81
        height: 68
        width: 81
        source: imgFolderSettings + "btn_arrow_r_n.png"
        smooth: true
        MouseArea{
            anchors.fill: btnRight
            onPressed:btnRight.source=imgFolderSettings + "btn_arrow_r_p.png"
            onReleased:btnRight.source= imgFolderSettings + "btn_arrow_r_n.png"
            onClicked: {

                if(spinListView.currentIndex < itemCount-1)
                    spinListView.incrementCurrentIndex()
                else
                    spinListView.currentIndex = 0
            }
        }
    }
}
