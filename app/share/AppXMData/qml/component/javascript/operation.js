function flickabledestroy() {
    //flickableMenu.destroy()
}
function homeloader() {
    if(subapploaderA)
        subapploaderA.destroy()
    //if(homeloaderA)
    //    homeloaderA.destroy()
    //homeloaderA.source = '../../../../HDhome.qml'
    //flickableMenu.visible=true
}
function subapploader(appname) {
    if(flickableMenu)
        flickableMenu.visible=false
    //if(subapploaderA)
    //    subapploaderA.destroy()
    //if(homeloaderA)
    //    homeloaderA.destroy()
    subapploaderA.source = appname
}
function interactive(flag) {
    if(flag)
        listView.interactive = "true"
    else
        listView.interactive = "false"
}
function delegatechange(index) {
    itemDisplay.sourceComponent = bestDelegate(index)
}
function checkPhoneNumber(phoneNumber){
    var RegNotNum  = /[^0-9,*,#,+]/g;
    var RegPhonNum = "";
    var DataForm   = "";

    phoneNumber = phoneNumber.replace(RegNotNum,'');
    if( phoneNumber.length < 4 ) return phoneNumber;
    if( phoneNumber.length > 3 && phoneNumber.length <= 6 ) {
        DataForm = "$1-$2";
        RegPhonNum = /([0-9,*,#,+]{3})([0-9,*,#,+])/;
    }
    else if(phoneNumber.length > 6 &&phoneNumber.length < 11){
        DataForm = "$1-$2-$3";
        RegPhonNum = /([0-9,*,#,+]{3})([0-9,*,#,+]{3})([0-9,*,#,+])/;
    }
    else if(phoneNumber.length == 11){
        DataForm = "$1-$2-$3";
        RegPhonNum = /([0-9,*,#,+]{3})([0-9,*,#,+]{4})([0-9,*,#,+]{4})/;
    }
    else if(phoneNumber.length > 11){
        DataForm = "$1\n$2";
        RegPhonNum = /([0-9,*,#,+]{34})([0-9,*,#,+])/;
    }
    while( RegPhonNum.test(phoneNumber) ) {
        phoneNumber = phoneNumber.replace(RegPhonNum, DataForm);
    }
    return phoneNumber;
}

function setMainScreen(screenName, save){
    if(screenName==idAppMain.state){
        return;
    }
    else
        switch(save){
        case true:
            idMenuCmd.source=""
            switch(idAppMain.state){
                //Main
            case "BtDialMain" : idBtDialMain.visible=false; break;

                //recent
            case "BtRecentTime" : idBtRecentTime.visible=false; break;
            case "BtRecentCall" : idBtRecentCall.visible=false; break;
            case "BtRecentDelete" : idBtRecentDelMain.visible=false; break;

                //contact
            case "BtContactMain" : idBtContactMain.visible=false; break;
            case "BtContactsDelMain" : idBtContactsDelMain.visible=false; break;
            case "BtAddMain" : idBtAddMain.visible=false; break;

                //Favorite
            case "BtFavoriteMain" : idBtFavoriteMain.visible=false; break;
            case "BtFavoriteEdit" : idBtFavoriteEdit.visible=false; break;
            case "BtFavoriteAdd" : idBtFavoriteAdd.visible=false; break;
            case "BtFavoriteDelete" : idBtFavoriteDelete.visible=false; break;

                //device
            case "BtDeviceNewRegistration" : idBtDeviceNewRegistration.source=''; break;
            case "BtDeviceDelMain" : idBtDeviceDelMain.source=''; break;
            case "BtDeviceList" : idBtDeviceList.source=''; break;
            case "BtInfoView" : idBtInfoView.source=''; break;
                case "BtDeviceNoDevice" :idBtDeviceNoDevice.source=''; break;
            }
            break;

        case false :
            idMenuCmd.source=""
            switch(idAppMain.state){
                //Main
            case "BtDialMain" : idBtDialMain.source='';idBtDialMain.source=''; break;

                //recent
            case "BtRecentTime" : idBtRecentTime.source=''; break;
            case "BtRecentCall" : idBtRecentCall.source=''; break;
            case "BtRecentDelete" : idBtRecentDelMain.source=''; break;

                //contact
            case "BtContactMain" : idBtContactMain.source=''; break;
            case "BtContactsDelMain" : idBtContactsDelMain.source=''; break;
            case "BtAddMain" : idBtAddMain.visible=false; break;

                //Favorite
            case "BtFavoriteMain" : idBtFavoriteMain.source=''; break;
            case "BtFavoriteEdit" : idBtFavoriteEdit.source=''; break;
            case "BtFavoriteAdd" : idBtFavoriteAdd.visible=false; break;
            case "BtFavoriteDelete" : idBtFavoriteDelete.visible=false; break;


                //device
            case "BtDeviceNewRegistration" : idBtDeviceNewRegistration.source=''; break;
            case "BtDeviceDelMain" : idBtDeviceDelMain.source=''; break;
            case "BtDeviceList" : idBtDeviceList.source=''; break;
            case "BtInfoView" : idBtInfoView.source=''; break;
                case "BtDeviceNoDevice" :idBtDeviceNoDevice.source=''; break;
            }
        }


    switch(screenName){
        //Dial
    case "BtDialMain" :
        if(idBtDialMain.status==Loader.Null)
            idBtDialMain.source = "../component/BT/Dial/mainview/BtDialMain.qml"
        idBtDialMain.visible=true
        idBtDialMain.forceActiveFocus()
        idMenuCmd.source="../component/BT/Dial/BtDialOptionMenu.qml"
        break;

        //Recent
    case "BtRecentTime" :
        if(idBtRecentTime.status==Loader.Null)
            idBtRecentTime.source = "../component/BT/Recent/mainview/BtRecentTime.qml"
        idBtRecentTime.visible=true
        idBtRecentTime.forceActiveFocus()

        idMenuCmd.source="../component/BT/Recent/BtRecentOptionMenu.qml"
        break;

    case "BtRecentCall" :
        if(idBtRecentCall.status==Loader.Null)
            idBtRecentCall.source = "../component/BT/Recent/mainview/BtRecentCall.qml"
        idBtRecentCall.visible=true
        idBtRecentCall.forceActiveFocus()
        idMenuCmd.source="../component/BT/Recent/BtRecentOptionMenu.qml"
        break;

    case "BtRecentDelete" :
        if(idBtRecentDelMain.status==Loader.Null)
            idBtRecentDelMain.source = "../component/BT/Recent/Delete/BtRecentDelMain.qml"
        idBtRecentDelMain.visible=true
        idBtRecentDelMain.forceActiveFocus()
        break;

        //Contact
    case "BtContactMain" :
        if(idBtContactMain.status==Loader.Null)
            idBtContactMain.source = "../component/BT/Contacts/mainview/BtContactMain.qml"
        idBtContactMain.visible=true
        idBtContactMain.forceActiveFocus()
        idMenuCmd.source="../component/BT/Contacts/BtContactOptionMenu.qml"
        break;

    case "BtContactsDelMain" :
        if(idBtContactsDelMain.status==Loader.Null)
            idBtContactsDelMain.source = "../component/BT/Contacts/Delete/BtContactsDelMain.qml"
        idBtContactsDelMain.visible=true
        idBtContactsDelMain.forceActiveFocus()
        break;

    case "BtAddMain" :
        if(idBtAddMain.status==Loader.Null)
            idBtAddMain.source = "../component/BT/General/BtAddMain.qml"
        idBtAddMain.visible=true
        idBtAddMain.forceActiveFocus()
        break;

        //Favorite
    case "BtFavoriteMain" :
        if(idBtFavoriteMain.status==Loader.Null)
            idBtFavoriteMain.source = "../component/BT/Favorite/mainview/BtFavoriteMain.qml"
        idBtFavoriteMain.visible=true
        idBtFavoriteMain.forceActiveFocus()
        idMenuCmd.source="../component/BT/Favorite/BtFavoriteOptionMenu.qml"
        break;

    case "BtFavoriteDelete" :
        if(idBtFavoriteDelete.status==Loader.Null)
            idBtFavoriteDelete.source = "../component/BT/Favorite/Delete/BtFavoriteDelete.qml"
        idBtFavoriteDelete.visible=true
        idBtFavoriteDelete.forceActiveFocus()
        break;

    case "BtFavoriteEdit" :
        if(idBtFavoriteEdit.status==Loader.Null)
            idBtFavoriteEdit.source = "../component/BT/Favorite/mainview/BtFavoriteEdit.qml"
        idBtFavoriteEdit.visible=true
        idBtFavoriteEdit.forceActiveFocus()
        break;

    case "BtFavoriteAdd" :
        if(idBtFavoriteAdd.status==Loader.Null)
            idBtFavoriteAdd.source = "../component/BT/Favorite/Add/BtFavoriteAddMain.qml"
        idBtFavoriteAdd.visible=true
        idBtFavoriteAdd.forceActiveFocus()
        break;


        //Device
    case "BtDeviceNewRegistration" :
        if(idBtDeviceNewRegistration.status==Loader.Null)
            idBtDeviceNewRegistration.source = "../component/BT/Device/mainview/BtDeviceNewRegistration.qml"
        idBtDeviceNewRegistration.visible=true
        idBtDeviceNewRegistration.forceActiveFocus()
        break;

    case "BtDeviceDelMain" :
        if(idBtDeviceDelMain.status==Loader.Null)
            idBtDeviceDelMain.source = "../component/BT/Device/Delete/BtDeviceDelMain.qml"
        idBtDeviceDelMain.visible=true
        idBtDeviceDelMain.forceActiveFocus()
        break;

    case "BtDeviceList" :
        if(idBtDeviceList.status==Loader.Null)
            idBtDeviceList.source = "../component/BT/Device/mainview/BtDeviceList.qml"
        idBtDeviceList.visible=true
        idBtDeviceList.forceActiveFocus()
        idMenuCmd.source="../component/BT/Device/BtDeviceOptionMenu.qml"
        break;

    case "BtDeviceNoDevice" :
        if(idBtDeviceNoDevice.status==Loader.Null)
            idBtDeviceNoDevice.source = "../component/BT/Device/mainview/BtDeviceNoDevice.qml"
        idBtDeviceNoDevice.visible=true
        idBtDeviceNoDevice.forceActiveFocus()
        break;

        //general
    case "BtInfoView" :
        if(idBtInfoView.status==Loader.Null)
            idBtInfoView.source = "../component/BT/General/BtInfoView.qml"
        idBtInfoView.visible=true
        idBtInfoView.forceActiveFocus()
        break;
    }
    idAppMain.state=screenName
}
