import jester,nimja, os

proc renderIndex(title:string): string =
  compileTemplateFile("./templates/index.nimja", baseDir = getScriptDir)

routes:
  get "/":
    let title = "Nim Language - Sist02 Maker"
    resp renderIndex(title)

runForever()