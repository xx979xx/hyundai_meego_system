import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComp.MEngChListDelegate {
    id: idENGDelegate

    mChListFirstText: index+1
    mChListSecondText: label

//    onClickOrKeySelected: {
//        if(pressAndHoldFlag == false){
//            console.log("!!!!!!!!!!!!!!!  [DmbChListDelegate] onClickOrKeySelected :" + mChListSecondText)

//            if(CommParser.m_iPresetListIndex == index)
//            {
//                return
//            }
//            else
//            {
//                CommParser.m_iPresetListIndex = index

//                CommParser.onChannelSelectedByIndex(CommParser.m_iPresetListIndex, false, false);

//                // WSH(130122) ====================== START
//                if(idDmbENGModeList.currentItem){
//                    idDmbENGModeList.currentItem.forceActiveFocus()
//                } // End If
//                if(idDmbENGModeList.count > 0) {
//                    idDmbENGModeList.positionViewAtIndex (CommParser.m_iPresetListIndex, ListView.Visible)
//                } // End If
//                // WSH(130122) ====================== END
//            }
//        }
//    }
} // End MChListDelegate

