import httpclient,strutils,json
const DOI_JaLC_URL = "https://api.japanlinkcenter.org/dois/"

proc doi_searcher(doi:string):string=
    let queryParams = doi
    echo DOI_JaLC_URL & queryParams
    try:
        let client = newHttpClient()
        let response = %* client.getContent(DOI_JaLC_URL & queryParams)
        echo $response["status"]
    except HttpRequestError as e:
        echo "リクエスト失敗: ", e.msg
        let ans = "ERROR"
        return ans


let query = "10.11514/infopro.2008.0.138.0"
discard doi_searcher(query)