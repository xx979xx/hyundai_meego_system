/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.0
import MeeGo.Sync 0.1

Item {
    property alias syncParentPage: syncAllProfilesList.appPage

    SyncList {
        id: syncAllProfilesList
        model: AllVisibleSyncProfilesModel {}
    }
}
