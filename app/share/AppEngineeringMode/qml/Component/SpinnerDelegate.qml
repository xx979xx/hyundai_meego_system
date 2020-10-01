import QtQuick 1.0

import "../System" as MSystem

MComponent {
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id:colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    focus: true
    id:rect
    //x:parent.x +180
    width:200; height: itemHeight
    property string imgFolderSpinner: imageInfo.imgFolderSpinner
    property alias bgSize: bgImg.width
    //property alias leftFocus: leftButton
    //property string imgFolderSpinner: imageInfo.imgFolderSpinner

    Component.onCompleted:{
        //leftButton.forceActiveFocus()
    }

    Image {
        id:bgImg

        source: imgFolderSpinner + "bg_spin_ctrl.png"
        width: 200; height:itemHeight

    }
    Text {
        id:bgShadow
        anchors.centerIn: bgImg
        text: name;
        color: colorInfo.black
        font.pixelSize: 36
        font.family: UIListener.getFont(false)//"HDR"
    }
    Text {
        x: bgShadow.x+1
        y: bgShadow.y+1
        text: name;
        color: colorInfo.brightGrey
        font.pixelSize: 36
        font.family: UIListener.getFont(false)//"HDR"
    }


//        bgImageActive: imgFolderGeneral+"bg_menu_tab_l_s.png"

//            Image {
//                id: btn_l
//                x:0
//                height: 68
//                width: 75
//                source: imgFolderSpinner + "btn_arrow_l_n.png"
//                smooth: true
//                MouseArea{
//                    anchors.fill: btn_l
//                    onPressed:btn_l.source= imgFolderSpinner + "btn_arrow_l_p.png"
//                    onReleased:btn_l.source= imgFolderSpinner + "btn_arrow_l_n.png"
//                    onClicked: {
//                        if(spinner.currentIndex != 0)
//                            spinner.decrementCurrentIndex()
//                        else
//                            spinner.currentIndex = itemCount -1
//                    }
//                }
//            }
//    }
//    Image {
//        id: btn_r
//        x:itemWidth-75
//        height: 68
//        width: 75
//        source: imgFolderSpinner + "btn_arrow_r_n.png"
//        smooth: true
//        MouseArea{
//            anchors.fill: btn_r
//            onPressed:btn_r.source= imgFolderSpinner + "btn_arrow_r_p.png"
//            onReleased:btn_r.source= imgFolderSpinner + "btn_arrow_r_n.png"
//            onClicked: {
//                if(spinner.currentIndex < itemCount-1)
//                    spinner.incrementCurrentIndex()
//                else
//                    spinner.currentIndex = 0
//            }
//        }
//    }
}

