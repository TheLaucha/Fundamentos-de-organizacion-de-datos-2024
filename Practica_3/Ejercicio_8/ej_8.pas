program ej_8;
  const
    valorAlto = 'ZZZZ';
  type
    rDistro = record
      nombre: string;
      anio: integer;
      version: real;
      cant_desarrolladores: integer;
      desc: string;
    end;

    ArchivoDistros = file of rDistro;

  procedure leer(var distros: ArchivoDistros; var reg: rDistro);
  begin
    if not (eof(distros)) then
      read(distros,reg)
    else
      reg.nombre := valorAlto;
  end;

  function existeDistribucion(var distros: ArchivoDistros; nombre: string): boolean;
  var
    existe: boolean;
    d: rDistro;
  begin
    reset(distros);
    existe := false;
    leer(distros, d);
    while (d.nombre <> valorAlto) and not(existe) do begin
      if(d.nombre = nombre) then
        existe := true;
      leer(distros, d);
    end;  
    close(distros);
    existeDistribucion := existe;
  end;

  procedure leerDistro(var distro: rDistro);
  begin
    with distro do begin
      writeln('Ingrese el nombre de la distribucion: -> Z para terminar');
      readln(nombre);
      if (nombre <> 'Z') then begin
        writeln('Ingrese el anio de lanzamiento: ');
        readln(anio);
        writeln('Ingrese la version del kernel: ');
        readln(version);
        writeln('Ingrese la cantidad de desarrolladores: ');
        readln(cant_desarrolladores);
        writeln('Ingrese una descripcion: ');
        readln(desc);
      end;
    end;
  end;

  procedure altaDistribucion(var distros: ArchivoDistros);
  var
    cab,distro: rDistro;
    existe: boolean;
  begin
    leerDistro(distro);
    existe := existeDistribucion(distros, distro.nombre);
    if(existe) then
      writeln('Ya existe la distribucion')
    else begin
      reset(distros);
      leer(distros, cab);
      if(cab.cant_desarrolladores < 0) then begin
        seek(distros, Abs(cab.cant_desarrolladores));
        read(distros, cab);
        seek(distros, filepos(distros)-1);
        write(distros, distro);
        seek(distros, 0);
        write(distros, cab);
      end
      else begin
        // ?? Que pasa si no hay espacio libre ? se agrega al final ? esta bien lo siguiente ?
        seek(distros, filesize(distros)-1);
        write(distros, distro);
      end;
    end;
    close(distros);
  end;

  procedure bajaDistribucion(var distros: ArchivoDistros);
  var
    nombre: string;
    existe: boolean;
    cab, d: rDistro;
  begin
    writeln('Escriba el nombre de la distribucion a dar de baja: ');
    readln(nombre);
    existe := existeDistribucion(distros, nombre);
    if not (existe) then
      writeln('Distribucion no existente...')
    else begin
      reset()
      leer(distros, cab);
      leer(distros, d);
      while (d.nombre <> nombre) do
        leer(distros, d);
      seek(distros, filepos(distros)-1);
      cab.cant_desarrolladores := -(filepos(distros));
      d.cant_desarrolladores := cab.cant_desarrolladores;
      write(distros, d);
      seek(distros, 0);
      write(distros, cab);
    end;
    close(distros);
    writeln('DISTRO ELIMINADA');
  end;

  var
    distros: ArchivoDistros;
  begin
    Assign(distros, 'distros.txt');
  end.