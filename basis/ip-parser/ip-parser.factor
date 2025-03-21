! Copyright (C) 2012-2014 John Benediktsson
! See https://factorcode.org/license.txt for BSD license

USING: accessors byte-arrays combinators
combinators.short-circuit endian grouping hex-strings kernel
math math.bitwise math.parser present regexp sequences splitting
strings ;

IN: ip-parser

ERROR: malformed-ipv4 string ;

ERROR: malformed-ipv6 string ;

ERROR: bad-ipv4-component string ;

<PRIVATE

: octal? ( str -- ? )
    { [ "0" = not ] [ "0" head? ] [ "0x" head? not ] } 1&& ;

: ipv4-component ( str -- n )
    [ dup octal? [ oct> ] [ string>number ] if ]
    [ bad-ipv4-component ] ?unless ;

: split-ipv4 ( str -- array )
    "." split [ ipv4-component ] map ;

: bubble ( array -- newarray )
    reverse 0 swap [ + 256 /mod ] map reverse nip ;

: ?bubble ( array -- array )
    dup [ 255 > ] any? [ bubble ] when ;

: join-ipv4 ( array -- str )
    [ number>string ] { } map-as "." join ;

PRIVATE>

: parse-ipv4 ( str -- byte-array )
    dup split-ipv4 dup length {
        { 1 [ { 0 0 0 } prepend ] }
        { 2 [ 1 cut { 0 0 } glue ] }
        { 3 [ 2 cut { 0 } glue ] }
        { 4 [ ] }
        [ 2drop malformed-ipv4 ]
    } case ?bubble nip B{ } like ; inline

: normalize-ipv4 ( str -- newstr )
    parse-ipv4 join-ipv4 ;

: ipv4-ntoa ( integer -- ip )
    { -24 -16 -8 0 } [ 8 shift-mod ] with map join-ipv4 ;

: ipv4-aton ( ip -- integer )
    parse-ipv4 { 24 16 8 0 } [ shift ] [ + ] 2map-reduce ;

ERROR: bad-ipv6-component obj ;

ERROR: bad-ipv4-embedded-prefix obj ;

ERROR: more-than-8-components ;

<PRIVATE

: ipv6-component ( str -- n )
    [ hex> ] [ bad-ipv6-component ] ?unless ;

: split-ipv6 ( string -- seq )
    ":" split CHAR: . over last member? [ unclip-last ] [ f ] if
    [ [ ipv6-component ] map ]
    [ [ parse-ipv4 append ] unless-empty ] bi* ;

: pad-ipv6 ( string1 string2 -- seq )
    2dup 2length + 8 swap -
    dup 0 < [ more-than-8-components ] when
    <byte-array> glue ;

PRIVATE>

: parse-ipv6 ( string -- seq )
    "%" split1 drop ! XXX: parse the zone-id
    "::" split1 [ [ f ] [ split-ipv6 ] if-empty ] bi@ pad-ipv6 ;

: ipv6-ntoa ( integer -- ip )
    16 >be bytes>hex-string 4 <groups>
    [ [ CHAR: 0 = ] trim-head ] map ":" join
    R/ [:][:]+/ "::" re-replace ;

: ipv6-aton ( ip -- integer )
    parse-ipv6 0 [ [ 16 shift ] [ + ] bi* ] reduce ;

TUPLE: ipv4-network base bits ;

M: ipv4-network present
    [ base>> ipv4-ntoa ] [ bits>> number>string ] bi "/" glue ;

GENERIC: >ipv4-network ( object -- ipv4-network )
M: ipv4-network >ipv4-network ;
M: string >ipv4-network
    "/" split1 [ ipv4-aton ] [ string>number ] bi* ipv4-network boa ;

: ipv4-contains? ( ipv4 ipv4-network -- ? )
    [ dup string? [ ipv4-aton ] when ] dip
    >ipv4-network [ base>> ] [ bits>> ] bi
    [ on-bits ] [ 32 swap - shift ] bi swapd mask = ;

TUPLE: ipv6-network base bits ;

M: ipv6-network present
    [ base>> ipv6-ntoa ] [ bits>> number>string ] bi "/" glue ;

GENERIC: >ipv6-network ( object -- ipv6-network )
M: ipv6-network >ipv6-network ;
M: string >ipv6-network
    "/" split1 [ ipv6-aton ] [ string>number ] bi* ipv6-network boa ;

: ipv6-contains? ( ipv6 ipv6-network -- ? )
    [ dup string? [ ipv6-aton ] when ] dip
    >ipv6-network [ base>> ] [ bits>> ] bi
    [ on-bits ] [ 128 swap - shift ] bi swapd mask = ;
