import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MComponent{
    id:idDynamicSoundMain
    x:0; y:0;
    width: 1280
    height:640
    clip: true
    focus:true
    MSystem.ImageInfo { id: imageInfo }
    MSystem.ColorInfo { id: colorInfo }
    property int variantValue: VariantSetting.variantInfo

    MComp.MBand{
        id:soundBand
        titleText: qsTr("Engineering Mode > Dynamics > Sound")
        y:0
        onBackKeyClicked: {
            mainBg.visible = false
            mainViewState="Main"
            setMainAppScreen("", true)
            mainViewState = "Dynamics"
            setMainAppScreen(variantString, false)
            UIListener.Dynamic_SOUND_FG(0)
            mainBg.visible = true
        }
    }

    Component.onCompleted:{
        if(variantValue == 0){
            variantString = "DynamicKo"
        }
        else if(variantValue == 1){
            variantString = "DynamicUS"
        }
        else if(variantValue == 5){
            variantString = "DynamicEU"
        }
        else if(variantValue == 6){
            variantString = "DynamicCA"
        }
        else if(variantValue == 7)
        {
            variantString = "DynamicRUS"
        }

        else{
            variantString = "DynamicGE"
        }
        soundBand.backKeyButton.forceActiveFocus()
        UIListener.autoTest_athenaSendObject();
    }
    onBackKeyPressed: {
        mainBg.visible = false
        mainViewState="Main"
        setMainAppScreen("", true)
        mainViewState = "Dynamics"
        setMainAppScreen(variantString, false)
        UIListener.Dynamic_SOUND_FG(0)
        mainBg.visible = true
    }
    Engineer_Dynamic_SoundListView{
        x:18; y:100;
        width: 1200; height: 540
        id:idSoundListView
    }

    //    ListModel{
    //        id:idDynamicSoundData
    //        ListElement {   name:"Loudness(LD)";    }
    //        ListElement {   name:"Bass/Mid/Treble"; }
    //        ListElement {   name:"Fader/Balance";   }
    //        ListElement {   name:"Quantum Logic";   }
    //        ListElement {   name: "SDVC"    ; }
    //        ListElement {   name:   "TA Volume";    }
    //        ListElement {   name:   "Phone Volume"  }
    //        ListElement {   name:   "Navi Volume"   }
    //        ListElement {   name:   "Dynamic High Cut"  }
    //        ListElement {   name:   "AVC monitoring"    }
    //    }

    //    ListView{
    //        x:18; y:150;
    //        id:idDynamicSoundView
    //        opacity:  1
    //        clip:  true
    //        focus:  true
    //        anchors.fill: parent
    //        model:idDynamicSoundData
    //        delegate: Engineer_DynamicSoundDelegate{
    //            onWheelLeftKeyPressed:idDynamicSoundView.decrementCurrentIndex()
    //            onWheelRightKeyPressed: idDynamicSoundView.incrementCurrentIndex()
    //        }
    //        orientation : ListView.Vertical
    //        highlightMoveSpeed: 9999999
    //    }
    //    //--------------------- ScrollBar #
    //    MComp.MScroll {
    //        property int  scrollWidth: 13
    //        property int  scrollY: 5
    //        x:systemInfo.lcdWidth -20; y:idTotalChList.y+scrollY; z:1
    //        scrollArea: idDynamicSoundView;
    //        height: idDynamicSoundView.height-(scrollY*2)-8; width: scrollWidth
    ////        anchors.right: idHeadUnitView.right
    //        visible: true
    //    } //# End MScroll

}
