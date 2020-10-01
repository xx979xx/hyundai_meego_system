/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* this file manages item lists for the RadioGroup */

var items = [];
var selectedItem = null;

function add(item) {
    items.push(item);
    if (selectedValue && item.value === selectedValue) {
        check(item);
    }
}

function check(item) {
    var old = selectedItem;
    selectedItem = item;
    if (old) {
        old.checked = false;
    }
    item.checked = true;
    root.selectedValue = item.value;
}

function select(value) {
    for (var i = 0; i < items.length; i++) {
        if (items[i].value === value) {
            check(items[i]);
            break;
        }
    }
}
