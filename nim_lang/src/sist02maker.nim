import jester,nimja, os

proc renderIndex(): string =
  compileTemplateFile("./templates/test.html", baseDir = getScriptDir())

routes:
  get "/":
    resp renderIndex()
    #resp compileTemplateFile("./templates/test.html", baseDir = getScriptDir())
    

runForever()