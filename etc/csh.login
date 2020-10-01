# /etc/csh.login

# System wide environment and startup programs, for login setup

if ($?PATH) then
	if ( "${path}" !~ */usr/X11R6/bin* ) then
		setenv PATH "${PATH}:/usr/X11R6/bin"
        endif
else
	if ( $uid == 0 ) then
		setenv PATH "/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin"
	else
		setenv PATH "/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/X11R6/bin"
	endif
endif

setenv HOSTNAME `/bin/hostname`
set history=1000

if ( -d /etc/profile.d ) then
        set nonomatch
        foreach i ( /etc/profile.d/*.csh )
                if ( -r $i ) then
	                        if ($?prompt) then
	                              source $i
	                        else
	                              source $i >& /dev/null
	                        endif
                endif
        end
        unset i nonomatch
endif
