import Qt 4.7
import "../Component" as MComp

MComp.MComponent {
    id: idENGDeletePopup
    x: 0; y: 93
    width: 1280; height: 720 - 93
    focus:true

    property alias popupDeleting: idDlgDeleting.visible
    property alias popupDeletingFin: idDlgDeletingFin.visible
    //    property alias popupMessage_1: idDlgDeleting.messages1
    //    property alias popupMessage_2: idDlgDeletingFin.messages1

    function givePopupFocus(popupName)
    {
        if(popupDeleting){
            idDlgDeleting.focus = true
            idDlgDeleting.forceActiveFocus()
        }
        else if(popupDeletingFin){
            idDlgDeletingFin.focus = true
            idDlgDeletingFin.forceActiveFocus()
        }

    }
    MComp.DimPopUp{
        id:idDlgDeleting
        textLineCount: 1
        loadingFlag: true
        firstText: "Deleting ..."

        visible:false
        onPopupClicked: {
        }
        onVisibleChanged:{ if(visible) idTimerDeleting.start() }
    }
    Timer{
        id:idTimerDeleting
        interval: 3000
        repeat:false
        onTriggered:
        {
            idDlgDeleting.visible = false
            idDlgDeletingFin.visible = true
            idDlgDeletingFin.focus = true
            givePopupFocus()

        }
    }

    MComp.DimPopUp{
        id:idDlgDeletingFin
        textLineCount:1
        loadingFlag:false
        firstText: "Deleting Finished"
        popupName: "Deleting Finished"
        onPopupClicked: {
        }

        visible:  false

        onVisibleChanged: { if(visible) idTimerDeletingFin.start() }
    }
    Timer{
        id:idTimerDeletingFin
        interval: 1000
        repeat:  false
        onTriggered:
        {
            idDlgDeletingFin.visible = false
            idENGDeletePopUp.visible = false
            idDiagnosisRightList.forceActiveFocus()
        }
    }





}

