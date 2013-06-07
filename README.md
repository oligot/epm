epm
===

### Introduction

epm is an Eiffel Package Manager that is based on [npm](http://npmjs.org/) and [bower](http://twitter.github.com/bower/).
epm lets you easily install Eiffel dependencies.

For example, to install a package, run:

    epm sync gobo

This will install gobo to `./eiffel_library/gobo`.
That's it.
The idea is that epm does package management and package management only.

### Installing epm

For the moment, you have to compile epm on your computer.
To compile epm, you will need:
* A recent version of EiffelStudio (7.0 or newer)
* A recent git version of Gobo (https://github.com/oligot/gobo/tree/epm)
* Gobo ecf files (https://github.com/oligot/gobo-ecf)
* The Eiffel JSON library compatible with the Gobo Eiffel Compiler (https://github.com/oligot/json/tree/gec)

The easiest way to get these dependencies is to run the script _bootstrap.sh_ on Unix and _bootstrap.bat_ on Windows.

### Usage

Your best friend at this stage is probably `epm --help`.

To install or update a package:

    epm sync gobo

As you can see, packages can only be installed by name.

### Defining a package

You can create a `system.json` file in your project's root, specifying all of its dependencies.
This is similar to Node's `package.json`, or Ruby's `Gemfile`, and is useful for locking down a project's dependencies.

```json
{
  "name": "myProject",
  "version": "1.0.0",
  "dependencies": {
    "gobo": "https://github.com/gobo-eiffel/gobo.git"
  }
}
```

Put this under your project's root, listing all of your dependencies.
When you run `epm sync`, epm will read this `system.json` file, resolve all the relevant dependencies and install them.

For now, `name`, `version` and `dependencies` are the only properties that are used by epm.
For the moment, you can only point to packages by adding their Git URL in the dependency's property.
When tags or branches are available in the endpoint, you can specify them like this:

```json
{
  "dependencies": {
    "gobo": "https://github.com/gobo-eiffel/gobo.git#gobo-3.9"
  }
}
```

### Installing dependencies

Dependencies are installed locally via the `epm sync` command.
They are fetched and checked out in a local subdirectory called `./eiffel\_library`, for example:


```
/eiffel_library/gobo
/eiffel_library/json
```

You can also install packages one at a time with `epm sync json`

### Windows users

People may experience problems using epm on Windows because [msysgit](http://code.google.com/p/msysgit/) must be installed correctly.
Be sure to check the option shown above, otherwise it will simply not work:

![msysgit](http://f.cl.ly/items/2V2O3i1p3R2F1r2v0a12/mysgit.png)

### Authors

+ [@oligot](http://github.com/oligot)

## License

Copyright 2013- Olivier Ligot

Licensed under the MIT License
