/*
 * Copyright 2010 Nokia Corporation and/or its subsidiary(-ies).
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

var pageStack = [];

function getDepth() {
    return pageStack.length;
}

function push(page, replace, immediate) {
    var pages;
    if (page instanceof Array) {
        pages = page;
        page = pages.pop();
    }

    var oldSlot = pageStack[pageStack.length - 1];

    if (oldSlot && replace) {
        pageStack.pop();
    }

    if (pages) {
        var i;
        for (i = 0; i < pages.length; i++) {
            pageStack.push(createSlot(pages[i]));
        }
    }

    var slot = createSlot(page);

    pageStack.push(slot);

    depth = pageStack.length;
    currentPage = slot.page;

    immediate = immediate || !oldSlot;
    if (oldSlot) {
        oldSlot.pushExit(replace, immediate);
    }
    slot.pushEnter(replace, immediate);

    var tools = slot.page.tools || null;
    if (toolBar) {
        toolBar.setTools(tools, immediate ? "set" : replace ? "replace" : "push");
    }

    return slot.page;
}

function createSlot(page) {
    var slot = slotComponent.createObject(root);
    if (page.createObject) {
        page = page.createObject(slot);
        slot.page = page;
        slot.owner = slot;
    } else {
        slot.page = page;
        slot.owner = page.parent;
        page.parent = slot;
    }
    return slot;
}

function pop(page, immediate) {
    if (pageStack.length > 1) {
        var oldSlot = pageStack.pop();
        var slot = pageStack[pageStack.length - 1];
        if (page) {
            while (slot.page != page && pageStack.length > 1) {
                slot.cleanup();
                slot.destroy();
                pageStack.pop();
                slot = pageStack[pageStack.length - 1];
            }
        }

        depth = pageStack.length;
        currentPage = slot.page;

        oldSlot.popExit(immediate);
        slot.popEnter(immediate);

        var tools = slot.page.tools || null;
        if (toolBar) {
            toolBar.setTools(tools, immediate ? "set" : "pop");
        }

        return oldSlot.page;
    } else {
        return null;
    }
}

function clear() {
    var slot;
    while (slot = pageStack.pop()) {
        slot.cleanup();
        slot.destroy();
    }
}

