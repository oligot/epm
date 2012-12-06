epm-scripts(1) -- How epm handles the "scripts" field
=====================================================

## DESCRIPTION

epm supports the "scripts" member of the package.json script, for the
following scripts:

* install:
  Run AFTER the package is installed.

## EXAMPLES

For example, if your package.json contains this:

    { "scripts" :
      { "install" : "./install.sh"
      }
    }

then the `install.sh` will be called for the install stage of the lifecycle.

If you want to run a make command, you can do so.  This works just fine:

    { "scripts" :
      { "install" : "make && make install"
      }
    }

## SEE ALSO

* epm-json(1)
* epm-install(1)
