(texto as text, optional caracter as text) =>
/* Función que sustituye todos los espacios en blanco de un texto por un carácter */
let
    caracterFinal = if caracter = null then " " else caracter,
    nbsp = if caracterFinal=" " then Character.FromNumber(160) else "",
    split = Text.SplitAny(texto, caracterFinal & nbsp),
    EliminaEspacios = List.Select(split, each _ <> ""),
    Resultado = Text.Combine(EliminaEspacios, caracterFinal),
    Sustituye = Text.Replace(Resultado," ","")
in Sustituye
