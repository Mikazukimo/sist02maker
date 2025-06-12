import jester,nimja, os

proc renderIndex(title:string): string =
  compileTemplateFile("./templates/index.nimja", baseDir = getScriptDir)

routes:
  get "/":
    let title = "this is demo site"
    resp renderIndex(title)
runForever()