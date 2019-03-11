(texto as text, optional char_to_trim as text) =>

let
    char = if char_to_trim = null then " " else char_to_trim,
    nbsp = if char=" " then Character.FromNumber(160) else "",
    split = Text.SplitAny(texto, char & nbsp),
    removeblanks = List.Select(split, each _ <> ""),
    result=Text.Combine(removeblanks, char),
    SinEspacios = Text.Replace(result," ","")
in SinEspacios
