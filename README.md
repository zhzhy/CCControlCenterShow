# CCControlCenterShow

This project is triggered by [AAWindow](https://github.com/aaronabentheuer/AAWindow), which is coding with Swift. So I
have a idea to make it with Objective-C, almost one year ago, I also need to get a notification when ControlCenter show.
But more important thing come to me, it lost from me. Thanks to **AAWindow**, here I got it again, so I finish it, and also
make is more precise to change from iPhone.

In order to make it more precise, first by distance moved to detect it, when failed, with `applicationState` to trace it.
When alertView or actionSheet show, it will fail, because it derived from `UIWindow`, alertView and so on belong to 
another window. So in future it will be fix.

Welcome to report bug to me.
