import jester,nimja,os,httpclient,strutils,xmlparser,xmltree
const NDL_URL = "https://ndlsearch.ndl.go.jp/api/opensearch?"

proc isbn_searcher(isbn:string):string=
  let queryParams = "isbn='"&isbn&"'"
  echo NDL_URL & queryParams
  try:
      let client = newHttpClient()
      let response = client.getContent(NDL_URL & queryParams)
      let node = parseXml(response)
      var title, author, publisher, date: string
      for childNode in node:
          case childNode.tag
          of "channel":
              for grandchild in childNode:
                  case grandchild.tag
                  of "item":
                      for item in grandchild:
                          case item.tag
                          of "title":
                              title = item.innerText
                          of "dc:creator":
                              author = item.innerText                          
                          of "dc:publisher":
                              publisher = item.innerText
                          of "dc:date":
                              date = item.innerText
      let ans = author & ".'" & title & "'." & publisher & "." & date & "."
      echo ans
      return ans
  except HttpRequestError as e:
      echo "リクエスト失敗: ", e.msg
      let ans = "ERROR"
      return ans


proc renderIndex(title:string): string =
  compileTemplateFile("./templates/index.nimja", baseDir = getScriptDir)

proc renderAns(ans:string): string =
  compileTemplateFile("./templates/ans.nimja", baseDir = getScriptDir)

routes:
  get "/":
    let title = "Sist02 Maker"
    resp renderIndex(title)

  post "/sist02":
    let raw: string = request.params["isbn"]
    let isbn = raw.replace("-", "")
    let ans = isbn_searcher(isbn)
    resp renderAns(ans)

runForever()