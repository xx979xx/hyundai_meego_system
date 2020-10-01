import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComp.MChListDelegate {
    id: idDmbChListDelegate

    firstText: index+1
    secondText: label
    secondTextScrollEnable: ( (idDmbChListDelegate.secondTextOverPaintedWidth == true) && (idDmbChListDelegate.activeFocus == true)
                              && (idAppMain.drivingRestriction == false) ) ? true : false

    onClickOrKeySelected: {

        if(pressAndHoldFlag == false){
            // DmbPlayer
            if(!presetEditEnabled){

                if(CommParser.m_iPresetListIndex == index)
                {

                    if(CommParser.m_bIsFullScreen == true)
                    {
                        CommParser.m_bIsFullScreen = false;
                    }
                    else if(CommParser.m_bIsFullScreen == false)
                    {
                        CommParser.m_bIsFullScreen = true;
                    }
                    if(idAppMain.isOnclickedByTouch == true)
                        idAppMain.dmbListPageInit(CommParser.m_iPresetListIndex);
                }
                else
                {
                    CommParser.m_iPresetListIndex = index

                    CommParser.onChannelSelectedByIndex(CommParser.m_iPresetListIndex, false, false);
                }

                if(idAppMain.inputModeDMB == "touch")
                {
                    EngineListener.changePresetListContentY(idPresetChList.contentY);
                }
            }
            // Preset Order
            //else{ return; } // End if
        }
        idAppMain.isOnclickedByTouch = false;
    } // End onClickOrKeySelected

    onChangeRow: {
//        console.log("########################### onChangeRow : ListView ###########################")
        CommParser.HandleChangePresetOrder(fromIndex, toIndex);
    } // End onChangeRow


    Connections{
        //target: idDmbPlayerMain
        target: idAppMain
        onSignalScrollTextTimerOn: {
            var resetTextScroll = false;

            if(presetEditEnabled){
                if(idDmbChListDelegate.ListView.view.currentIndex == index)
                    resetTextScroll = true;
            }else{
                if(CommParser.m_iPresetListIndex == index)
                    resetTextScroll = true;
            }

            if(idAppMain.state == "AppDmbPlayer" && resetTextScroll == true)
            {
                if( (idDmbChListDelegate.secondTextOverPaintedWidth == true) && (idDmbChListDelegate.activeFocus == true) && (idAppMain.drivingRestriction == false) )
                    secondTextScrollEnable = true;
            } // End If
        }
        onSignalScrollTextTimerOff: {
            var resetTextScroll = false;

            if(presetEditEnabled){
                if(idDmbChListDelegate.ListView.view.currentIndex == index)
                    resetTextScroll = true;
            }else{
                if(CommParser.m_iPresetListIndex == index)
                    resetTextScroll = true;
            }

            if(idAppMain.state == "AppDmbPlayer" && resetTextScroll == true)
            {
                if( (secondTextScrollEnable == true) && (idDmbChListDelegate.secondTextOverPaintedWidth == true) && (idDmbChListDelegate.activeFocus == true))
                    secondTextScrollEnable = false;
            } // End If
        }
    }

} // End MComp.MChListDelegate
