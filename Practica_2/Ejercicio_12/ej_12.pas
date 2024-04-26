program ej_12;
  const
    valorAlto = 9999;
  type
    rAcceso = record
      anio: integer;
      mes: 1..12;
      dia: 1..31;
      id: integer;
      tiempo: integer;
    end;

    Archivo = file of rAcceso;
  
  procedure leer(var arch: Archivo; var reg: rAcceso);
  begin
    if not (eof(arch)) then begin
      read(arch, reg);
    else
      reg.anio := valorAlto;
  end;
  
  procedure generarReporte(var arch: Archivo; anio: integer);
  var
    anioAct: integer;
    mesAct : 1..12;
    diaAct : 1..31;
    idAct : integer;
    tiempoTotalUsr: integer;
    tiempoTotalDia: integer;
    tiempoTotalMes: integer;
    tiempoTotalAnio: integer;
    reg: rAcceso;
    encontre: boolean;
  begin
    reset(arch);
    encontre := false;
    // Busco el anio correspondiente
    while (reg.anio <> anio) and (reg.anio <> valorAlto) do begin
      leer(arch, reg);
    end;
    // Analizo el anio
    while (reg.anio = anio) do begin
      encontre := true;
      tiempoTotalAnio := 0;
      writeln('Anio: ', reg.anio);
      mesAct := reg.mes;
      writeln('Mes: ', mesAct);
      tiempoTotalMes := 0;
      while (reg.anio = anio) and (mesAct = reg.mes) do begin
        diaAct := reg.dia;
        writeln('Dia: ', diaAct);
        tiempoTotalDia := 0;
        while (reg.anio = anio) and (mesAct = reg.mes) and (diaAct = reg.dia) do begin
          idAct := reg.id;
          writeln('Id usuario: ', idAct);
          tiempoTotalUsr := 0;
          while (reg.anio = anio) and (mesAct = reg.mes) and (diaAct = reg.dia) and (idAct = reg.id) do begin
            tiempoTotalUsr += reg.tiempo;
            leer(arch, reg);
          end;
          writeln('Tiempo total de acceso en el dia', diaAct, ' Mes: ', mesAct);
          writeln(tiempoTotalUsr);
          tiempoTotalDia += tiempoTotalUsr;
        end;
        writeln('Tiempo total acceso dia', diaAct, ' mes: ', mesAct);
        writeln(tiempoTotalDia);
        tiempoTotalMes += tiempoTotalDia;
      end;
      writeln('Tiempo total de acceso mes: ', mesAct);
      writeln(tiempoTotalMes);
      tiempoTotalAnio += tiempoTotalMes;
    end;
    if (encontre) then begin
      writeln('Total tiempo de acceso anio: ', anio);
      writeln(tiempoTotalAnio);
    end;
    else begin
      writeln('Anio no encontrado');
    end;
  end;

  var
    anio: integer;
    arch: Arhivo;
  begin
    Assign(arch, 'accesos');
    writeln('Ingrese el anio sobre el que se realiara el informe: ');
    readln(anio);
    generarReporte(arch, anio);
  end.