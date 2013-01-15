epm-json(1) -- Specifics of epm's package.json handling
=======================================================

## DESCRIPTION

This document is all you need to know about what's required in your package.json
file. It must be actual JSON, not just a JavaScript object literal.

## name

The *most* important things in your package.json are the name and version fields.
Those are actually required, and your package won't install without
them.  The name and version together form an identifier that is assumed
to be completely unique.  Changes to the package should come along with
changes to the version.

The name is what your thing is called.  Some tips:

* Don't put "eiffel" in the name.  It's assumed that it's eiffel, since you're
  writing a package.json file.
* The name ends up being part of a URL, an argument on the command line, and a
  folder name. Any name with non-url-safe characters will be rejected.
  Also, it can't start with a dot or an underscore.
* The name should be something short, but also reasonably descriptive.

## version

The *most* important things in your package.json are the name and version fields.
Those are actually required, and your package won't install without
them.  The name and version together form an identifier that is assumed
to be completely unique.  Changes to the package should come along with
changes to the version.

Version must conform to [semver](http://semver.org/).

## description

Put a description in it. It's a string.

## dependencies

Dependencies are specified with a simple hash of package name to version.

Version may be any of the following styles.

* `git...` See 'Git URLs as Dependencies' below

### Git URLs as Dependencies

Git urls can be of the form:

    git://github.com/user/project.git#commit-ish
    git+ssh://user@hostname:project.git#commit-ish
    git+ssh://user@hostname/project.git#commit-ish
    git+http://user@hostname/project/blah.git#commit-ish
    git+https://user@hostname/project/blah.git#commit-ish

The `commit-ish` can be any tag, sha, or branch which can be supplied as
an argument to `git checkout`.  The default is `master`.

## SEE ALSO

* epm-install(1)
