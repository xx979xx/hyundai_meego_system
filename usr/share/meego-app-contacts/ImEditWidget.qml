/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.App.Contacts 0.1
import MeeGo.App.IM 0.1

Item {
    id: imsRect
    height: childrenRect.height
    width: parent.width

    property variant newDetailsModel: null 
    property int rIndex: -1
    property bool updateMode: false 
    property bool validInput: false

    property string imLabel : qsTr("Instant messaging")
    property string aim_sp : qsTr("AIM")
    property string msn_sp : qsTr("MSN")
    property string jabber_sp : qsTr("Jabber")
    property string yahoo_sp : qsTr("Yahoo!")
    property string facebook_sp : qsTr("Facebook")
    property string gtalk_sp : qsTr("gTalk")
    property string defaultIm : qsTr("Account Name / ID")
    property string defaultAccount : qsTr("Account Type")
    property string noAccount: qsTr("No IM accounts are configured")
    property string noBuddies : qsTr("No buddies for this account")

    function parseDetailsModel(existingDetailsModel, contextModel) {
        var arr = new Array(); 
        for (var i = 0; i < existingDetailsModel.length; i++) {
            var type = contextModel[i].split("\n")[0];
            arr[i] = {"im": existingDetailsModel[i], "type": type};
        }

        return arr;
    }

    function getNewDetailValues() {
        var imList = new Array();
        var imTypeList = new Array();
        var count = 0;
        for (var i = 0; i < newDetailsModel.count; i++) {
            if (newDetailsModel.get(i).im != "") {
                imList[count] = newDetailsModel.get(i).im;
                imTypeList[count] = newDetailsModel.get(i).type + "\n" 
                                    + newDetailsModel.get(i).account;
                count = count + 1;
            }
        }
        return {"ims": imList, "types": imTypeList};
    }

    function getDetails(reset) {
        var arr = {"im": imComboBox2.selectedTitle,
                   "type": im.model[imComboBox.selectedIndex]};

        if (reset)
            resetFields();

        return arr;
    }

    function resetFields() {
       imComboBox.Index = 0;
       imComboBox2.selectedTitle = defaultIm;
    }

    function getAvailableAccountTypes() {
        var accountTypes = new Array();

        for (var i = 0; i < imContexts.count; i++) {
            accountTypes[i] = imContexts.get(i).accountType;
        }

        if (i == 0)
            accountTypes[0] = noAccount;

        return accountTypes;
    }

    function getAvailableBuddies(selectedIndex) {
        var buddyList = new Array();
        for (var i = 0; i < imContexts.count; i++) {
            if (imContexts.get(i).accountType == imContexts.get(selectedIndex).accountType) {
                var list = telepathyManager.availableContacts(imContexts.get(i).account);
                if (list.length > 0) {
                    buddyList[0] = defaultIm;
                    for (var i = 1; i < list.length + 1; i++) {
                        buddyList[i] = list[i - 1];
                    }

                    return buddyList;
                }
            }
        }
        return [noBuddies];
    }

    ListModel{
        id: imContexts
        Component.onCompleted:{
            var list = telepathyManager.availableAccounts();
            for (var account in list) {
                imContexts.append({"accountType": list[account],
                                   "account": account});
            }
        }
    }

    function getIndexVal(type) {
        if (updateMode) {
            for (var i = 0; i < imComboBox.model.length; i++) {
                if (imComboBox.model[i] == newDetailsModel.get(rIndex).type)
                    return i;
            }
        }
        return 0;
    }

    DropDown {
        id: imComboBox
 
        anchors {left: parent.left; leftMargin: 36}
        titleColor: theme_fontColorNormal
 
        width: 250
        minWidth: width
        maxWidth: width + 50
 
        model: getAvailableAccountTypes()

        title: (updateMode) ? newDetailsModel.get(rIndex).type : defaultAccount 
        selectedIndex: (updateMode) ? getIndexVal(newDetailsModel.get(rIndex).type) : 0
        replaceDropDownTitle: true
    }

    DropDown {
        id: imComboBox2
 
        anchors {left:imComboBox.right; leftMargin: 10;}
        titleColor: theme_fontColorNormal
 
        width: 450
        minWidth: width
        maxWidth: width + 50
 
        model: (imComboBox.selectedIndex) ? getAvailableBuddies(imComboBox.selectedTitle) : [noBuddies]
 
        state: "notInUpdateMode"
 
        states: [
            State {
                name: "inUpdateMode"; when: (imsRect.updateMode == true)
                PropertyChanges{target: imComboBox2;
                                title: newDetailsModel.get(rIndex).im}
                PropertyChanges{target: imComboBox2;
                                selectedTitle: newDetailsModel.get(rIndex).im}
            },
            State {
                name: "notInUpdateMode"; when: (imsRect.updateMode == false)
                PropertyChanges{target: imComboBox2; title: defaultIm}
                PropertyChanges{target: imComboBox2; selectedTitle: defaultIm}
            }
        ]
    }

    Binding {target: imsRect; property: "validInput"; value: true; 
             when: ((imComboBox.selectedTitle != defaultAccount) &&
                    (imComboBox.selectedTitle != noAccount) &&
                    (imComboBox2.selectedTitle != defaultIm) &&
                    (imComboBox2.selectedTitle != noBuddies))
            }

    Binding {target: imsRect; property: "validInput"; value: false; 
             when: ((imComboBox.selectedTitle == defaultAccount) || 
                    (imComboBox.selectedTitle == noAccount) || 
                    (imComboBox2.selectedTitle == defaultIm) || 
                    (imComboBox2.selectedTitle == noBuddies))
            }
}

