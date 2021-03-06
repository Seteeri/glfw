(symbols 'glfw 'pico)

(local) (init)

(def 'LIB-GLFW "libglfw.so")

# Struct Specifications (for 'struct)
# assoc lists of names and spec

# 2 lists + 1 num: spec, name, sz

(de vidmode
  (width . I)
  (height . I)
  (red-bits . I)
  (green-bits . I)
  (blue-bits . I)
  (refresh-rate . I))
(def 'sz-vidmode (* 6 4))

(de build-spec (Spec)
  (make (for X Spec (link (cdr X)))))

# API

(de init @ (pass native LIB-GLFW "glfwInit" 'I))
(de window-hint @ (pass native LIB-GLFW "glfwWindowHint" NIL))
(de terminate @ (pass native LIB-GLFW "glfwTerminate" NIL))
(de get-version @ (pass native LIB-GLFW "glfwGetVersion" NIL))
(de get-version-string @ (pass native LIB-GLFW "glfwGetVersionString" 'S))
(de get-error @ (pass native LIB-GLFW "glfwGetError" 'I))

(de get-monitors @ (pass native LIB-GLFW "glfwGetMonitors" 'P))
(de get-primary-monitor @ (pass native LIB-GLFW "glfwGetPrimaryMonitor" 'P))
(de get-monitor-pos (Monitor)
  (buf Buf 8
    (let (X-Pos Buf
          Y-Pos (+ Buf 4))
      (native LIB-GLFW "glfwGetMonitorPos" NIL Monitor X-Pos Y-Pos)
      (struct Buf '(I . 2)))))
(de get-monitor-workarea (Monitor)
  (buf Buf 16
    (let (X-Pos Buf
          Y-Pos (+ Buf 4)
          Width (+ Buf 8)
          Height (+ Buf 16))
    (native LIB-GLFW "glfwGetMonitorWorkarea" NIL Monitor Buf X-Pos Y-Pos Width Height)
    (struct Buf '(I . 4)))))
(de get-monitor-physical-size (Monitor)
  (buf Buf 8
    (let (Width-MM Buf
          Height-MM (+ Buf 4))
    (native LIB-GLFW "glfwGetMonitorPhysicalSize" NIL Monitor Width-MM Height-MM)
    (struct Buf '(I . 2)))))
(de get-monitor-content-scale (Monitor)
  (buf Buf 8
    (let (X-Scale Buf
          Y-Scale (+ Buf 4))
      (native LIB-GLFW "glfwGetMonitorContentScale" NIL Monitor X-Scale Y-Scale)
      (struct Buf '(-1.0 . 2)))))
(de get-monitor-name @ (pass native LIB-GLFW "glfwGetMonitorName" 'S))
(de set-monitor-user-pointer @ (pass native LIB-GLFW "glfwSetMonitorUserPointer" NIL))
(de get-monitor-user-pointer @ (pass native LIB-GLFW "glfwGetMonitorUserPointer" 'P))
(de set-monitor-callback @ (pass native LIB-GLFW "glfwSetMonitorCallback" 'P))
(de get-video-modes (Monitor)
  (buf Buf 4
    (let (Ptr (native LIB-GLFW "glfwGetVideoModes" 'P Monitor Buf)
          Count (struct Buf 'I)
          Spec (build-spec vidmode))
      (make
        (do Count
          (link (struct Ptr Spec))
          (inc 'Ptr sz-vidmode))))))
(de get-video-mode (Monitor)
  (struct (native LIB-GLFW "glfwGetVideoMode" 'P Monitor)
    (build-spec vidmode)))

# gamma is privileged in wayland

(de create-window @ (pass native LIB-GLFW "glfwCreateWindow" 'P))
(de destroy-window @ (pass native LIB-GLFW "glfwDestroyWindow" NIL))
(de window-should-close @ (pass native LIB-GLFW "glfwWindowShouldClose" 'I))
(de set-window-should-close @ (pass native LIB-GLFW "glfwSetWindowShouldClose" NIL))
(de set-window-title @ (pass native LIB-GLFW "gflwSetWindowTitle" NIL))
(de set-window-icon @ (pass native LIB-GLFW "glfwSetWindowIcon" NIL))
(de poll-events @ (pass native LIB-GLFW "glfwPollEvents"))

(de get-framebuffer-size @ (pass native LIB-GLFW "glfwGetFramebufferSize" NIL))
(de swap-buffers @ (pass native LIB-GLFW "glfwSwapBuffers" NIL))
(de make-context-current @ (pass native LIB-GLFW "glfwMakeContextCurrent" NIL))
(de get-proc-address @ (pass native LIB-GLFW "glfwGetProcAddress" 'P))

(de set-input-mode @ (pass native LIB-GLFW "glfwSetInputMode" NIL))
(de raw-mouse-motion-supported @ (pass native LIB-GLFW "glfwRawMouseMotionSupported" 'I))
(de get-cursor-pos @ (pass native LIB-GLFW "glfwGetCursorPos" NIL))

(def '*x-cur (native "@" "malloc" 'P 8))
(def '*y-cur (native "@" "malloc" 'P 8))
(de get-cursor-pos-2 (Window)
  (native LIB-GLFW "glfwGetCursorPos" NIL Window *x-cur *y-cur)
  (cons
    (struct *x-cur 1.0)
    (struct *y-cur 1.0)))

# callbacks gen
(de set-error-callback @ (pass native LIB-GLFW "glfwSetErrorCallback" 'P))
(de set-monitor-callback @ (pass native LIB-GLFW "glfwSetMonitorCallback" 'P))
# callbacks window
(de set-window-pos-callback @ (pass native LIB-GLFW "glfwSetWindowPosCallback" 'P))
(de set-window-size-callback @ (pass native LIB-GLFW "glfwSetWindowSizeCallback" 'P))
(de set-window-close-callback @ (pass native LIB-GLFW "glfwSetWindowCloseCallback" 'P))
(de set-window-refresh-callback @ (pass native LIB-GLFW "glfwSetWindowRefreshCallback" 'P))
(de set-window-focus-callback @ (pass native LIB-GLFW "glfwSetWindowFocusCallback" 'P))
(de set-window-iconify-callback @ (pass native LIB-GLFW "glfwSetWindowIconifyCallback" 'P))
(de set-window-maximize-callback @ (pass native LIB-GLFW "glfwSetWindowMaximizeCallback" 'P))
(de set-framebuffer-size-callback @ (pass native LIB-GLFW "glfwSetFramebufferSizeCallback" 'P))
(de set-window-content-scale-callback @ (pass native LIB-GLFW "glfwSetWindowContentScaleCallback" 'P))
# callbacks input
(de set-key-callback @ (pass native LIB-GLFW "glfwSetKeyCallback" 'P))
(de set-char-callback @ (pass native LIB-GLFW "glfwSetCharCallback" 'P))
(de set-char-mods-callback @ (pass native LIB-GLFW "glfwSetCharModsCallback" 'P))
(de set-mouse-button-callback @ (pass native LIB-GLFW "glfwSetMouseButtonCallback" 'P))
(de set-cursor-pos-callback @ (pass native LIB-GLFW "glfwSetCursorPosCallback" 'P))
(de set-cursor-enter-callback @ (pass native LIB-GLFW "glfwSetCursorEnterCallback" 'P))
(de set-scroll-callback @ (pass native LIB-GLFW "glfwSetScrollCallback" 'P))
(de set-drop-callback @ (pass native LIB-GLFW "glfwSetDropCallback" 'P))
(de set-joystick-callback @ (pass native LIB-GLFW "glfwSetJoystickCallback" 'P))

# Tokens
(def 'TRUE                        1)
(def 'FALSE                       0)
(def 'RELEASE                     0)
(def 'PRESS                       1)
(def 'REPEAT                      2)

(def 'MOUSE-BUTTON-1              0)
(def 'MOUSE-BUTTON-2              1)
(def 'MOUSE-BUTTON-3              2)
(def 'MOUSE-BUTTON-4              3)
(def 'MOUSE-BUTTON-5              4)
(def 'MOUSE-BUTTON-6              5)
(def 'MOUSE-BUTTON-7              6)
(def 'MOUSE-BUTTON-8              7)
(def 'MOUSE-BUTTON-LAST           MOUSE-BUTTON-8)
(def 'MOUSE-BUTTON-LEFT           MOUSE-BUTTON-1)
(def 'MOUSE-BUTTON-RIGHT          MOUSE-BUTTON-2)
(def 'MOUSE-BUTTON-MIDDLE         MOUSE-BUTTON-3)

# GLFW does not define a button for scroll so create custom mapping
# Use MOUSE-BUTTON-LAST+
# From xev, up=4, dn=5 so up=MOUSE-BUTTON-LAST+1 dn=MOUSE-BUTTON-LAST+2
# F = 4
# B = 5
# L = 6
# R = 7
(def 'MOUSE-SCROLL-UP             (+ MOUSE-BUTTON-LAST 1))
(def 'MOUSE-SCROLL-DOWN           (+ MOUSE-BUTTON-LAST 2))
(def 'MOUSE-SCROLL-LEFT           (+ MOUSE-BUTTON-LAST 3))
(def 'MOUSE-SCROLL-RIGHT          (+ MOUSE-BUTTON-LAST 4))

# custom event
(def 'MOUSE-POINTER-POS           (+ MOUSE-BUTTON-LAST 5))

(def 'HAT-CENTERED                0)
(def 'HAT-UP                      1)
(def 'HAT-RIGHT                   2)
(def 'HAT-DOWN                    4)
(def 'HAT-LEFT                    8)
(def 'HAT-RIGHT-UP                (| HAT-RIGHT HAT-UP))
(def 'HAT-RIGHT-DOWN              (| HAT-RIGHT HAT-DOWN))
(def 'HAT-LEFT-UP                 (| HAT-LEFT  HAT-UP))
(def 'HAT-LEFT-DOWN               (| HAT-LEFT  HAT-DOWN))

(def 'KEY-UNKNOWN                 -1)
(def 'KEY-SPACE                   32)
(def 'KEY-APOSTROPHE              39)
(def 'KEY-COMMA                   44)
(def 'KEY-MINUS                   45)
(def 'KEY-PERIOD                  46)
(def 'KEY-SLASH                   47)
(def 'KEY-0                       48)
(def 'KEY-1                       49)
(def 'KEY-2                       50)
(def 'KEY-3                       51)
(def 'KEY-4                       52)
(def 'KEY-5                       53)
(def 'KEY-6                       54)
(def 'KEY-7                       55)
(def 'KEY-8                       56)
(def 'KEY-9                       57)
(def 'KEY-SEMICOLON               59)
(def 'KEY-EQUAL                   61)
(def 'KEY-A                       65)
(def 'KEY-B                       66)
(def 'KEY-C                       67)
(def 'KEY-D                       68)
(def 'KEY-E                       69)
(def 'KEY-F                       70)
(def 'KEY-G                       71)
(def 'KEY-H                       72)
(def 'KEY-I                       73)
(def 'KEY-J                       74)
(def 'KEY-K                       75)
(def 'KEY-L                       76)
(def 'KEY-M                       77)
(def 'KEY-N                       78)
(def 'KEY-O                       79)
(def 'KEY-P                       80)
(def 'KEY-Q                       81)
(def 'KEY-R                       82)
(def 'KEY-S                       83)
(def 'KEY-T                       84)
(def 'KEY-U                       85)
(def 'KEY-V                       86)
(def 'KEY-W                       87)
(def 'KEY-X                       88)
(def 'KEY-Y                       89)
(def 'KEY-Z                       90)
(def 'KEY-LEFT-BRACKET            91)
(def 'KEY-BACKSLASH               92)
(def 'KEY-RIGHT-BRACKET           93)
(def 'KEY-GRAVE-ACCENT            96)
(def 'KEY-WORLD-1                 161)
(def 'KEY-WORLD-2                 162)
(def 'KEY-ESCAPE                  256)
(def 'KEY-ENTER                   257)
(def 'KEY-TAB                     258)
(def 'KEY-BACKSPACE               259)
(def 'KEY-INSERT                  260)
(def 'KEY-DELETE                  261)
(def 'KEY-RIGHT                   262)
(def 'KEY-LEFT                    263)
(def 'KEY-DOWN                    264)
(def 'KEY-UP                      265)
(def 'KEY-PAGE-UP                 266)
(def 'KEY-PAGE-DOWN               267)
(def 'KEY-HOME                    268)
(def 'KEY-END                     269)
(def 'KEY-CAPS-LOCK               280)
(def 'KEY-SCROLL-LOCK             281)
(def 'KEY-NUM-LOCK                282)
(def 'KEY-PRINT-SCREEN            283)
(def 'KEY-PAUSE                   284)
(def 'KEY-F1                      290)
(def 'KEY-F2                      291)
(def 'KEY-F3                      292)
(def 'KEY-F4                      293)
(def 'KEY-F5                      294)
(def 'KEY-F6                      295)
(def 'KEY-F7                      296)
(def 'KEY-F8                      297)
(def 'KEY-F9                      298)
(def 'KEY-F10                     299)
(def 'KEY-F11                     300)
(def 'KEY-F12                     301)
(def 'KEY-F13                     302)
(def 'KEY-F14                     303)
(def 'KEY-F15                     304)
(def 'KEY-F16                     305)
(def 'KEY-F17                     306)
(def 'KEY-F18                     307)
(def 'KEY-F19                     308)
(def 'KEY-F20                     309)
(def 'KEY-F21                     310)
(def 'KEY-F22                     311)
(def 'KEY-F23                     312)
(def 'KEY-F24                     313)
(def 'KEY-F25                     314)
(def 'KEY-KP-0                    320)
(def 'KEY-KP-1                    321)
(def 'KEY-KP-2                    322)
(def 'KEY-KP-3                    323)
(def 'KEY-KP-4                    324)
(def 'KEY-KP-5                    325)
(def 'KEY-KP-6                    326)
(def 'KEY-KP-7                    327)
(def 'KEY-KP-8                    328)
(def 'KEY-KP-9                    329)
(def 'KEY-KP-DECIMAL              330)
(def 'KEY-KP-DIVIDE               331)
(def 'KEY-KP-MULTIPLY             332)
(def 'KEY-KP-SUBTRACT             333)
(def 'KEY-KP-ADD                  334)
(def 'KEY-KP-ENTER                335)
(def 'KEY-KP-EQUAL                336)
(def 'KEY-LEFT-SHIFT              340)
(def 'KEY-LEFT-CONTROL            341)
(def 'KEY-LEFT-ALT                342)
(def 'KEY-LEFT-SUPER              343)
(def 'KEY-RIGHT-SHIFT             344)
(def 'KEY-RIGHT-CONTROL           345)
(def 'KEY-RIGHT-ALT               346)
(def 'KEY-RIGHT-SUPER             347)
(def 'KEY-MENU                    348)
(def 'KEY-LAST                    KEY-MENU)

(def 'MOD-SHIFT                   (hex "0001"))
(def 'MOD-CONTROL                 (hex "0002"))
(def 'MOD-ALT                     (hex "0004"))
(def 'MOD-SUPER                   (hex "0008"))
(def 'MOD-CAPS-LOCK               (hex "0010"))
(def 'MOD-NUM-LOCK                (hex "0020"))

(def 'JOYSTICK-1                  0)
(def 'JOYSTICK-2                  1)
(def 'JOYSTICK-3                  2)
(def 'JOYSTICK-4                  3)
(def 'JOYSTICK-5                  4)
(def 'JOYSTICK-6                  5)
(def 'JOYSTICK-7                  6)
(def 'JOYSTICK-8                  7)
(def 'JOYSTICK-9                  8)
(def 'JOYSTICK-10                 9)
(def 'JOYSTICK-11                 10)
(def 'JOYSTICK-12                 11)
(def 'JOYSTICK-13                 12)
(def 'JOYSTICK-14                 13)
(def 'JOYSTICK-15                 14)
(def 'JOYSTICK-16                 15)
(def 'JOYSTICK-LAST               JOYSTICK-16)

(def 'GAMEPAD-BUTTON-A            0)
(def 'GAMEPAD-BUTTON-B            1)
(def 'GAMEPAD-BUTTON-X            2)
(def 'GAMEPAD-BUTTON-Y            3)
(def 'GAMEPAD-BUTTON-LEFT-BUMPER  4)
(def 'GAMEPAD-BUTTON-RIGHT-BUMPER 5)
(def 'GAMEPAD-BUTTON-BACK         6)
(def 'GAMEPAD-BUTTON-START        7)
(def 'GAMEPAD-BUTTON-GUIDE        8)
(def 'GAMEPAD-BUTTON-LEFT-THUMB   9)
(def 'GAMEPAD-BUTTON-RIGHT-THUMB  10)
(def 'GAMEPAD-BUTTON-DPAD-UP      11)
(def 'GAMEPAD-BUTTON-DPAD-RIGHT   12)
(def 'GAMEPAD-BUTTON-DPAD-DOWN    13)
(def 'GAMEPAD-BUTTON-DPAD-LEFT    14)
(def 'GAMEPAD-BUTTON-LAST         GAMEPAD-BUTTON-DPAD-LEFT)
(def 'GAMEPAD-BUTTON-CROSS        GAMEPAD-BUTTON-A)
(def 'GAMEPAD-BUTTON-CIRCLE       GAMEPAD-BUTTON-B)
(def 'GAMEPAD-BUTTON-SQUARE       GAMEPAD-BUTTON-X)
(def 'GAMEPAD-BUTTON-TRIANGLE     GAMEPAD-BUTTON-Y)
(def 'GAMEPAD-AXIS-LEFT-X         0)
(def 'GAMEPAD-AXIS-LEFT-Y         1)
(def 'GAMEPAD-AXIS-RIGHT-X        2)
(def 'GAMEPAD-AXIS-RIGHT-Y        3)
(def 'GAMEPAD-AXIS-LEFT-TRIGGER   4)
(def 'GAMEPAD-AXIS-RIGHT-TRIGGER  5)
(def 'GAMEPAD-AXIS-LAST           GAMEPAD-AXIS-RIGHT-TRIGGER)

(def 'NO-ERROR                    (hex "0"))
(def 'NOT-INITIALIZED             (hex "00010001"))
(def 'NO-CURRENT-CONTEXT          (hex "00010002"))
(def 'INVALID-ENUM                (hex "00010003"))
(def 'INVALID-VALUE               (hex "00010004"))
(def 'OUT-OF-MEMORY               (hex "00010005"))
(def 'API-UNAVAILABLE             (hex "00010006"))
(def 'VERSION-UNAVAILABLE         (hex "00010007"))
(def 'PLATFORM-ERROR              (hex "00010008"))
(def 'FORMAT-UNAVAILABLE          (hex "00010009"))
(def 'NO-WINDOW-CONTEXT           (hex "0001000A"))
(def 'FOCUSED                     (hex "00020001"))
(def 'ICONIFIED                   (hex "00020002"))
(def 'RESIZABLE                   (hex "00020003"))
(def 'VISIBLE                     (hex "00020004"))
(def 'DECORATED                   (hex "00020005"))
(def 'AUTO-ICONIFY                (hex "00020006"))
(def 'FLOATING                    (hex "00020007"))
(def 'MAXIMIZED                   (hex "00020008"))
(def 'CENTER-CURSOR               (hex "00020009"))
(def 'TRANSPARENT-FRAMEBUFFER     (hex "0002000A"))
(def 'HOVERED                     (hex "0002000B"))
(def 'RED-BITS                    (hex "00021001"))
(def 'GREEN-BITS                  (hex "00021002"))
(def 'BLUE-BITS                   (hex "00021003"))
(def 'ALPHA-BITS                  (hex "00021004"))
(def 'DEPTH-BITS                  (hex "00021005"))
(def 'STENCIL-BITS                (hex "00021006"))
(def 'ACCUM-RED-BITS              (hex "00021007"))
(def 'ACCUM-GREEN-BITS            (hex "00021008"))
(def 'ACCUM-BLUE-BITS             (hex "00021009"))
(def 'ACCUM-ALPHA-BITS            (hex "0002100A"))
(def 'AUX-BUFFERS                 (hex "0002100B"))
(def 'STEREO                      (hex "0002100C"))
(def 'SAMPLES                     (hex "0002100D"))
(def 'SRGB-CAPABLE                (hex "0002100E"))
(def 'REFRESH-RATE                (hex "0002100F"))
(def 'DOUBLEBUFFER                (hex "00021010"))
(def 'CLIENT-API                  (hex "00022001"))
(def 'CONTEXT-VERSION-MAJOR       (hex "00022002"))
(def 'CONTEXT-VERSION-MINOR       (hex "00022003"))
(def 'CONTEXT-REVISION            (hex "00022004"))
(def 'CONTEXT-ROBUSTNESS          (hex "00022005"))
(def 'OPENGL-FORWARD-COMPAT       (hex "00022006"))
(def 'OPENGL-DEBUG-CONTEXT        (hex "00022007"))
(def 'OPENGL-PROFILE              (hex "00022008"))
(def 'CONTEXT-RELEASE-BEHAVIOR    (hex "00022009"))
(def 'CONTEXT-NO-ERROR            (hex "0002200A"))
(def 'CONTEXT-CREATION-API        (hex "0002200B"))
(def 'COCOA-RETINA-FRAMEBUFFER    (hex "00023001"))
(def 'COCOA-FRAME-NAME            (hex "00023002"))
(def 'COCOA-GRAPHICS-SWITCHING    (hex "00023003"))
(def 'X11-CLASS-NAME              (hex "00024001"))
(def 'X11-INSTANCE-NAME           (hex "00024002"))
(def 'NO-API                      (hex "0"))
(def 'OPENGL-API                  (hex "00030001"))
(def 'OPENGL-ES-API               (hex "00030002"))
(def 'NO-ROBUSTNESS               (hex "0"))
(def 'NO-RESET-NOTIFICATION       (hex "00031001"))
(def 'LOSE-CONTEXT-ON-RESET       (hex "00031002"))
(def 'OPENGL-ANY-PROFILE          (hex "0"))
(def 'OPENGL-CORE-PROFILE         (hex "00032001"))
(def 'OPENGL-COMPAT-PROFILE       (hex "00032002"))
(def 'CURSOR                      (hex "00033001"))
(def 'STICKY-KEYS                 (hex "00033002"))
(def 'STICKY-MOUSE-BUTTONS        (hex "00033003"))
(def 'LOCK-KEY-MODS               (hex "00033004"))
(def 'RAW-MOUSE-MOTION            (hex "00033005"))
(def 'CURSOR-NORMAL               (hex "00034001"))
(def 'CURSOR-HIDDEN               (hex "00034002"))
(def 'CURSOR-DISABLED             (hex "00034003"))
(def 'ANY-RELEASE-BEHAVIOR        (hex "0"))
(def 'RELEASE-BEHAVIOR-FLUSH      (hex "00035001"))
(def 'RELEASE-BEHAVIOR-NONE       (hex "00035002"))
(def 'NATIVE-CONTEXT-API          (hex "00036001"))
(def 'EGL-CONTEXT-API             (hex "00036002"))
(def 'OSMESA-CONTEXT-API          (hex "00036003"))
(def 'ARROW-CURSOR                (hex "00036001"))
(def 'IBEAM-CURSOR                (hex "00036002"))
(def 'CROSSHAIR-CURSOR            (hex "00036003"))
(def 'HAND-CURSOR                 (hex "00036004"))
(def 'HRESIZE-CURSOR              (hex "00036005"))
(def 'VRESIZE-CURSOR              (hex "00036006"))
(def 'CONNECTED                   (hex "00040001"))
(def 'DISCONNECTED                (hex "00040002"))
(def 'JOYSTICK-HAT-BUTTONS        (hex "00050001"))
(def 'COCOA-CHDIR-RESOURCES       (hex "00051001"))
(def 'COCOA-MENUBAR               (hex "00051002"))
(def 'DONT-CARE                   (hex "-1"))
