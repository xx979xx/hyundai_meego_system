require '_h2ph_pre.ph';

no warnings qw(redefine misc);

unless(defined(&_SYS_SELECT_H)) {
    die("Never use <bits/select.h> directly; include <sys/select.h> instead.");
}
if(defined (&__GNUC__)  && (defined(&__GNUC__) ? &__GNUC__ : undef) >= 2) {
    eval 'sub __FD_ZERO {
        my($fdsp) = @_;
	    eval q(\\"(assembly code)\\");
    }' unless defined(&__FD_ZERO);
    eval 'sub __FD_SET {
        my($fd, $fdsp) = @_;
	    eval q(\\"(assembly code)\\");
    }' unless defined(&__FD_SET);
    eval 'sub __FD_CLR {
        my($fd, $fdsp) = @_;
	    eval q(\\"(assembly code)\\");
    }' unless defined(&__FD_CLR);
    eval 'sub __FD_ISSET {
        my($fd, $fdsp) = @_;
	    eval q(\\"(assembly code)\\");
    }' unless defined(&__FD_ISSET);
} else {
    eval 'sub __FD_ZERO {
        my($set) = @_;
	    eval q( &do { \'unsigned int __i\';  &fd_set * &__arr = ($set);  &for ( &__i = 0;  &__i < $sizeof{ &fd_set} / $sizeof{ &__fd_mask}; ++ &__i)  &__FDS_BITS ( &__arr)[ &__i] = 0; }  &while (0));
    }' unless defined(&__FD_ZERO);
    eval 'sub __FD_SET {
        my($d, $set) = @_;
	    eval q(( &__FDS_BITS ($set)[ &__FDELT ($d)] |=  &__FDMASK ($d)));
    }' unless defined(&__FD_SET);
    eval 'sub __FD_CLR {
        my($d, $set) = @_;
	    eval q(( &__FDS_BITS ($set)[ &__FDELT ($d)] &= ~ &__FDMASK ($d)));
    }' unless defined(&__FD_CLR);
    eval 'sub __FD_ISSET {
        my($d, $set) = @_;
	    eval q(( &__FDS_BITS ($set)[ &__FDELT ($d)] &  &__FDMASK ($d)));
    }' unless defined(&__FD_ISSET);
}
1;
