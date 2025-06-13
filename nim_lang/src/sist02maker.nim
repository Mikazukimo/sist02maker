import jester,nimja,os,httpclient,strutils,xmlparser,xmltree,json
const NDL_URL = "https://ndlsearch.ndl.go.jp/api/opensearch?"
const DOI_JaLC_URL = "https://api.japanlinkcenter.org/dois/"

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
      let ans = author & ". " & title & ". " & publisher & ", " & date & "."
      echo ans
      return ans
  except HttpRequestError as e:
      echo "リクエスト失敗: ", e.msg
      let ans = "ERROR"
      return ans

proc doi_searcher(doi:string):string=
    let queryParams = doi
    echo DOI_JaLC_URL & queryParams
    try:
        var title, author, publisher, date,volume,issue,first_page,last_page: string
        var author_list : seq[string]
        let client = newHttpClient()
        let response = client.getContent(DOI_JaLC_URL & queryParams)
        let jsonNode = parseJson(response)
        doAssert jsonNode.kind == JObject
        #title取得
        title = jsonNode["data"]["title_list"][0]["title"].getStr
        #author取得
        var i = 0
        while true:
            try :
                var last_name,first_name:string
                var x = 0
                for i in jsonNode["data"]["creator_list"][i]["names"]:
                    if x == 1:
                        break
                    else :
                        last_name = i["last_name"].getStr
                        first_name = i["first_name"].getStr
                        author_list.add(last_name&" "&first_name)
                        x = x+1
                i = i+1
            except IndexDefect:
                break
        author = author_list.join(", ")
        #publisher, date,volume,issue,first_page,last_page取得
        publisher = jsonNode["data"]["journal_title_name_list"][0]["journal_title_name"].getStr
        date = jsonNode["data"]["recorded_year"].getStr
        volume = jsonNode["data"]["volume"].getStr
        issue = jsonNode["data"]["issue"].getStr
        first_page = jsonNode["data"]["first_page"].getStr
        last_page = jsonNode["data"]["last_page"].getStr
        echo author & ". " & title & ". " & publisher & ", " & date & ", vol." & volume & ", no." & issue & ", p." & first_page & "-" & last_page & "."
        let ans = author & ". " & title & ". " & publisher & ", " & date & ", vol." & volume & ", no." & issue & ", p." & first_page & "-" & last_page & "."
        return ans
    except HttpRequestError as e:
        echo "リクエスト失敗: ", e.msg
        let ans = "ERROR"
        return ans


proc renderIndex(title:string): string =
  compileTemplateFile("./templates/index.nimja", baseDir = getScriptDir)

proc renderAns(respons_isbn:string,respons_doi:string): string =
  compileTemplateFile("./templates/ans.nimja", baseDir = getScriptDir)

routes:
  get "/":
    let title = "Sist02 Maker"
    resp renderIndex(title)

  post "/sist02":
    let raw_isbn: string = request.params["isbn"]
    let raw_doi: string = request.params["doi"]
    var isbn,respons_isbn,respons_doi = ""
    if raw_isbn != "":
        isbn = raw_isbn.replace("-", "")
        respons_isbn = isbn_searcher(isbn)
    if raw_doi != "":
        respons_doi = doi_searcher(raw_doi)
    resp renderAns(respons_isbn,respons_doi)

runForever()