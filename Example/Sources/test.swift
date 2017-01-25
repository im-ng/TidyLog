#if os(OSX) || os(iOS)
    import Darwin
#elseif os(Linux)
    import Glibc
#endif

import Foundation
import TidyLog

//Non main file
struct test {
    func resetLevel() {
        TidyLog.instance().setLevel(.FATAL)
    }

    func testLogging() {
      for _ in 1...10 {
          switch (random() % 5) {
            case 1:
              TidyLog.v("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book")
            case 2:
              TidyLog.d("Some debug happened")
            case 3:
              TidyLog.i("Put up some information")
            case 4:
              TidyLog.e("Error happened on server request")
            case 5:
              TidyLog.f("App crashed")
            default:
              TidyLog.d("Some debug happened")
          }
      }
    }

    func testJSON() {
        TidyLog.json("{\"address\":{\"streetAddress\": \"Some street\",\"city\": \"Chennai\"},\"phoneNumber\": [{\"location\": \"home\",\"code\": 44}]}")
    }
}
