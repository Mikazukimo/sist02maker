import jester,nimja, os

proc renderIndex(title:string): string =
  compileTemplateFile("./templates/index.nimja", baseDir = getScriptDir)

routes:
  get "/":
    let title = "Nimja Template Example"
    resp renderIndex(title)
runForever()