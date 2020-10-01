import Qt 4.7
import "../../../QML/DH" as MComp
import "../../../../component/Radio/RDS" as MRadio

//MComp.MPopupTaTypeText {
    MComp.MPopupTypeTextRDS {
    id : idRadioRDSPopupTA

    MRadio.RadioRdsStringInfo{ id: stringInfo }

    property string strHTML1 : "<center><span style='font-size:50pt'; style='color:#FAFAFA'>"
    property string strHTML2 : "</span><span style='font-size:36pt';style='color:#D4D4D4'><br>" // KSW 131023 //dg.jin 20141126 Ta popup modify
    //property string strHTML2 : "</span>" // KSW 131023 //dg.jin 20141126 Ta popup modify
    property string strHTML3 : "</span></center>"
    property string strHTML4 : "<span style='font-size:36pt'>" // KSW 131023
//    property string strHTML3 : QmlController.taMessage + "</span></center>";
//    property string strMessage : strHTML1 + QmlController.taTitle + strHTML2 + strHTML3;
    property int langId : 0 // KSW 131023

    focus           : true
    popupBtnCnt     : QmlController.taInfoType == 0 ? 2 :1;
    popupLineCnt    : 2 // KSW 131023 1 -> 2
	//KSW 131031 [ITS][198049][minor]
    popupFirstBtnText: stringInfo.strRDSPopupCancel
    popupSecondBtnText: stringInfo.strRDSPopupTaOff
//    popupFirstText: "<H1><Center>" + QmlController.taTitle +"</Center></H1>" + "<Center>" + QmlController.taMessage  + "</Center>" // KSW 131023
//    popupFirstText: strHTML1 + QmlController.taTitle + strHTML2 + QmlController.taMessage  + strHTML3 // KSW 131023
    //dg.jin 20141126 Ta popup modify
    popupFirstText: strHTML1 + QmlController.taTitle + strHTML2 +((QmlController.taInfoType == 0) ? (stringInfo.strRDSPopupTrafficAnnouncement + strHTML3) : ((QmlController.taInfoType == 1) ? (stringInfo.strRDSPopupNewsAnnouncement + strHTML3) : (stringInfo.strRDSPopupAlarmAnnouncement + strHTML3))) // KSW 131023
    //dg.jin 20140923 modify local TA
    //popupSecondText: ((QmlController.taInfoType == 0) ? (strHTML4 + stringInfo.strRDSPopupTrafficAnnouncement + strHTML3) : ((QmlController.taInfoType == 1) ? (strHTML4 + stringInfo.strRDSPopupNewsAnnouncement + strHTML3) : (strHTML4 + stringInfo.strRDSPopupAlarmAnnouncement + strHTML3)))// KSW 131023 //KSW 131031 [ITS][198049][minor]
    popuplangId: langId // KSW 131023


    onPopupFirstBtnClicked :{
        console.log("[QML] onPopupFirstBtnClicked : Cancel");
//        QmlController.rdsonairTA = false;
//        QmlController.setRDSInforCancel(QmlController.taInfoType )
        UIListener.handleResponseInfoCancel();
//        setAppMainScreen( "AppRadioRdsMain" , false); //KSW 131119-1
    }

    onPopupSecondBtnClicked :{
        console.log("[QML] onPopupSecondBtnClicked : Off ");
//        QmlController.rdsonairTA  = false
//        QmlController.rdssettingsTP = false;
        UIListener.handleResponseInfoOff();
//        setAppMainScreen( "AppRadioRdsMain" , false); //KSW 131119-1
    }
    Component.onCompleted : {
        console.log("[QML] idRadioRDSPopupTA Component.onCompleted ");
    }

//    onHardBackKeyClicked :{
//        console.log("[QML] DABTAPopup.qml : onHardBackKeyClicked :");
//        gotoBackScreen();
//    }
    Connections{
        target: UIListener
        onSigRDSResponse:{
            console.debug("[AppRadio-RDS :: idRadioRDSPopupTA] onSigRDSResponse responsetype = ",responsetype);
            if((responsetype > 1) && (idRadioRDSPopupTA.visible == true))
            {
            //                setAppMainScreen( "AppRadioRdsMain" , false);
                gotoBackScreen(); //KSW 131119-1
            }
        }

    }
    //KSW 131215 about TA
    Connections{
        target: QmlController
        onSigLocalTaPopupClose:{
            if(idRadioRDSPopupTA.visible == true)
            {
                console.debug("[AppRadio-RDS :: idRadioRDSPopupTA] onSigLocalTaPopupClose()");
                gotoBackScreen();
            }else{
                console.debug("[AppRadio-RDS :: idRadioRDSPopupTA] Its system popup so return");
            }
        }
    }


}
