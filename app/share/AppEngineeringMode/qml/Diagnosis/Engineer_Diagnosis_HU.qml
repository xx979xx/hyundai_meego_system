import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

    MComp.MButton{
        id:idCPUDegreeButton
        width: 537
        height:89
        x:0
        y:40
        focus: true
        bgImageFocusPress: imgFolderGeneral+"bg_menu_tab_l_fp.png"
        bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"

        firstText : "CPU Degree"
        firstTextX: 20
        firstTextY: 43
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 25
        firstTextStyle:"HDB"
        firstTextWidth: 260

        secondText: ""
        secondTextX: 280
        secondTextY: 43
        secondTextSize:20
        secondTextColor:  colorInfo.dimmedGrey
        secondTextSelectedColor: focusImageVisible?  colorInfo.brightGrey : "#7CBDFF" //RGB(124, 189, 255)
        secondTextFocusColor: colorInfo.brightGrey
        secondTextStyle: "HDB"
        secondTextWidth: 403

        KeyNavigation.up:{

                  backFocus.forceActiveFocus()
                  diagnosisBand

            }

        Connections {
            target: CpuDegree
            onSetDegree:
            {
                console.log("CPU DEGREE : " + degree)
                idCPUDegreeButton.secondText = degree;
            }
        }
        Image{
            x:20
            y:100
            source: imgFolderGeneral+"line_menu_list.png"
        }
        Component.onCompleted:{
            CpuDegree.startGetDegree();
            UIListener.autoTest_athenaSendObject();
        }

    }





