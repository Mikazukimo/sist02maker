import httpclient,strutils,xmlparser,xmltree
const NDL_URL = "https://ndlsearch.ndl.go.jp/api/opensearch?"

# パラメータ例
let queryParams = "isbn="&"'9784787200884'"

# クライアントを作成
var client = newHttpClient()
echo NDL_URL & queryParams
try:
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
    let result = author & ".'" & title & "'." & publisher & "." & date & "."
    echo result
except HttpRequestError as e:
    echo "リクエスト失敗: ", e.msg
