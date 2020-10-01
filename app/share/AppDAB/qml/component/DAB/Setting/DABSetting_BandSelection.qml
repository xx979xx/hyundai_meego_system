/**
 * FileName: DABSetting_BandSelection.qml
 * Author: DaeHyungE
 * Time: 2012-07-19
 *
 * - 2012-07-19 Initial Crated by HyungE
 * - 2013-03-21 UX Change (20130320 Document)
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent {
    id : idDabSetting_BandSelection
    focus: true

    property int m_iBandSelection : DABListener.m_iBandSelection;

    Component.onCompleted: {
        console.log("[QML] DABSetting_BandSelection.qml : Component.onCompleted")
        stringNameSetting();
        if((m_iBandSelection == 2)){ idBandSelectionList.currentIndex = 1 }
        else{ idBandSelectionList.currentIndex = 0 }
    }

    ListModel {
        id : idBandSelectionModel     
        ListElement { name: "BandIII";}             //value 2
        ListElement { name: "BandIII + L-Band";}    //value 1
    }

    MComp.MListView {
        id : idBandSelectionList
        x: 699 - settingViewAreaX; y: 6;
        width: 547
        height: 272
        focus : true     
        boundsBehavior : Flickable.StopAtBounds
        highlightMoveSpeed : 9999999
        model : idBandSelectionModel
        delegate : idBandSelectionDelegateComponent
        onActiveFocusChanged: { //focus move at radioButton Off
            if((m_iBandSelection == 2)){ idBandSelectionList.currentIndex = 1 }
            else{ idBandSelectionList.currentIndex = 0 }
        }
    }

    Component {
        id : idBandSelectionDelegateComponent

        MComp.MButton {
            id : idBandSelectionDelegate
            width: 547
            height: 89
            bgImagePress : imageInfo.imgBgMenu_Tab_R_P           
            bgImageFocus : imageInfo.imgBgMenu_Tab_R_F

            active : false
            firstText : name
            firstTextX : 20
            firstTextY : 47
            firstTextWidth : 443
            firstTextColor : colorInfo.brightGrey
            firstTextSize : 40
            firstTextStyle :idAppMain.fonts_HDR
            firstTextScrollEnable: (m_bIsDrivingRegulation == false) && (idBandSelectionDelegate.activeFocus) ? true : false

            lineImage: imageInfo.imgLineMenuList
            lineImageX: 0
            lineImageY: 90

            Image {
                id : idUnchecked
                x : 9 + 14 + 443 + 16; y : 22
                source : imageInfo.imgIco_radio_N
            }

            Image {
                id : idChecked
                anchors.fill : idUnchecked
                source : imageInfo.imgIco_radio_S
                visible:  (index == 0) ? m_iBandSelection == 2 : m_iBandSelection == 1 // (index+1) == m_iBandSelection
            }

            onClickOrKeySelected: {
                console.log("[QML] DABSetting_BandSelection.qml : onClickOrKeySelected");
                idBandSelectionDelegate.focus = true
                idBandSelectionDelegate.forceActiveFocus();
                idBandSelectionDelegate.ListView.view.currentIndex = index
                m_iBandSelection = index
                if(index == 0){ selectBand(2); }
                else{ selectBand(1); }
            }

            onWheelLeftKeyPressed:{
                console.log("[QML] DABSetting_BandSelection.qml : onWheelLeftKeyPressed : index = " + idBandSelectionDelegate.ListView.view.currentIndex + " count = " + idBandSelectionDelegate.ListView.view.count);
                if( idBandSelectionDelegate.ListView.view.currentIndex )
                {
                    idBandSelectionDelegate.ListView.view.decrementCurrentIndex();
                }
            }

            onWheelRightKeyPressed: {
                console.log("[QML] DABSetting_BandSelection.qml : onWheelRightKeyPressed : index = " + idBandSelectionDelegate.ListView.view.currentIndex + " count = " + idBandSelectionDelegate.ListView.view.count);
                if( idBandSelectionDelegate.ListView.view.count-1 != idBandSelectionDelegate.ListView.view.currentIndex )
                {
                    idBandSelectionDelegate.ListView.view.incrementCurrentIndex();
                }
            }

            Keys.onUpPressed: { // Set focus for Band
                event.accepted = true;
                return;
            } // End onUpPressed
            Keys.onDownPressed:{ // No Movement
                event.accepted = true;
                return;
            } // End onDownPressed

            onUpKeyReleased: {
                if(idAppMain.upKeyReleased == true){
                    idDabSettingBand.focus = true
                }
                idAppMain.upKeyReleased  = false;
            }

        }
    }

    Text{
        id: idTextBandSelection
        x: 722 - settingViewAreaX; y: 457 - systemInfo.headlineHeight - 32/2// - 90
        width: 510; height: 182
        text: stringInfo.strSettingBandSelection_Description// + " :\n" + stringInfo.strSettingBandSelection_BandIII + " : " + "174-240 MHz\n" + stringInfo.strSettingBandSelection_LBand + " : " + "1452-1492 MHz"
        color: colorInfo.dimmedGrey
        font.family: idAppMain.fonts_HDR
        font.pixelSize: 32
        verticalAlignment: Text.AlignLeft
        wrapMode: Text.Wrap
    }

    //******************************# Connetions
    Connections {
        target: UIListener
        onRetranslateUi:
        {
            console.log("[QML] DABSetting_BandSelection.qml : onRetranslateUi");
            stringNameSetting();
        }
    }

    // mseok.lee
    Connections {
        target : AppComUIListener
        onRetranslateUi: {
            console.log("[QML] DABSetting_BandSelection.qml : AppComUIListener::onRetranslateUi");
            stringNameSetting();
        }
    }

    //******************************# Function
    function stringNameSetting()
    {
        var names = [stringInfo.strSettingBandSelection_BandIII,
                     stringInfo.strSettingBandSelection_BandIII_LBand
            ];

        var count = idBandSelectionModel.count;

        for(var i = 0; i < count; i++){
            idBandSelectionModel.get(i).name = names[i];
        }
    }

    function selectBand(value)
    {
        console.log("[QML] DABSetting_BandSelection.qml : selectBand : m_iBandSelection = " + m_iBandSelection + "  value = " + value)
        //        if(m_iBandSelection == value) return;
        m_iBandSelection = value;
        MDabOperation.CmdSettingBandSelection(value);
    }
}

