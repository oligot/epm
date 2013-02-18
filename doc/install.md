epm-install(1) -- Install a package dependencies
================================================

## SYNOPSIS

    epm install (with no args in a package dir)
    epm install <name> [<name> ...]

## DESCRIPTION

This command installs a package dependencies.

`Package dependencies` are:

* a) a folder containing a program described by a system.json file
* b) some `<name>`

Even if you never publish your package, you can still get a lot of
benefits of using epm if you just want to write an Eiffel program (a).


* `epm install` (in package directory, no arguments):

  Install the dependencies in the local $EIFFEL_LIBRARY folder.

* `epm install <name> [<name> ...]`:

    Do a `<name> [<name> ...]` install.

    This will install the latest version of the listed dependencies.

    Example:

          epm install gobo json

## SEE ALSO

* epm-folders(1)
