import Foundation
import TidyLog

func initTidyLogging() {
    TidyLog.instance().markAsRootFile()
    TidyLog.instance().setLevel(.VERBOSE)
}
initTidyLogging()

let testObject = test()
testObject.resetLevel()
testObject.testLogging()
