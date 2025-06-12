# Issue #22

import os,  jester, asyncdispatch

routes:
  get "/":
    var html = ""
    for file in walkFiles("*.*"):
      html.add "<li>" & file & "</li>"
    html.add "<form action=\"test\" method=\"post\">"
    html.add "<input type=\"form\" name=\"file\">"
    html.add "<input type=\"submit\" value=\"Submit\" name=\"submit\">"
    html.add "</form>"
    resp(html)

  post "/test":
    resp(request.params["file"])
runForever()