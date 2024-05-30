program parcial;
  type
    rSesion = record
      anio: integer;
      mes: integer;
      dia: integer;
      idUsuario: integer;
      tiempo: integer;
    end;
    // Ordenado por anio, mes,dia, id
    ArchivoSesiones = file of rSesion;
  
  procedure generarInforme(var sesiones: ArchivoSesiones; anio: integer);
  var
    reg: rSesion;
    anioAct, mesAct,  diaAct, idAct: integer;
    tiempoTotalUsuarioPorDia, tiempoTotalDia, tiempoTotalMes, tiempoTotalAnio: integer;
  begin
    reset(sesiones);
    read(sesiones, reg);
    // Busco hasta encontrar el anio deseado
    while not (eof(sesiones)) and (reg.anio <> anio) do begin
      read(sesiones,reg);
    end;
    if (reg.anio = anio) then begin
      anioAct := reg.anio;
      tiempoTotalAnio := 0;
      writeln('Año: ', anioAct);
      while not (eof(sesiones)) and (anioAct = reg.anio) do begin
        mesAct := reg.mes;
        tiempoTotalMes := 0;
        writeln('Mes: ', mesAct);
        while not (eof(sesiones)) and (anioAct = reg.anio) and (mesAct = reg.mes) do begin
          diaAct := reg.dia;
          writeln('Dia: ', diaAct);
          tiempoTotalDia := 0;
          while not (eof(sesiones)) and (anioAct = reg.anio) and (mesAct = reg.mes) and (diaAct = reg.dia) do begin
            idAct := reg.id;
            tiempoTotalUsuarioPorDia := 0
            while not (eof(sesiones)) and (anioAct = reg.anio) and (mesAct = reg.mes) and (diaAct = reg.dia) and (idAct = reg.id) do begin
              tiempoTotalUsuarioPorDia := tiempoTotalUsuarioPorDia + reg.tiempo;
              read(sesiones, reg);
            end;
            writeln('Id usuario: ', idAct, ' Tiempo total de acceso en el dia: ', diaAct, ' mes: ', mesAct, ' :');
            writeln(tiempoTotalUsuarioPorDia);
            tiempoTotalDia := tiempoTotalDia + tiempoTotalUsuarioPorDia;
          end;
          writeln('Tiempo total de acceso dia: ', diaAct, ' mes: ', mesAct);
          writeln(tiempoTotalDia);
          tiempoTotalMes := tiempoTotalMes + tiempoTotalDia;
        end;
        writeln('Tiempo total de acceso mes: ', mesAct);
        writeln(tiempoTotalMes);
        tiempoTotalAnio := tiempoTotalAnio + tiempoTotalMes;
      end;
      writeln('Tiempo total de acceso anio: ', anioAct);
      writeln(tiempoTotalAnio);
    end
    else
      writeln('Anio no encontrado');
    close(sesiones);
  end;

  var
    sesiones: ArchivoSesiones;
    anio: integer;
  begin
    Assign(sesiones, 'sesiones');
    writeln('Ingrese anio sobre el que desea generar el informe');
    readln(anio);
    generarInforme(sesiones, anio);
  end.