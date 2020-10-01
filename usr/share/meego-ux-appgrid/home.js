/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

var maxPages = 9;
var waitingList = [];
var assignedSeats = [];
var dock = [];

function getPageCount()
{
    return assignedSeats.length;
}

function getPageSize(page)
{
    return assignedSeats[page].length;
}

function removeEmptyPages()
{
    var firstMovedPage = -1;
    var list = [];
    for (var i = 0; i < assignedSeats.length; i++)
    {
        if (assignedSeats[i].length == 0)
        {
            if (firstMovedPage == -1)
                firstMovedPage = i;
        }
        else
        {
            list.push(assignedSeats[i]);
        }
    }
    assignedSeats = list;

    if (firstMovedPage != -1)
    {
        // We removed an empty page so correct the page assignment for
        // each of the effected desktops
        for (var j = firstMovedPage; j < assignedSeats.length; j++)
        {
            var p = assignedSeats[j];
            for (var k = 0; k < p.length; k++)
            {
                p[k].page = j;
            }
        }
    }
}

function removeNullDesktops()
{
    for (var page = 0; page < assignedSeats.length; page++)
    {
        var list = [];
        for (var i = 0; i < assignedSeats[page].length; i++)
        {
            var d = assignedSeats[page][i];
            if (d.filename)
                list.push(d);
        }
        assignedSeats[page] = list;
    }
}

function pluckFromPage(desktop)
{
    var list = [];
    var p = assignedSeats[desktop.page];
    for (var i = 0; i < p.length; i++)
    {
        if (p[i].filename != desktop.filename)
            list.push(p[i]);
    }
    assignedSeats[desktop.page] = list;
}

function pluckFromDock(desktop)
{
    var list = [];
    while (dock.length > 0)
    {
        var d = dock.pop();
        if (d.filename != desktop.filename)
            list.push(d);
    }
    dock = list;
}

function insertIntoPage(desktop)
{
    desktop.assigned = true;
    assignedSeats[desktop.page].push(desktop);
}

// This will either return a single desktop entry currently
// assigned to a seat, or nothing indicating the seat is available
function getSeat (row, column, page)
{
    if (row > 0)
    {
        if (page > assignedSeats.length - 1)
            return;

        var p = assignedSeats[page];
        for (var i = 0; i < p.length; i++)
        {
            // desktop in question
            var d = p[i];

            // Calculate the block size between the desktop's
            // starting position and the position in question
            var targetWidth = column - d.column + 1;
            var targetHeight = d.row - row + 1;

            // If the position in quesiton is inside the assigned
            // region of the desktop in question then this is the
            // desktop we are looking for
            if (targetWidth > 0 && targetWidth <= d.width &&
                targetHeight > 0 && targetHeight <= d.height)
                return d;
        }
    }
    else
    {
        for (var i = 0; i < dock.length; i++)
            if (dock[i].column == column)
                return dock[i];
    }
}

function freeSeat(caller, row, column, page)
{
    if (row > 0)
    {
        var seat = getSeat(row, column, page);
        if (seat && seat != caller)
        {
            var list = [];
            for (var i = 0; i < assignedSeats[page].length; i++)
            {
                var d = assignedSeats[page][i];
                if (d.filename != seat.filename)
                    list.push(d);
            }

            waitingList.push(seat);
            assignedSeats[page] = list;
        }
    }
    else
    {
        var list = [];
        for (var i = 0; i < dock.length; i++)
        {
            if (dock[i] == caller || dock[i].column != column)
                list.push(dock[i]);
            else
                waitingList.push(dock[i]);
        }
        dock = list;
    }
}

// Determin if a block of seats is availing for seating a request
// for a given priority
function isBlockAvailable (caller, priority, startingRow, endingRow, startingColumn, endingColumn, page)
{
    if (page < 0 || page > maxPages + 1)
        return false;

    if (startingRow == 0)
    {
        // Docking area request
        if (startingRow != endingRow || startingColumn != endingColumn)
        {
            // The dock only allows 1x1 entries
            return false;
        }
        if (startingColumn > 5)
        {
            // There are a max of 6 items that can be seated
            // in the dock
            return false;
        }
    }
    else
    {
        // App grid request
        if (startingRow < 1 || endingRow > 4 || endingRow < 1)
            return false;
        if (startingColumn < 0 || endingColumn > 3 || startingColumn > endingColumn)
            return false;
    }

    for (var r = endingRow; r < startingRow + 1; r++)
    {
        for (var c = startingColumn; c < endingColumn + 1; c++)
        {
            var d = getSeat(r, c, page);
            if (d && d != caller && d.priority >= priority)
                return false;
        }
    }

    // We did not find any conflicts, so the seats are available
    return true;
}

// Assign any desktops currently using this block of seats into
// the waitlist.
function freeSeatingBlock (caller, startingRow, endingRow, startingColumn, endingColumn, page)
{
    for (var r = endingRow; r < startingRow + 1; r++)
    {
        for (var c = startingColumn; c < endingColumn + 1; c++)
        {
            freeSeat(caller, r, c, page);
        }
    }
}

