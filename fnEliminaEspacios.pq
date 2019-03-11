(texto as text) =>
/* Función que elimina todos los espacios en blanco de un texto */
let
    char = " ",
    nbsp = Character.FromNumber(160),
    split = Text.SplitAny(texto, char & nbsp),
    EliminaEspacios = List.Select(split, each _ <> ""),
    Resultado = Text.Combine(EliminaEspacios, char),
    SinEspacios = Text.Replace(Resultado," ","")
in SinEspacios
