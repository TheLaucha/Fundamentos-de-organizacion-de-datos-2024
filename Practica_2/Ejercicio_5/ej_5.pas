program ej_5;
  const dimF = 3;
  const valorAlto = 9999;
  type
    tDia = 0..31;
    tMes = 0..12;

    rFecha = record
      dia: tDia;
      mes: tMes;
      anio: integer;
    end;

    rDireccion = record
      calle: string;
      nro: integer;
      piso: integer;
      depto: char;
      ciudad: string;
    end;

    rNacimiento = record
      nro_partida_nac: integer;
      nac: rFecha;
      nombre: string;
      apellido: string;
      direccion: rDireccion;
      matricula_medico_nac: integer;
      nombre_madre: string;
      apellido_madre: string;
      dni_madre: integer;
      nombre_padre: string;
      apellido_padre: string;
      dni_padre: integer;
    end;

    rDeceso = record
      fecha: rFecha;
      hora: integer;
    end;

    rFallecimiento = record
      nro_partida_nac: integer;
      dni:integer;
      nombre: string;
      apellido:string;
      matricula_medico_dec: integer;
      deceso: rDeceso;
      lugar:string;
    end;

    rMaestro = record
      // Datos nacimiento
      nro_partida_nac: integer;
      nombre: string;
      apellido: string;
      direccion: rDireccion;
      matricula_medico_nac: integer;
      nombre_madre: string;
      apellido_madre: string;
      dni_madre: integer;
      nombre_padre: string;
      apellido_padre: string;
      dni_padre: integer;
      // Datos fallecimiento
      fallecio: boolean;
      matricula_medico_dec: integer;
      deceso: rDeceso;
      lugar: string;
    end;

    ArchivoDetalleNacimiento = file of rNacimiento;
    ArchivoDetalleFallecimiento = file of rFallecimiento;
    ArchivoMaestro = file of rMaestro;

    vector_nacimientos = array[1..dimF] of ArchivoDetalleNacimiento;
    vector_fallecimientos = array[1..dimF] of ArchivoDetalleFallecimiento;
    vector_reg_nacimientos = array[1..dimF] of rNacimiento;
    vector_reg_fallecimientos = array[1..dimF] of rFallecimiento;

  procedure asignoDetalles(var arr_nacimientos: vector_nacimientos; var arr_fallecimientos: vector_fallecimientos);
  var
    i:integer;
    a: string[2];
  begin
    for i:=1 to dimF do begin
      Str(i,a);
      Assign(arr_nacimientos[i], 'nacimiento'+a);
      Assign(arr_fallecimientos[i], 'fallecimiento'+a);
    end;
  end;

  procedure leerNacimiento(var detalle: ArchivoDetalleNacimiento; var regd: rNacimiento);
  begin
    if not (eof(detalle)) then begin
      read(detalle,regd);
    end
    else begin
      regd.nro_partida_nac := valorAlto;
    end;
  end;

  procedure leerFallecimiento(var detalle: ArchivoDetalleFallecimiento; var regd: rFallecimiento);
  begin
    if not (eof(detalle)) then begin
      read(detalle,regd);
    end
    else begin
      regd.nro_partida_nac := valorAlto;
    end;
  end;

  procedure minimoNac(var arr_nacimientos: vector_nacimientos; var arr_reg_nac: vector_reg_nacimientos; var minN: rNacimiento);
  var
    i:integer;
    regN: rNacimiento;
    posMin: integer;
  begin
    minN.nro_partida_nac := valorAlto;
    for i:=1 to dimF do begin
      regN := arr_reg_nac[i];
      if (regN.nro_partida_nac <> valorAlto) then begin
        if(regN.nro_partida_nac < minN.nro_partida_nac) then begin
          minN := regN;
          posMin := i;
        end;
      end;
    end;
    if (minN.nro_partida_nac <> valorAlto) then begin
      leerNacimiento(arr_nacimientos[posMin],arr_reg_nac[posMin]);
    end;
  end;

  procedure minimoFall(var arr_fallecimientos: vector_fallecimientos; var arr_reg_fall: vector_reg_fallecimientos; var minF: rFallecimiento);
  var
    i:integer;
    regF: rFallecimiento;
    posMin: integer;
  begin
    minF.nro_partida_nac := valorAlto;
    for i:=1 to dimF do begin
      regF := arr_reg_fall[i];
      if (regF.nro_partida_nac <> valorAlto) then begin
        if(regF.nro_partida_nac < minF.nro_partida_nac) then begin
          minF := regF;
          posMin := i;
        end;
      end;
    end;
    if (minF.nro_partida_nac <> valorAlto) then begin
      leerFallecimiento(arr_fallecimientos[posMin],arr_reg_fall[posMin]);
    end;
  end;

  procedure analizo(var maestro: ArchivoMaestro; var arr_nacimientos: vector_nacimientos; var arr_fallecimientos: vector_fallecimientos);
  var
    arr_reg_nac: vector_reg_nacimientos;
    arr_reg_fall: vector_reg_fallecimientos;
    i:integer;
    minN: rNacimiento;
    minF: rFallecimiento;
    regm: rMaestro;
  begin
    // Escribo, reseteo e inicializo.
    rewrite(maestro);
    for i:=1 to dimF do begin
      reset(arr_nacimientos[i]);
      reset(arr_fallecimientos[i]);
      leerNacimiento(arr_nacimientos[i],arr_reg_nac[i]);
      leerFallecimiento(arr_fallecimientos[i], arr_reg_fall[i]);
    end;
    // Busco el minimo
    minimoNac(arr_nacimientos, arr_reg_nac, minN);
    minimoFall(arr_fallecimientos, arr_reg_fall, minF);
    while (minN.nro_partida_nac <> valorAlto) do begin
      // Escribo datos dependiendo si fallecio o no.
      regm.nro_partida_nac := minN.nro_partida_nac;
      regm.nombre := minN.nombre;
      regm.apellido := minN.apellido;
      regm.direccion := minN.direccion;
      regm.matricula_medico_nac := minN.matricula_medico_nac;
      regm.nombre_madre := minN.nombre_madre;
      regm.apellido_madre := minN.apellido_madre;
      regm.dni_madre := minN.dni_madre;
      regm.nombre_padre := minN.nombre_padre;
      regm.apellido_padre := minN.apellido_padre;
      regm.dni_padre := minN.dni_padre;
      if (minN.nro_partida_nac = minF.nro_partida_nac) then begin
        regm.matricula_medico_dec := minF.matricula_medico_dec;
        regm.deceso := minF.deceso;
        regm.lugar := minF.lugar;
        regm.fallecio := true;
        minimoFall(arr_fallecimientos,arr_reg_fall,minF);
      end
      else begin
        regm.matricula_medico_dec := 0;
        regm.deceso.fecha.dia := 0;
        regm.deceso.fecha.mes := 0;
        regm.deceso.fecha.anio := 0;
        regm.deceso.hora := 0;
        regm.lugar := '';
        regm.fallecio := false;
      end;
      write(maestro,regm);
      minimoNac(arr_nacimientos,arr_reg_nac,minN);
    end;
    close(maestro);
    for i:=1 to dimF do begin
      close(arr_nacimientos[i]);
      close(arr_fallecimientos[i]);
    end;
  end;

  procedure mostrarMaestro(var maestro: ArchivoMaestro);
  var
    regm: rMaestro;
  begin
    reset(maestro);
    while not (eof(maestro)) do begin
      read(maestro,regm);
      with regm do begin
				writeln('==========');
        writeln('Nro partida: ', nro_partida_nac);
        writeln('Nombre y apellido: ', nombre, ' ', apellido);
        writeln('Direccion: ', direccion.calle, ' ', direccion.nro, ' ', direccion.piso, ' ', direccion.depto, ' ', direccion.ciudad);
        writeln('Matricula medico nacimiento. ', matricula_medico_nac);
        writeln('Nombre, apellido y dni de la madre: ', nombre_madre, ' ', apellido_madre, ' ', dni_madre);
        writeln('Nombre, apellido y dni del padre: ', nombre_padre, ' ', apellido_padre, ' ', dni_padre);
        writeln('Fallecio ?', fallecio);
        if (fallecio) then begin
          writeln('Matricula medico deceso: ', matricula_medico_dec);
          writeln('Fecha y hora del deceso: ', deceso.fecha.dia, '/', deceso.fecha.mes, '/', deceso.fecha.anio, ' ', deceso.hora, 'hs');
          writeln('Lugar: ', lugar);
        end;
        writeln('==========');
      end;
    end;
    close(maestro);
  end;

  var
    maestro: ArchivoMaestro;
    arr_nacimientos: vector_nacimientos;
    arr_fallecimientos: vector_fallecimientos;
  begin
    // Asignar archivos
    Assign(maestro,'maestro.dat');
    asignoDetalles(arr_nacimientos,arr_fallecimientos);
    analizo(maestro,arr_nacimientos,arr_fallecimientos);
    mostrarMaestro(maestro);
  end.
