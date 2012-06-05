epm-pack(1) -- Create a tarball from a package
==============================================

## SYNOPSIS

    epm pack

## DESCRIPTION

For anything that's installable (that is, the current package folder), 
this command will copy the tarball to the current working directory as 
`<name>-<version>.tgz`, and then write the filenames out to stdout.
