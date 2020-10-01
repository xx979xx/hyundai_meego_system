require '_h2ph_pre.ph';

no warnings qw(redefine misc);

unless(defined(&_SYS_UCONTEXT_H)) {
    eval 'sub _SYS_UCONTEXT_H () {1;}' unless defined(&_SYS_UCONTEXT_H);
    require 'features.ph';
    require 'signal.ph';
    require 'bits/sigcontext.ph';
    eval 'sub NGREG () {19;}' unless defined(&NGREG);
    if(defined(&__USE_GNU)) {
	eval("sub REG_GS () { 0; }") unless defined(&REG_GS);
	eval("sub REG_FS () { 1; }") unless defined(&REG_FS);
	eval("sub REG_ES () { 2; }") unless defined(&REG_ES);
	eval("sub REG_DS () { 3; }") unless defined(&REG_DS);
	eval("sub REG_EDI () { 4; }") unless defined(&REG_EDI);
	eval("sub REG_ESI () { 5; }") unless defined(&REG_ESI);
	eval("sub REG_EBP () { 6; }") unless defined(&REG_EBP);
	eval("sub REG_ESP () { 7; }") unless defined(&REG_ESP);
	eval("sub REG_EBX () { 8; }") unless defined(&REG_EBX);
	eval("sub REG_EDX () { 9; }") unless defined(&REG_EDX);
	eval("sub REG_ECX () { 10; }") unless defined(&REG_ECX);
	eval("sub REG_EAX () { 11; }") unless defined(&REG_EAX);
	eval("sub REG_TRAPNO () { 12; }") unless defined(&REG_TRAPNO);
	eval("sub REG_ERR () { 13; }") unless defined(&REG_ERR);
	eval("sub REG_EIP () { 14; }") unless defined(&REG_EIP);
	eval("sub REG_CS () { 15; }") unless defined(&REG_CS);
	eval("sub REG_EFL () { 16; }") unless defined(&REG_EFL);
	eval("sub REG_UESP () { 17; }") unless defined(&REG_UESP);
	eval("sub REG_SS () { 18; }") unless defined(&REG_SS);
    }
}
1;
