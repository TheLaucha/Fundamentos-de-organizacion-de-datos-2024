program ej_14;
  const
    dimF = 2;
    valorAlto = 'ZZZZZ';
  type
    rVuelo = record
      destino: string;
      fecha: string;
      hora: real;
      cant_asientos_disponibles: integer;
    end;

    rDetalle = record
      destino: string;
      fecha: string;
      hora: real;
      cant_asientos_comprados: integer;
    end;

    lista = ^nodo;
    nodo = record
      dato: rVuelo;
      sig: lista;
    end;

    ArchivoMaestro = file of rVuelo;
    ArchivoDetalle = file of rDetalle;

    vector_arch_det = array [1..dimF] of ArchivoDetalle;
    vector_regd = array [1..dimF] of rDetalle;
  
  procedure leerDetalle(var detalle: ArchivoDetalle; var regd: rDetalle);
  begin
    if not (eof(detalle)) then
      read(detalle,regd);
    else
      regd.destino := valorAlto;
  end;

  procedure minimo(var arr_det: vector_arch_det; var arr_regd: vector_regd; var min: rDetalle);
  var
    i:integer;
    regd: rVuelo;
    posMin: integer;
  begin
    min.destino := valorAlto;
    for i:= 1 to dimF do begin
      regd := arr_regd[i];
      if (regd.destino <> valorAlto) then begin
        if (regd.destino < min.destino) 
        or ((regd.destino = min.destino) and (regd.fecha < min.fecha))) 
        or ((regd.destino = min.destAct) and (regd.fecha = min.fecha) and (regd.hora < min.hora))  then begin
          min := regd;
          posMin := i;
        end;
      end;
    end;
    if (min.destino <> valorAlto) then
      leerDetalle(arr_det[posMin], arr_regd[posMin]);
  end;

  procedure acutalizar(var maestro: ArchivoMaestro; var arr_det: ArchivoDetalle);
  var
    destAct: string;
    fechaAct: string;
    horaAct: real;
    arr_regd: vector_regd;
    min: rVuelo;
    regm: rVuelo;
    i: integer;
    totalComprados:integer;
  begin
    reset(maestro);
    for i:=1 to dimF do begin
      reset(arr_det[i]);
      leerDetalle(arr_det[i], arr_regd[i]);
    end;
    minimo(arr_det, arr_regd, min);
    while (min.destino <> valorAlto) do begin
      destAct := min.destino;
      while (destAct = min.destino) do begin
        fechaAct := min.fecha;
        while (destAct = min.destino) and (fechaAct = min.fecha) do begin
          horaAct := min.hora;
          totalComprados := 0;
          while (destAct = min.destino) and (fechaAct = min.fecha) and (horaAct = min.hora) do begin
            totalComprados += min.cant_asientos_comprados;
            minimo(arr_det, arr_regd, min);
          end;
          // Busco el maestro correspondiente y actualizo
          read(maestro, regm);
          while (destAct <> regm.destino) or (fechaAct <> regm.fecha) or (horaAct <> regm.hora) do begin
            read(maestro, regm);
          end;
          regm.cant_asientos_disponibles := regm.cant_asientos_disponibles - totalComprados;
          seek(maestro, filepos(maestro)-1);
          write(maestro, regm);
        end;
      end;
    end;
    close(maestro);
    for i:=1 to dimF do begin
      close(arr_det[i]);
    end;
  end;

  procedure agregarAlFinal(var l,ult:lista; regm: rVuelo);
  var
    nuevo:lista;
  begin
    new(nuevo);
    nuevo^.dato := regm;
    nuevo^.sig := nil;
    if (l=nil) then
      l := nuevo;
    else
      ult^.sig := nuevo;
    ult := nuevo; 
  end;

  procedure generarReporte(var maestro: ArchivoMaestro; menorA: integeR; var l:lista);
  var
    regm: rVuelo;
    ult: lista;
  begin
    reset(maestro);
    while not (eof(maestro)) do begin
      read(maestro, regm);
      if (regm.cant_asientos_disponibles < menorA) then
        agregarAlFinal(l,ult,regm);
    end;
    close(maestro);
  end;

  procedure imprimirLista(l: lista);
  begin
    while (l <> nil) do begin
      imprimirMaestro(l^.dato);
      l := l^.sig;
    end;
  end;

  var
    maestro: ArchivoMaestro;
    arr_det: vector_arch_det;
    i: integer;
    s: string[2];
    menorA: integer;
    l: lista;
  begin
    l := nil;
    Assign(maestro, 'maestro.dat');
    for i:= 1 to dimF do begin
      s := Str(i);
      Assign(arr_det[i], 'detalle'+s);
    end;
    actualizar(maestro, arr_det);
    writeln('Busque vuelos con una cantidad de asientos disponibles menor a: ');
    readln(menorA);
    generarReporte(maestro, menorA, l);
    imprimirLista(l);
  end;
