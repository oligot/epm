epm-install(1) -- Install a package
===================================

## SYNOPSIS

    epm install (with no args in a package dir)
    epm install <tarball file>

## DESCRIPTION

This command installs a package.

A `package` is:

* a) a folder containing a program described by a package.json file
* b) a gzipped tarball containing (a)

Even if you never publish your package, you can still get a lot of
benefits of using epm if you just want to write an Eiffel program (a), 
and perhaps if you also want to be able to easily install it elsewhere
after packing it up into a tarball (b).


* `epm install` (in package directory, no arguments):
  It installs the current package context (ie, the current working
  directory) as a global package.

* `epm install <tarball file>`:
  Install a package that is sitting on the filesystem.

  Example:

        epm install ./package.tgz
