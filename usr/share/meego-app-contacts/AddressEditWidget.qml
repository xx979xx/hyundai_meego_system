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
    id: addressRect
    height: childrenRect.height
    width: parent.width

    property variant newDetailsModel: null 
    property int rIndex: -1
    property bool updateMode: false 
    property bool validInput: false 

    property string homeContext: qsTr("Home")
    property string workContext: qsTr("Work")
    property string otherContext: qsTr("Other")
    property string streetAddress: qsTr("Street address")
    property string localeAddress: qsTr("Town / City")
    property string regionAddress: qsTr("Region / State")
    property string countryAddress:  qsTr("Country")
    property string postcodeAddress:  qsTr("Postcode / Zip")

    function parseDetailsModel(existingDetailsModel, contextModel) {
        var fieldOrder = localeUtils.getAddressFieldOrder();
        var arr = new Array(); 
        for (var i = 0; i < existingDetailsModel.length; i++) {
            var splitAddy = existingDetailsModel[i].split("\n");
            var arr2 = {};
            for (var k = 0; k < fieldOrder.length; k++) {
                var field = fieldOrder[k];
                arr2[field] = splitAddy[k];
            }
            arr2["type"] = contextModel[i];
            arr.push(arr2);
        }

        return arr;
    }

    function getNewDetailValues() {
        var streetList = new Array();
        var localeList = new Array();
        var regionList = new Array();
        var zipList = new Array();
        var countryList = new Array();
        var addressTypeList = new Array();
        var count = 0;

        for (var i = 0; i < newDetailsModel.count; i++) {
            if (newDetailsModel.get(i).street != "" || newDetailsModel.get(i).locale != "" 
                || newDetailsModel.get(i).region != "" || newDetailsModel.get(i).zip != "" 
                || newDetailsModel.get(i).country != "") {
                streetList[count] = newDetailsModel.get(i).street;
                localeList[count] = newDetailsModel.get(i).locale;
                regionList[count] = newDetailsModel.get(i).region;
                zipList[count] = newDetailsModel.get(i).zip;
                countryList[count] = newDetailsModel.get(i).country;
                addressTypeList[count] = newDetailsModel.get(i).type;
                count = count + 1;
            }
        }

        return {"streets": streetList, "locales": localeList, "regions": regionList, 
                "zips": zipList, "countries": countryList, "types": addressTypeList};
    }

    function getDetails(reset) {
        var data = new Array();
        for (var i = 0; i < addressColumn.children.length - 1; i++) {
            var key = addressColumn.children[i].fieldVal;
            data[key] = addressColumn.children[i].text;
        }
 
        var arr = {"street": data["street"], 
                   "locale": data["locale"], 
                   "region": data["region"],
                   "zip": data["zip"], 
                   "country": data["country"], 
                   "type": addressComboBox.model[addressComboBox.selectedIndex]};

        if (reset)
            resetFields();

        return arr;
    }

    function resetFields() {
        for (var i = 0; i < addressColumn.children.length - 1; i++)
            addressColumn.children[i].text = "";

       addressComboBox.selectedIndex = 0;
    }

    ListModel {
        id: addressFields
        Component.onCompleted: {
            var pairs = {"street": streetAddress,
                         "locale": localeAddress,
                         "region": regionAddress,
                         "zip": postcodeAddress,
                         "country": countryAddress};

            var fieldOrder = localeUtils.getAddressFieldOrder();
            for (var i = 0; i < fieldOrder.length; i++) {
                var field = fieldOrder[i];
                addressFields.append({"field": field, "dText": pairs[field]});
            }
        }
    }

    function getTextValue(field) {
        switch(field) {
            case "street":
                return newDetailsModel.get(rIndex).street;
            case "locale":
                return newDetailsModel.get(rIndex).locale;
            case "region":
                return newDetailsModel.get(rIndex).region;
            case "zip":
                return newDetailsModel.get(rIndex).zip;
            case "country":
                return newDetailsModel.get(rIndex).country;
        }
    }

    function getIndexVal(type) {
        if (updateMode) {
            for (var i = 0; i < addressComboBox.model.length; i++) {
                if (addressComboBox.model[i] == newDetailsModel.get(rIndex).type)
                    return i;
            }
        }
        return 0;
    }

    DropDown {
        id: addressComboBox

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

    Column {
        id: addressColumn
        spacing: 10
        anchors {left: addressComboBox.right; right: parent.right;
                 leftMargin: 10}
        width: parent.width - addressComboBox.width
        height: childrenRect.height

        Repeater {
            id: addressFieldRepeater

            width: parent.width
            height: childrenRect.height

            model: addressFields

            property bool validData: false

            delegate: TextEntry {
                id: addressTextField
                text: (updateMode) ? getTextValue(field) : ""
                defaultText: dText
                width: 400
                parent: addressFieldRepeater

                property string fieldVal: field

                Binding {target: addressFieldRepeater; property: "validData";
                         value: true; when: (text != "")}
                Binding {target: addressFieldRepeater; property: "validData";
                         value: false; when: (text == "")}
            }
        }
    }

    Binding {target: addressRect; property: "validInput"; value: true;
             when: (addressFieldRepeater.validData == true)
            }

    Binding {target: addressRect; property: "validInput"; value: false;
             when: (addressFieldRepeater.validData == false)
            }
}

