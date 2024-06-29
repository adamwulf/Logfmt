# Logfmt

Logfmt provides a `logfmt(object)` method on `String` instances to easily format any input object into [logfmt](https://www.brandur.org/logfmt).

Example:

``` swift

let memoryContext = ["memory":
                        ["current": ["footprint": 128,
                                     "available": 2000 - 128,
                                     "limit": 2000],
                         "peak": ["footprint": 348,
                                  "available": 2000 - 348,
                                  "limit": 2000]]]
let formatted = String.logfmt(memoryContext)
print(formatted)
```

will output:

```
memory.current.available=1872 memory.current.footprint=128 memory.current.limit=2000 memory.peak.available=1652 memory.peak.footprint=348 memory.peak.limit=2000
```

The `Logfmt` class is in progress will eventually help integrate apple's [Logging](https://github.com/apple/swift-log) framework. 
