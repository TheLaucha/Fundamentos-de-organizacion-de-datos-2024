program ej_4;
  const
    valorAlto = 9999;
  type
    reg_flor = record
      nombre: string[45];
      codigo: integer;
    end;

    tArchFlores = file of reg_flor;

  procedure leerFlor(var flor: reg_flor);
  begin
    writeln('Escriba el cod de flor: -> 0 para terminar');
    readln(flor.codigo);
    if(flor.codigo <> 0) then begin
      writeln('Escriba el nombre de la flor: ');
      readln(flor.nombre);
    end;
  end;

  procedure cargarArchivo(var flores: tArchFlores);
  var
    flor: reg_flor;
  begin
    rewrite(flores);
    flor.codigo := -2;
    flor.nombre := 'cabecera';
    write(flores,flor);
    leerFlor(flor);
    while (flor.codigo <> 0) do begin
      write(flores, flor);
      leerFlor(flor);
    end;
    close(flores);
  end;

  procedure leerReg(var flores: tArchFlores; var reg: reg_flor);
  begin
    if not (eof(flores)) then
      read(flores, reg)
    else
      reg.codigo := valorAlto;
  end;

  // ?? Pedir correccion sobre este proceso.
  procedure agregarFlor(var flores: tArchFlores; flor: reg_flor);
  var
    reg: reg_flor;
  begin
    reset(flores);
    leerReg(flores,reg); // Registro cabecera
    if(reg.codigo < 0) then begin
      seek(flores, Abs(reg.codigo));
      read(flores, reg);
      seek(flores, filepos(flores)-1);
      write(flores, flor);
      seek(flores, 0);
      write(flores, reg);
    end
    else begin
      writeln('NO HAY LUGARES LIBRES');
    end;
    close(flores);
  end;

  procedure imprimirFlor(flor: reg_flor);
  begin
    with flor do begin
      writeln('Nombre: ', nombre);
      writeln('Codigo: ', codigo);
      writeln('------------------');
    end;
  end;

  // ?? Preguntar por este algoritmo
  // Deberia posicionearme en seek(arch,1) para saltear la pos cabecera ?
  procedure listarFlores(var flores: tArchFlores);
  var
    flor: reg_flor;
  begin
    reset(flores);
    leerReg(flores, flor);
    while (flor.codigo <> valorAlto) do begin
      if(flor.codigo > 0) then
        imprimirFlor(flor);
      leerReg(flores, flor);
    end;
    close(flores);
  end;

  // En el registro que elimino, es correcto reemplazar solo el "codigo" dejando el resto del registro intacto ??
  procedure eliminarFlor(var flores: tArchFlores; flor: reg_flor);
  var
    ind, f: reg_flor;
  begin
    reset(flores);
    leerReg(flores,ind);
    leerReg(flores,f);
    // Busco la flor de igual codigo
    while (f.codigo <> valorAlto) and (f.codigo <> flor.codigo) do
      leerReg(flores, f);
    if(f.codigo = flor.codigo) then begin
      flor.codigo := ind.codigo;
      seek(flores, filepos(flores)-1);
      ind.codigo := -(filepos(flores));
      writeln('Ind.cod: ', ind.codigo);
      write(flores, flor);
      seek(flores, 0);
      write(flores, ind);
    end
    else
      writeln('Flor no encontrada');
    close(flores);
  end;
  
  var
    flores: tArchFlores;
    flor: reg_flor;
  begin
    Assign(flores, 'flores.dat');
    // Creo y cargo el archivo flores manualmente
    if (false) then
      cargarArchivo(flores);
    // Abre el archivo y agrega una flor recibida como parametro. siguiendo las siguientes politcas
    // las altas se realizan reutilizando registros borrados. 
    // El registro 0 se usa como cabecera de la pila de registros borrados: el
    // número 0 en el campo código implica que no hay registros borrados y -N indica que el
    // próximo registro a reutilizar es el N
    //writeln('==== Agregue una nueva flor ====');
    //leerFlor(flor);
    //agregarFlor(flores, flor);
    writeln('==== LISTAR FLORES ====');
    listarFlores(flores);
    writeln('==== ELIMINAR FLOR ====');
    leerFlor(flor);
    eliminarFlor(flores, flor);
    writeln('==== LISTAR FLORES ====');
    listarFlores(flores);
  end.
