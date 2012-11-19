epm-install(1) -- Install a package dependencies
================================================

## SYNOPSIS

    epm install (with no args in a package dir)

## DESCRIPTION

This command installs a package dependencies.

A `package` is:

* a) a folder containing a program described by a package.json file

Even if you never publish your package, you can still get a lot of
benefits of using epm if you just want to write an Eiffel program (a).


* `epm install` (in package directory, no arguments):

  Install the dependencies in the local $EIFFEL_LIBRARY folder.
