! Copyright (C) 2016 Alexander Ilin.
! See https://factorcode.org/license.txt for BSD license.
USING: tools.test checksums checksums.crc16 ;

{ B{ 0xb8 0x80 } } [
    B{ 0x01 0x04 0x02 0xFF 0xFF } crc16 checksum-bytes
] unit-test

{ B{ 0x21 0xc1 } } [
    B{ 0x68 0x11 0x08 0x18 0x00 0x00 0x01 0x43 0x04 0x6e 0xda }
    crc16 checksum-bytes
] unit-test
