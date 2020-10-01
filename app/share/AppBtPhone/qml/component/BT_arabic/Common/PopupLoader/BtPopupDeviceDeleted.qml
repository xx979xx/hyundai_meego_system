/**
 * /BT_arabic/Common/PopupLoader/BtPopupDeviceDeleted.qml
 *
 */
import QtQuick 1.1
import "../../../QML/DH_arabic" as MComp
import "../../../BT/Common/Javascript/operation.js" as MOp


MComp.MPopupTypeDim
{
    id: idBtPopupDeviceDeleted

    firstText: (true == deleteAllMode) ? stringInfo.str_Delete_All_Ok : stringInfo.str_Delete_Ok
    ignoreTimer: true
    black_opacity: (true == btPhoneEnter && "" == idAppMain.state) ? false : true

    /* EVENT Function Handlers */
    function deviceDeletedHandler() {
        /* 디바이스 삭제할 때 Yes/No팝업에서 Yes선택시 화면을 빼지 않기 때문에(popScreen)
          * 완료 팝업이 사라질 때 화면을(BtDeviceDelMain.qml) 빼줘야함
          */
        if("device" == delete_type) {
            if("BtDeviceDelMain" == idAppMain.state) {
                popScreen();
            }
        }

        /* 화면이 빠진 상태(popScreen 이후)에서 삭제완료 팝업이 표시되므로 아무작업도 하지 않음
         * 완료팝업 뜨기 전(onShow)에 화면을 빼면(popScreen) 삭제가 완료된 후 Download State Change에서
         * 화면이 변경된 후(switchScreen) 화면이 빠져(popScreen) Screen Stack이 엉킴
         */

        // 삭제 동작 시  설정된 값 삭제가 완료되었을 때 변수를 초기화
        btDeleteMode = false;
        deleteAllMode = false;
        BtCoreCtrl.invokeControlConnectableMode(true);

        if("device" == delete_type) {
            // 디바이스 삭제 완료
            //MOp.hidePopup();
            qml_debug("******* btSettingsEnter = " + btSettingsEnter);
            qml_debug("******* btPhoneEnter    = " + btPhoneEnter);
            qml_debug("******* isAnyConnected  = " + BtCoreCtrl.invokeIsAnyConnected());
            if(true == btPhoneEnter) {
                if(false == BtCoreCtrl.invokeIsAnyConnected()) {
                    // 삭제 중 Phone, Call Key로 BT 진입했을 때 삭제 완료 후 이전 화면으로 이동
                    MOp.postPopupBackKey();
                } else {
                    /* 삭제 후 연결된 디바이스가 있다면 Settings 화면 유지
                      */
                    //popScreen(200);
                    // 삭제 완료 이 후 연결중인 상태면 연결을 진행하도록 함
                    qml_debug("Connect State = " + BtCoreCtrl.invokeGetConnectState());
                    if(3 /* CONNECT_STATE_CONNECTING */ == BtCoreCtrl.invokeGetConnectState()) {
                        MOp.showPopup("popup_Bt_Connecting");
                    }  else if(true == iqs_15My && true == waitContactUpdatePopup) {
                        // 삭제 중 전화번호부 업데이트 진행상태였다면 삭제완료 팝업 이 후 전화번호부 업데이트 승인팝업을 출력
                        waitContactUpdatePopup = false;
                        //[IdeaBank 내수 16년 2차 정업]
                        //[START] Remove PB update confirm Popup
                        //case 0: KR
                        if(UIListener.invokeGetCountryVariant() == 0){
                            BtCoreCtrl.invokeContactUpdate(true);
                        }else{
                            MOp.showPopup("popup_Contact_Change");
                        }
                        //[END]
                    } else {
                        MOp.hidePopup();
                    }
                }
            } else {
                /* 홈 > 설정 > 블루투스 설정 > 메뉴 > 삭제 > 삭제 완료 설정 화면을 유지함
                 */
                //popScreen(201);
                if(true == iqs_15My && true == waitContactUpdatePopup) {
                    waitContactUpdatePopup = false;
                    //[IdeaBank 내수 16년 2차 정업]
                    //[START] Remove PB update confirm Popup
                    //case 0: KR
                    if(UIListener.invokeGetCountryVariant() == 0){
                        BtCoreCtrl.invokeContactUpdate(true);
                    }else{
                        MOp.showPopup("popup_Contact_Change");
                    }
                    //[END]
                } else {
                    MOp.hidePopup();
                }
            }

            // For IQS
            if(true == btConnectDeviceDelete) {
                // IQS3차 연결된 기기 삭제 시 자동연결 실행
                btConnectDeviceDelete = false;
                BtCoreCtrl.invokeStartAutoConnect();
            }
        } else if("recent" == delete_type) {
            // 최근통화 삭제 완료
            MOp.hidePopup();
        } else if("favorite" == delete_type) {
            // 즐겨찾기 삭제 완료
            MOp.hidePopup();
        } else {
            //[ITS 0270042]
            if(("" == delete_type) && btPhoneEnter &&
                (BtCoreCtrl.m_pairedDeviceCount==5) &&
                (false == BtCoreCtrl.invokeIsAnyConnected())){
                MOp.postPopupBackKey();
            }else{
                MOp.hidePopup();
            }
        }

        // Reset
        delete_type = "";
    }

    onShow: {
        /* 디바이스 삭제할 때 Yes/No팝업에서 Yes선택시 화면을 빼지 않기 때문에(popScreen)
         * 완료 팝업이 뜨기 전에 화면을(BtDeviceDelMain.qml) 먼저 빼줘야함
         */
        qml_debug("Main View State = " + idAppMain.state);
        qml_debug("btPhoneEnter = " + btPhoneEnter);
        qml_debug("btSettingsEnter = " + btSettingsEnter);
        if("device" == delete_type) {
            if("BtDeviceDelMain" == idAppMain.state) {
                popScreen();
            }
        }
    }

    onHide: {}

    onTimerEnd:             { deviceDeletedHandler() }
    onPopupClicked:         { deviceDeletedHandler() }
    onHardBackKeyClicked:   { deviceDeletedHandler() }
    onPopupBgClicked:       { deviceDeletedHandler() }
}
/* EOF */
