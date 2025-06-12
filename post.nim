import jester, strutils, htmlgen

routes:
  get "/":
    resp htmldoc():
      body():
        h1("名前を入力してください")
        form(action="/greet", method="post"):
          input(`type`="text", name="username")
          input(`type`="submit", value="送信")

  post "/greet":
    let name = request.params["username"]
    resp htmldoc():
      body():
        h1("こんにちは、" & escapeHtml(name) & "さん！")
        a(href="/", "戻る")
