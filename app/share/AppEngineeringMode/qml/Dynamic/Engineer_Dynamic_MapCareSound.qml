import QtQuick 1.0
import Qt.labs.gestures 2.0
import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MComponent{
    id:idDynamicMapCareSoundMain
    x:0; y:0;
    width: 1280
    height:640
    clip: true
    focus:true
    MSystem.ImageInfo { id: imageInfo }
    MSystem.ColorInfo { id: colorInfo }


    MComp.MBand{
        id:soundBand
        titleText: qsTr("Dealer Mode > Dynamics > Sound")
        y:0
        onBackKeyClicked: {

            //added for BGFG structure
            if(isMapCareEx)
            {
                mainBg.visible = false
                mainViewState="MapCareMainEx"
                setMapCareUIScreen("", true)
                mainViewState = "Dynamics"
                setMapCareUIScreen("Dynamics", false)
                UIListener.Dynamic_SOUND_FG(0)
                mainBg.visible = true
            }
            else
            {
                mainBg.visible = false
                mainViewState="MapCareMain"
                setMapCareUIScreen("", true)
                mainViewState = "Dynamics"
                setMapCareUIScreen("Dynamics", false)
                UIListener.Dynamic_SOUND_FG(0)
                mainBg.visible = true
            }
            //added for BGFG structure


        }
    }

    Component.onCompleted:{
        soundBand.backKeyButton.forceActiveFocus()
        UIListener.autoTest_athenaSendObject();
    }
    onBackKeyPressed: {
        //added for BGFG structure
        if(isMapCareEx)
        {
            mainBg.visible = false
            mainViewState="MapCareMainEx"
            setMapCareUIScreen("", true)
            mainViewState = "Dynamics"
            setMapCareUIScreen("Dynamics", false)
            UIListener.Dynamic_SOUND_FG(0)
            mainBg.visible = true
        }
        else
        {
            mainBg.visible = false
            mainViewState="MapCareMain"
            setMapCareUIScreen("", true)
            mainViewState = "Dynamics"
            setMapCareUIScreen("Dynamics", false)
            UIListener.Dynamic_SOUND_FG(0)
            mainBg.visible = true
        }
        //added for BGFG structure

    }
    Engineer_Dynamic_SoundListView{
        x:18; y:100;
        width: 1200; height: 540
        id:idSoundListView
    }
}

