program ej_15;
  const
    CANT_SUC = 5;
    valorAlto = 9999;
  type
    rAlumnoInscripto = record
      dni_alumno: integer;
      codigo_carrera: integer;
      monto_total_pagado: real;
    end;

    rPago = record
      dni_alumno: integer;
      codigo_carrera: integer;
      monto_cuota: real;
    end;

    ArchivoMaestro = file of rAlumnoInscripto;
    ArchivoDetalle = file of rPago;
    vector_det = array [1..CANT_SUC] of ArchivoDetalle;
    vector_regd = array [1..CANT_SUC] of rPago;
  
  procedure leerDetalle(var detalle: ArchivoDetalle; var regd: rPago);
  begin
    if not (eof(detalle)) then
      read(detalle,regd);
    else
      regd.dni_alumno = valorAlto; 
  end;

  procedure minimo(var arr_det: vector_det; var arr_regd: vector_regd; var min: rPago);
  var
    i:integer;
    posMin: integer;
    regd: rPago;
  begin
    posMin := 0;
    min.dni_alumno := valorAlto;
    for i:=1 to CANT_SUC do begin
      regd := arr_regd[i];
      if(regd.dni_alumno <> valorAlto) then begin
        if(regd.dni_alumno < min.dni_alumno) or ((regd.dni_alumno = min.dni_alumno) and (regd.codigo_carrera < min.codigo_carrera)) then begin
          min := regd;
          posMin := i;
        end;
      end;
    end;
    if (posMin <> 0) then
      leerDetalle(arr_det[posMin], arr_regd[posMin])
  end;

  procedure actualizar(var maestro: ArchivoMaestro; var arr_det: vector_det);
  var
    arr_regd : vector_regd;
    min: rPago;
    regm: rAlumnoInscripto;
    dniAct, codAct: integer;
    i: integer;
    monto_total: real;
  begin
    reset(maestro);
    for i := 1 to CANT_SUC do begin
      reset(arr_det[i]);
      leerDetalle(arr_det[i],arr_regd[i]);
    end;
    minimo(arr_det, arr_regd, min);
    while(min.dni_alumno <> valorAlto) do begin
      dniAct := min.dni_alumno;
      while (min.dni_alumno = dniAct) do begin
        codAct := min.codigo_carrera;
        monto_total := 0;
        while(min.dni_alumno = dniAct) and (min.codigo_carrera = codAct) do begin
          // Sumo al monto pagado
          monto_total += min.monto_cuota;
          // Avanzo en el detalle
          minimo(arr_det, arr_regd, min);
        end;
        // Busco el regm que corresponde
        read(maestro, regm);
        while (regm.dni_alumno <> dniAct) and (regm.codigo_carrera <> codAct) do begin
          read(maestro, regm);
        end;
        // Actualizo maestro
        regm.monto_total_pagado := monto_total;
        seek(maestro, filepos(maestro)-1);
        write(maestro,regm);
      end;
    end;
    close(maestro);
    for i:= 1 to CANT_SUC do begin
      close(arr_det[i]);
    end;
  end;

  procedure generarReporte(var maestro: ArchivoMaestro);
  var
    archTxt: Text;
    regm: rAlumnoInscripto;
    cadena: string;
  begin
    cadena := 'Alumno moroso';
    reset(maestro);
    Assign(archTxt, 'reporte.txt');
    rewrite(archTxt);
    while not (eof(maestro)) do begin
      read(maestro, regm);
      with regm do begin
        if (monto_total_pagado = 0) then begin
          writeln(archTxt, dni_alumno, ' ',codigo_carrera, ' ',cadena);
        end;
      end;
    end;
    close(maestro);
    close(archTxt);
  end;

  var
    maestro: ArchivoMaestro;
    arr_det: vector_det;
    i: integer;
    s: String[2];
  begin
    Assign(maestro, 'maestro.dat');
    for i:= 1 to CANT_SUC do begin
      s ::= Str(i);
      Assign(arr_det[i], 'detalle'+s);
    end;
    actualizar(maestro,arr_det);
    generarReporte(maestro);
  end.

