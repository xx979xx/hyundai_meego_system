import Qt 4.7
import "../Component" as MComp

MComp.MComponent {
    id: idENGMostPopUp
    x: 0; y: 93
    width: 1280; height: 720-93
    focus:true
    property alias popupRequest: idDlgMostRequest.visible
    property alias popupRequestFin: idDlgMostRequestFin.visible
    //property alias popupMessage_1: idDlgMostRequest.messages1
    //property alias popupMessage_2: idDlgMostRequestFin.messages1

    function givePopupFocus(popupName)
    {
        if(popupRequest){
            idDlgMostRequest.focus = true
            idDlgMostRequest.forceActiveFocus()
        }
        else if(popupRequestFin){
            idDlgMostRequestFin.focus = true
            idDlgMostRequestFin.forceActiveFocus()
        }

    }
    MComp.DimPopUp{
        id:idDlgMostRequest
        textLineCount: 1
        loadingFlag: true
        firstText: "Processing..."

        visible:true

        onVisibleChanged:{ if(visible) idTimerRequest.start() }
    }
    Timer{
        id:idTimerRequest
        interval: 12000
        repeat:false
        onTriggered:
        {
            idDlgMostRequest.visible = false
            idDlgMostRequestFin.visible = true
            idDlgMostRequestFin.focus = true
            givePopupFocus()
            //idDlgMostRequestFin.givePopupFocus()

        }
    }

    MComp.DimPopUp{
        id:idDlgMostRequestFin
        textLineCount:1
        loadingFlag:false
        firstText: "Diagnostic Failed"

        visible:  false

        onVisibleChanged: { if(visible) idTimerRequestFin.start() }
    }
    Timer{
        id:idTimerRequestFin
        interval: 1000
        repeat:  false
        onTriggered:
        {
            idDlgMostRequestFin.visible = false
            idDiagProcessing.visible =false

        }
    }

}
