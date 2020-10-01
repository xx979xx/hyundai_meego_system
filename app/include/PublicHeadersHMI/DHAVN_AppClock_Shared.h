#ifndef DHAVN_APPCLOCK_SHARED_H
#define DHAVN_APPCLOCK_SHARED_H

enum EAppClockStartState
{
   eStart_InvalidState = -1,
   eStart_Clock_With_Button = 0,
   eStart_Screen_Saver_Mode,
   eStart_Display_Mode,
   eStart_MaxIndex
};


struct AppClockStartParameter
{
    EAppClockStartState startState;
};

#endif //DHAVN_APPSETTINGS_SHARED_H
