(module
    (import "" "constructor" (global $constructor externref))
    (import "" "height" (global $height externref))
    (import "" "https://example.com/" (global $url externref))
    (import "" "loadURL" (global $loadURL externref))
    (import "" "menuBarVisible" (global $menuBarVisible externref))
    (import "" "then" (global $then externref))
    (import "" "width" (global $width externref))

    (import "app" "whenReady"
        (func $app.whenReady
            (result externref)))

    (import "Array" "of"
        (func $Array.of
            (result externref)))

    (import "BrowserWindow" "prototype"
        (global $BrowserWindow.prototype externref))

    (import "Object" "create"
        (func $Object.create
            (param externref)
            (result externref)))

    (import "Promise" "prototype"
        (global $Promise.prototype externref))

    ;; Reflect.apply(target, thisArgument, argumentsList): target.apply(thisArgument, argumentsList)
    (import "Reflect" "apply"
        (func $Reflect.apply
            (param externref externref externref)
            (result externref)))

    ;; Reflect.construct(target, argumentsList): new target(...argumentsList)
    (import "Reflect" "construct"
        (func $Reflect.construct
            (param externref externref)
            (result externref)))

    ;; Reflect.get(target, propertyKey): target[propertyKey]
    (import "Reflect" "get"
        (func $Reflect.get
            (param externref externref)
            (result externref)))

    (import "Reflect" "get"
        (func $Reflect.get.i32
            (param externref i32)
            (result externref)))

    ;; Reflect.set(target, propertyKey, value): boolean
    (import "Reflect" "set"
        (func $Reflect.set
            (param externref externref externref)
            (result externref)))

    (import "Reflect" "set"
        (func $Reflect.set.ext.i32
            (param externref externref i32)
            (result externref)))

    (import "Reflect" "set"
        (func $Reflect.set.i32.ext
            (param externref i32 externref)
            (result externref)))

    (import "Reflect" "set"
        (func $Reflect.set.i32.fun
            (param externref i32 funcref)
            (result externref)))

    (func $Window.options
        (result externref)

        (local $options externref)

        (ref.null extern)
        (call $Object.create)
        (local.tee $options) ;; push $options = Object.create(null)

        (global.get $width)
        (i32.const 800)
        (call $Reflect.set.ext.i32) ;; $options.width = 800
        (drop)

        (local.get $options)
        (global.get $height)
        (i32.const 600)
        (call $Reflect.set.ext.i32) ;; $options.height = 600
        (drop)

        (local.get $options) ;; return $options
    )

    (func $Window.create
        (result externref)

        (local $args externref)
        (local $options externref)
        (local $window externref)

        (global.get $BrowserWindow.prototype)
        (global.get $constructor)
        (call $Reflect.get) ;; push BrowserWindow.prototype["constructor"]

        ;; NOTE: BrowserWindow.prototype.constructor === BrowserWindow.
        ;; Explicit `constructor` access is necessary because `BrowserWindow` serves as a namespace.

        (call $Array.of)
        (local.tee $args) ;; push $args = []

        (i32.const 0)
        (call $Window.options)
        (call $Reflect.set.i32.ext) ;; $args[0] = $Window.options
        (drop)

        (local.get $args)
        (call $Reflect.construct)
        (local.tee $window) ;; push $window = new BrowserWindow(...$args)

        (global.get $menuBarVisible)
        (i32.const 0)               ;; Numbers coerce to booleans in JS
        (call $Reflect.set.ext.i32) ;; $window.menuBarVisible = false
        (drop)

        (local.get $window) ;; return $window
    )

    (func $Window.loadURL
        (param $window externref)

        (local $args externref)

        (global.get $BrowserWindow.prototype)
        (global.get $loadURL)
        (call $Reflect.get) ;; push BrowserWindow.prototype["loadURL"]

        (call $Array.of)
        (local.tee $args) ;; push $args = []

        (i32.const 0)
        (global.get $url)
        (call $Reflect.set.i32.ext) ;; $args[0] = $url
        (drop)

        (local.get $window)
        (local.get $args)
        (call $Reflect.apply) ;; $window.loadURL(...$args)
        (drop)
    )

    (elem declare func $Window.init) ;; Allows `ref.func $foo` (see line 170)
    (func $Window.init
        (call $Window.create)
        (call $Window.loadURL)
    )

    (func $main
        (local $args externref)

        (global.get $Promise.prototype)
        (global.get $then)
        (call $Reflect.get) ;; push Promise.prototype["then"]

        (call $Array.of)
        (local.tee $args) ;; push $args = []

        (i32.const 0)
        (ref.func $Window.init)
        (call $Reflect.set.i32.fun) ;; $args[0] = $Window.init
        (drop)

        (call $app.whenReady)
        (local.get $args)
        (call $Reflect.apply) ;; app.whenReady().then(...$args)
        (drop)
    )

    (start $main) ;; Automatically call $main on initialization
)
