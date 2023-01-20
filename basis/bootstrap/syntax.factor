! Copyright (C) 2007, 2008 Slava Pestov.
! See https://factorcode.org/license.txt for BSD license.
USING: words words.symbol sequences vocabs kernel
compiler.units ;
IN: bootstrap.syntax

[
    "syntax" create-vocab drop

    {
        "\""
        "("
        ":"
        ";"
        "<PRIVATE"
        "B{"
        "BV{"
        "C:"
        "CHAR:"
        "DEFER:"
        "ERROR:"
        "FORGET:"
        "GENERIC#:"
        "GENERIC:"
        "HOOK:"
        "H{"
        "HS{"
        "IH{"
        "IN:"
        "INSTANCE:"
        "M:"
        "MAIN:"
        "MATH:"
        "MIXIN:"
        "NAN:"
        "P\""
        "POSTPONE:"
        "PREDICATE:"
        "PRIMITIVE:"
        "PRIVATE>"
        "SBUF\""
        "SINGLETON:"
        "SINGLETONS:"
        "BUILTIN:"
        "SYMBOL:"
        "SYMBOLS:"
        "INITIALIZE:"
        "CONSTANT:"
        "TUPLE:"
        "final"
        "SLOT:"
        "T{"
        "UNION:"
        "INTERSECTION:"
        "REUSE:"
        "USE:"
        "UNUSE:"
        "USING:"
        "QUALIFIED:"
        "QUALIFIED-WITH:"
        "FROM:"
        "EXCLUDE:"
        "RENAME:"
        "ALIAS:"
        "SYNTAX:"
        "V{"
        "W{"
        "["
        "\\"
        "M\\"
        "]"
        "auto-use"
        "delimiter"
        "deprecated"
        "f"
        "flushable"
        "foldable"
        "inline"
        "recursive"
        "t"
        "{"
        "}"
        "CS{"
        "<<"
        ">>"
        "call-next-method"
        "not{"
        "maybe{"
        "union{"
        "intersection{"
        "initial:"
        "read-only"
        "call("
        "execute("
        "<<<<<<"
        "======"
        ">>>>>>"
        "<<<<<<<"
        "======="
        ">>>>>>>"
        "'["
        "'{"
        "'H{"
        "'HS{"
        "_"
        "@"
        "MACRO:"
        "MEMO:"
        "IDENTITY-MEMO:"
        ":>"
        "[|"
        "[let"
        "::"
        "M::"
        "MACRO::"
        "MEMO::"
        "IDENTITY-MEMO::"
        "STARTUP-HOOK:"
        "SHUTDOWN-HOOK:"
    } [ "syntax" create-word drop ] each

    "t" "syntax" lookup-word define-symbol
] with-compilation-unit
