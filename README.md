# TidyLog

> A simple and elegant logging mechanism for Swift based apps and web service

TidyLog features:

 - Easy to use for both platform
 - Pretty and coloured console output
 - Easy to enable/disable on productions
 - Customizable output format


## Import
Include through Swift Package Manager

```
let package = Package(
    name: "Example",
    dependencies: [
      .Package(url: "https://github.com/ng28/TidyLog.git", majorVersion:1)
    ]
)
```

```
//main.swift
import TidyLog


//Levels can be configured only from
//main.swift or AppDelegate.swift
//verbose - logs every line
TidyLog.instance().markAsRootFile()
TidyLog.instance().setLevel(.VERBOSE) //.NONE won't output anything

//set some tag to differenciate
TidyLog.instance().setTag("Example")
```

## Usage

Logging can be switched between following options

```
TidyLog.v("Some verbose log")
TidyLog.i("Some information log")
TidyLog.d("Some debug log")
TidyLog.e("Some error log")
TidyLog.f("Some fatal log")
TidyLog.json("{\"some\" : \"json\"}")
```

## Console

![Output](/resources/tidylog.example.png)

## TODO

 - File level customization
 - Log over file and rotation
 - Customize logging format
 - Extend support for json prettify
 - Support xml logging

## License

MIT License
