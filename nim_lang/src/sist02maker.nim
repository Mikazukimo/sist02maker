import jester,nimja, os

proc renderIndex(title:string): string =
  compileTemplateFile("./templates/index.nimja", baseDir = getScriptDir)
  echo "done"

routes:
  get "/":
    let title = "Nimja Template Example"
    echo title
    resp renderIndex(title)

runForever()