function assignFreeSeatInPage(desktop, page)
{
    if (page > assignedSeats.length - 1)
    {
        assignedSeats.push([]);
    }

    // Start searching for an available seat at row 1
    // since row 0 is reserved for the dock
    for (var row = 1; row < 5; row++)
    {
        for (var column = 0; column < 4; column++)
        {
            if (isBlockAvailable(desktop, -1, row, row - (desktop.height - 1), column, column + (desktop.width - 1), page))
            {
                desktop.row = row;
                desktop.column = column;
                desktop.page = page;
                assignedSeats[page].push(desktop);
                desktop.assigned = true;
                return true;
            }
        }
    }

    return false;
}

function processWaitingList()
{
    var lastPageSeated = -1;
    var stillWaitingList = [];
    while (waitingList.length > 0)
    {
        var pindex;
        var d = waitingList.pop();
        for (pindex = 0; pindex < maxPages; pindex++)
        {
            if (assignFreeSeatInPage(d, pindex))
            {
                lastPageSeated = pindex;
                break;
            }
        }
        if (pindex == maxPages)
            stillWaitingList.push(d);
    }
    waitingList = stillWaitingList;
    return lastPageSeated;
}

function assignSeats(desktops)
{
    // Process reserved seats
    for (var i = 0; i < desktops.length; i++)
    {
        var d = desktops[i];

        if (d.assigned == true)
            continue;

        if (d.row == -1 || d.column == -1 || d.page == -1)
        {
            waitingList.push(d);
            continue;
        }

        if (isBlockAvailable(d, d.priority, d.row, d.row - (d.height - 1), d.column, d.column + (d.width - 1), d.page))
        {
            if (d.row > 0)
            {
                if (assignedSeats.length < d.page + 1)
                {
                    for (var pindex = assignedSeats.length; pindex < d.page + 1; pindex++)
                    {
                        assignedSeats.push([]);
                    }
                }
                else
                {
                    // The seating block is available, but we still might need
                    // to kick out some lower priority residents
                    freeSeatingBlock(d, d.row, d.row + (d.height - 1), d.column, d.column + (d.width - 1), d.page);
                }
                assignedSeats[d.page].push(d);
            }
            else
            {
                // The seating block is available, but we still might need
                // to kick out some lower priority residents
                freeSeatingBlock(d, d.row, d.row, d.column, d.column, 0);
                dock.push(d);
            }
            d.assigned = true;
        }
        else
        {
            // Request denied... send to the back of the waiting list
            d.row = -1;
            d.column = -1;
            d.page = -1;
            waitingList.push(d);
        }
    }
}

function dumpDesktops(desktops)
{
    console.log("Desktops >>>");
    for (var i = 0; i < desktops.length; i++)
    {
        var d = desktops[i];
        console.log(d.filename + " >> " + d.row + " X " + d.column + " - " + d.page);
    }
    console.log("<<<");
}

function dump()
{
    for (var pindex = 0; pindex < assignedSeats.length; pindex++)
    {
        console.log("<---  Page " + pindex + " --->");
        var page = assignedSeats[pindex];
        for (var i = 0; i < page.length; i++)
        {
            var d = page[i];
            console.log(d.title + ": " + d.row + " X " + d.column + " - " + d.page);
        }
    }
    if (waitingList.length > 0)
    {
        console.log("<---  Waiting List --->");
        for (var i = 0; i < waitingList.length; i++)
        {
            console.log(waitingList[i].name);
        }
    }
}

function dumpDock()
{
    console.log("<-- Dock -->");
    for (var i = 0; i < dock.length; i++)
        console.log(dock[i].title + ": " + dock[i].column);
}

function populateDock(target)
{
    for (var i = 0; i < dock.length; i++)
    {
        var d = dock[i];
        var o = itemComponent.createObject(target);
        o.desktop = d;
        o.index = i;
    }
}

function populateGrid(target, page)
{
    for (var i = 0; i < assignedSeats[page].length; i++)
    {
        var d = assignedSeats[page][i];

        // skip over docked icons
        if (d.row == 0)
            continue;

        // NOTE: If you directly pass the target to createObject, then the
        //       element will be destroyed when the target is destroyed
        //       (normally what you want) even if its parent was explicitly
        //       changed (which is not so nice.)
        //
        //       Using a persistant element as the initial parent, and then
        //       reasigning to the intended parent seems to work.
        //
        // http://bugreports.qt.nokia.com/browse/QTBUG-15085
        var o = itemComponent.createObject(drawingArea);
        o.parent = target;
        o.desktop = d;
        o.index = i;
    }
}

function position2Column(position, length)
{
    if (position > length/2)
    {
        if ((position - length/2) > length/4)
            return 3;
        else
            return 2
    }
    else
    {
        if (position > length/4)
            return 1;
        else
            return 0;
    }
}

function position2Row(position, length)
{
    if (position > length * 3/5)
    {
        if (position > length * 4/5)
            return 4;
        else
            return 3
    }
    else
    {
        if (position > length * 2/5)
            return 2;
        else if (position > length * 1/5)
            return 1;
        else
            return 0;
    }
}

function cleanup(target)
{
    // Start counting at 1 instead of 0 so that we do not
    // accidently remove the MouseArea used for triggering the
    // personalization UI and the landingPad used for guiding
    // the moved icon
    for (var i = 1; i < target.children.length; i++)
    {
        target.children[i].destroy();
    }
}
