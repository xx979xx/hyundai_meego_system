import Qt 4.7
import "../Component" as MComp

MComp.MComponent {
    id: idENGDeletePopup
    x: 0; y: 93
    width: 1280; height: 720 - 93
    focus:true
    property alias popupDeleting: idMostReset.visible
    MComp.DimPopUp{
        id:idMostReset
        textLineCount: 1
        loadingFlag: false
        firstText: "Emitted the MOST reseting."

        visible:false
        onPopupClicked: {
        }
        onVisibleChanged:{ if(visible) idTimerMostReset.start() }
    }
    Timer{
        id:idTimerMostReset
        interval: 1000
        repeat:false
        onTriggered:
        {
            idMostReset.visible = false
            idENGMostResetPopUp.visible =false
            idDiagnosisRightList.forceActiveFocus()

        }
    }
}
