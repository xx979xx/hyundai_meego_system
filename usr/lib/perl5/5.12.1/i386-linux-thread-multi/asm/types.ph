require '_h2ph_pre.ph';

no warnings qw(redefine misc);

unless(defined(&_ASM_X86_TYPES_H)) {
    eval 'sub _ASM_X86_TYPES_H () {1;}' unless defined(&_ASM_X86_TYPES_H);
    eval 'sub dma_addr_t () { &dma_addr_t;}' unless defined(&dma_addr_t);
    require 'asm-generic/types.ph';
}
1;
