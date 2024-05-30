program ej_4_v2;
  type
    reg_flor = record
      nombre: String[45];
      codigo:integer;
    end;
    tArchFlores = file of reg_flor;

  procedure agregarFlor(var flores: tArchFlores; nombre: string; codigo: integer);
  var
    cab: reg_flor;
    flor: reg_flor;
  begin
    reset(flores);
    read(flores, cab);
    if (cab.cod < 0) then begin
      seek(flores, cab.cod*-1);
      read(flores, cab);
      seek(flores, filepos(flores)-1);
      flor.cod := codigo;
      flor.nombre := nombre;
      write(flores, flor);
      seek(flores, 0);
      write(flores, cab);
    end
    else begin
      writeln('No hay lugar');
    end;
    close(flores);
  end;

  procedure listarFlores(var flores: tArchFlores);
  var
    f: reg_flor;
  begin
    reset(flores);
    read(flores, f);
    while not (eof(flores)) do begin
      read(flores, f);
      if (f.cod > 0) then begin
        writeln('Nombre: ', f.nombre);
        writeln('Codigo: ', f.cod);
      end;
    end;
    close(flores);
  end;

  procedure eliminarFlor(var flores: tArchFlores; flor_a_elminar: integer);
  var
    cab: reg_flor;
    f: reg_flor;
  begin
    reset(flores);
    read(flores, cab);
    read(flores, f);
    while (f.cod <> flor_a_elminar) and not(eof(flores)) do begin
      read(flores, f); // Busco la flor a eliminar
    end;
    if (f.cod = flor_a_elminar) then begin
      seek(flores, filepos(flores-1));
      f.cod := cab.cod;
      cab.cod := filepos(flores)*-1;
      write(flores, f);
      seek(flores, 0);
      write(cab);
    end
    else begin
      writeln('No se encontro la flor...');
    end;
    close(flores);
  end;

  var
    flores: tArchFlores;
    nombre: string;
    codigo: integer;
    flor_a_elminar: integer;
  begin
    writeln('Ingrese nombre de la flor a agregar: ');
    readln(nombre);
    writeln('Ingrese codigo de la flor a agregar: ');
    readln(codigo);
    agregarFlor(flores, nombre, codigo);
    listarFlores(flores);
    writeln('Ingrese cod de la flor a eliminar: ');
    readln(flor_a_elminar);
    eliminarFlor(flores, flor_a_elminar);
  end.