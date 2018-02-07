/*
        Crea unta tabla de fechas con diferentes columnas a partir de una tabla de hechos.
		Parámetros:
			TablaOrigen: la tabla de hechos sobre la que queremos asociar la tabla de fechas
			CampoFecha: nombre del campo que contiene la fecha de la tabla de hechos
	*/

let CreaTablaFechas = (TablaOrigen as table, CampoFecha as text) as table =>
  let
    FechaInicio = List.Min(Table.Column(TablaOrigen, CampoFecha)),
    FechaFin = List.Max(Table.Column(TablaOrigen, CampoFecha)),
    NumeroDeDias = Duration.Days(Duration.From(FechaFin - FechaInicio)),
    Origen = List.Dates(FechaInicio,NumeroDeDias,#duration(1,0,0,0)),
    Tabla= Table.FromList(Origen, Splitter.SplitByNothing()),
    CambiATipoFecha= Table.TransformColumnTypes(Tabla,{{"Column1", type date}}),
    CambiarNombreCampo = Table.RenameColumns(CambiATipoFecha,{{"Column1", "Fecha"}}),
    InsertaAnyo = Table.AddColumn(CambiarNombreCampo, "Año", each Date.Year([Fecha])),
    InsertaTrimestre = Table.AddColumn(InsertaAnyo, "Trimestre", each Date.QuarterOfYear([Fecha])),
    InsertaMes = Table.AddColumn(InsertaTrimestre, "Mes", each Date.Month([Fecha])),
    InsertaDia = Table.AddColumn(InsertaMes, "Día", each Date.Day([Fecha])),
    InsertDiaInt = Table.AddColumn(InsertaDia, "Año-Mes-Día", each [Año] * 10000 + [Mes] * 100 + [Día]),
    InsertaNombreMes = Table.AddColumn(InsertDiaInt, "Nombre del mes tmp", each Date.ToText([Fecha], "MMMM"), type text),
    CambiaNombreMes = Table.AddColumn(InsertaNombreMes, "Nombre del mes", each Text.Upper(Text.Range([Nombre del mes tmp], 0, 1)) & Text.Range([Nombre del mes tmp], 1, Text.Length([Nombre del mes tmp])-1)),
    EliminarMesTmp = Table.RemoveColumns(CambiaNombreMes,{"Nombre del mes tmp"}),
    InsertaMesAnyo = Table.AddColumn(EliminarMesTmp, "MesAño", each (try(Text.Range([Nombre del mes],0,3)) otherwise [Nombre del mes]) & " " & Number.ToText([Año])),
    InsertaNombreTrim = Table.AddColumn(InsertaMesAnyo, "Nombre Trimestre", each "Q" & Number.ToText([Trimestre]) & " " & Number.ToText([Año])),
    InsertaDiaSemana = Table.AddColumn(InsertaNombreTrim, "Num. Dia de la semana", each Date.DayOfWeek([Fecha])),
    InsertaNombreDiaSem = Table.AddColumn(InsertaDiaSemana, "Día de la semana tmp", each Date.ToText([Fecha], "dddd"), type text),
    CambiaNombreDiaSem = Table.AddColumn(InsertaNombreDiaSem, "Día de la semana", each Text.Upper(Text.Range([Día de la semana tmp], 0, 1)) & Text.Range([Día de la semana tmp], 1, Text.Length([Día de la semana tmp])-1)),
    EliminarColTmp = Table.RemoveColumns(CambiaNombreDiaSem,{"Día de la semana tmp"}),
    OrdenMes = Table.AddColumn(EliminarColTmp, "OrdenMes", each Number.ToText(Date.Month([Fecha])) & Number.ToText([Año]))
  in
    OrdenMes 
in
  CreaTablaFechas
