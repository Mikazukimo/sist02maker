import httpclient,strutils,json
const DOI_JaLC_URL = "https://api.japanlinkcenter.org/dois/"

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
    except HttpRequestError as e:
        echo "リクエスト失敗: ", e.msg
        let ans = "ERROR"
        return ans
let query = "10.20651/jslis.65.2_84"
discard doi_searcher(query)