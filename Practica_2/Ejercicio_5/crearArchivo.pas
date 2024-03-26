type
    tDia = 1..31;
    tMes = 1..12;

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

    ArchivoDetalleNacimiento = file of rNacimiento;
    ArchivoDetalleFallecimiento = file of rFallecimiento;

  procedure leerNacimiento(var reg: rNacimiento);
  begin
    with reg do begin
      writeln('Escriba nro de partida de nacimiento... 0 para finalizar');
      readln(nro_partida_nac);
      if (nro_partida_nac <> 0) then begin
        writeln('Ingrese dia de nacimiento: ');
        readln(nac.dia);
        writeln('Ingrese mes de nacimiento: ');
        readln(nac.mes);
        writeln('Ingrese anio de nacimiento: ');
        readln(nac.anio);
        writeln('Nombre: ');
        readln(nombre);
        writeln('Apellido: ');
        readln(apellido);
        writeln('Calle: ');
        readln(direccion.calle);
        writeln('Nro: ');
        readln(direccion.nro);
        writeln('Piso: ');
        readln(direccion.piso);
        writeln('Depto: ');
        readln(direccion.depto);
        writeln('Ciudad: ');
        readln(direccion.ciudad);
        writeln('Matricula medico nacimiento: ');
        readln(matricula_medico_nac);
        writeln('Nombre, apellido y dni de la madre: ');
        readln(nombre_madre);
        readln(apellido_madre);
        readln(dni_madre);
        writeln('Nombre, apellido y dni del padre: ');
        readln(nombre_padre);
        readln(apellido_padre);
        readln(dni_padre);
      end;
    end;
  end;

  procedure crearAchivoDetalleNacimiento(var arch: ArchivoDetalleNacimiento);
  var
    nombre: string;
    reg: rNacimiento;
  begin
    writeln('Elija el nombre para el archivo detalle nacimiento: ');
    readln(nombre);
    Assign(arch, nombre);
    rewrite(arch);
    leerNacimiento(reg);
    while (reg.nro_partida_nac <> 0) do begin
      write(arch,reg);
      leerNacimiento(reg);
    end;
    close(arch);
  end;

  procedure leerFallecimiento(var reg: rFallecimiento);
  begin
    with reg do begin
      writeln('Escriba nro de partida de nacimiento... 0 para finalizar');
      readln(nro_partida_nac);
      if (nro_partida_nac <> 0) then begin
        writeln('Ingrese dia de fallecimiento: ');
        readln(deceso.fecha.dia);
        writeln('Ingrese mes de fallecimiento: ');
        readln(deceso.fecha.mes);
        writeln('Ingrese anio de fallecimiento: ');
        readln(deceso.fecha.anio);
        writeln('Ingrese hora de fallecimiento: ');
        readln(deceso.hora);
        writeln('Ingrese lugar de fallecimiento: ');
        readln(lugar);
        writeln('Nombre: ');
        readln(nombre);
        writeln('Apellido: ');
        readln(apellido);
        writeln('Matricula medico deceso: ');
        readln(matricula_medico_dec);
      end;
    end;
  end;

  procedure crearAchivoDetalleFallecimiento(var arch: ArchivoDetalleFallecimiento);
  var
    nombre: string;
    reg: rFallecimiento;
  begin
    writeln('Elija el nombre para el archivo detalle fallecimiento: ');
    readln(nombre);
    Assign(arch, nombre);
    rewrite(arch);
    leerFallecimiento(reg);
    while (reg.nro_partida_nac <> 0) do begin
      write(arch,reg);
      leerFallecimiento(reg);
    end;
    close(arch);
  end;

  var
    opcion: byte;
    detalle_nacimiento: ArchivoDetalleNacimiento;
    detalle_fallecimiento: ArchivoDetalleFallecimiento;
  begin
    writeln('Ingrese la opcion que desea realizar: ');
    writeln('1. Crear detalle nacimiento: ');
    writeln('2. Crear detalle fallecimiento: ');
    readln(opcion);
    case opcion of
      1: crearAchivoDetalleNacimiento(detalle_nacimiento);
      2: crearAchivoDetalleFallecimiento(detalle_fallecimiento);
    end;
    
  end.
