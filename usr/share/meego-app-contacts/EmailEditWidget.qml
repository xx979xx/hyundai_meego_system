/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: emailRect
    height: childrenRect.height
    width:  parent.width

    property variant newDetailsModel: null
    property int rIndex: -1
    property bool updateMode: false 
    property bool validInput: false 

    property string contextHome : qsTr("Home")
    property string contextWork : qsTr("Work")
    property string contextOther : qsTr("Other")
    property string defaultEmail : qsTr("Email address")

    function parseDetailsModel(existingDetailsModel, contextModel) {
        var arr = new Array(); 
        for (var i = 0; i < existingDetailsModel.length; i++)
            arr[i] = {"email": existingDetailsModel[i], "type": contextModel[i]};

        return arr;
    }

    function getNewDetailValues() {
        var emailAddyList = new Array();
        var emailTypeList = new Array();
        var count = 0;

        for (var i = 0; i < newDetailsModel.count; i++) {
            if (newDetailsModel.get(i).email != "") {
                emailAddyList[count] = newDetailsModel.get(i).email;
                emailTypeList[count] = newDetailsModel.get(i).type;
                count = count + 1;
            }
        }
        return {"emails": emailAddyList, "types": emailTypeList};
    }

    function getDetails(reset) {
        var arr = {"email": data_email.text,
                   "type": emailComboBox.model[emailComboBox.selectedIndex]};

        if (reset)
            resetFields();

        return arr;
    }

    function resetFields() {
       data_email.text = "";
       emailComboBox.selectedIndex = 0;
    }

    function getIndexVal(type) {
        if (updateMode) {
            for (var i = 0; i < emailComboBox.model.length; i++) {
                if (emailComboBox.model[i] == newDetailsModel.get(rIndex).type)
                    return i;
            }
        }
        return 0;
    }

    DropDown {
        id: emailComboBox

        anchors {left: parent.left; leftMargin: 10;}
        titleColor: theme_fontColorNormal

        width: 250
        minWidth: width
        maxWidth: width + 50

        model: [contextHome, contextWork, contextOther]

        title: (updateMode) ? newDetailsModel.get(rIndex).type : contextHome
        selectedIndex: (updateMode) ? getIndexVal(newDetailsModel.get(rIndex).type) : 0
        replaceDropDownTitle: true
    }

    TextEntry {
        id: data_email
        text: (updateMode) ? newDetailsModel.get(rIndex).email : ""
        defaultText: defaultEmail
        width: 400
        anchors {left:emailComboBox.right; leftMargin: 10;}
        inputMethodHints: Qt.ImhEmailCharactersOnly
    }

    Binding {target: emailRect; property: "validInput"; value: true;
             when: (data_email.text != "")
            }

    Binding {target: emailRect; property: "validInput"; value: false;
             when: (data_email.text == "")
            }
}

