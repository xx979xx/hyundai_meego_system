/**
 * FileName: Case_E_Warning.qml
 * Author: David.Bae
 * Time: 2012-05-14 17:10
 *
 * - 2012-05-14 Initial Created by David
 */
import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../../component/XMData" as XMData

MComp.MComponent{
    id:container
    property string detailText1:"";
    property string detailText2:"";
    property bool btDuringCall: false;
    property alias popupLineCnt: idCaseEWarningPopup.popupLineCnt

    signal close();

    // function Descirption

    MComp.MPopupTypeText{
        id: idCaseEWarningPopup

        popupBtnCnt: 1
        popupLineCnt: 2
        btDuringCallWidth : btDuringCall

        popupFirstText: detailText1
        popupSecondText: detailText2
        popupFirstBtnText: stringInfo.sSTR_XMDATA_OK

        onPopupFirstBtnClicked: {
            close();
        }
        onHardBackKeyClicked: {
            close();
        }
    }
    Connections{
        target:UIListener
        onTemporalModeMaintain:{
            if(!mbTemporalmode)
            {
                if(visible)
                    close();
            }
        }

        onSignalShowSystemPopup:{
            console.log("onSignalShowSystemPopup")
            if(visible)
                close();
        }
    }
}
