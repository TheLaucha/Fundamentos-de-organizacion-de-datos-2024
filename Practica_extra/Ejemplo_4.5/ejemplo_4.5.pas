program ejemplo_4_5;
var
  empleados: file;
  nombre, apellido, direccion, documento: string;

procedure cargarArchivo(var empleados: file);
var
	finCampo: char;
	finReg: char;
begin
	finCampo := '#';
	finReg := '@';
  // rewrite(arch, tamaño)
  rewrite(empleados, 1);
  writeln('Ingrese el apellido: ');
  readln(apellido);
  writeln('Ingrese el nombre: ');
  readln(nombre);
  writeln('Ingrese direccion: ');
  readln(direccion);
  writeln('Ingrese documento: ');
  readln(documento);

  while(apellido <> 'zzz') do begin
    BlockWrite(empleados, apellido, length(apellido)+1);
    BlockWrite(empleados, finCampo, 1);
    BlockWrite(empleados, nombre, length(nombre)+1);
    BlockWrite(empleados, finCampo, 1);
    BlockWrite(empleados, direccion, length(direccion)+1);
    BlockWrite(empleados, finCampo, 1);
    BlockWrite(empleados, documento, length(documento)+1);
    BlockWrite(empleados, finReg, 1);
    // Vuelvo a solicitar empleado
    writeln('Ingrese el apellido: ');
    readln(apellido);
    writeln('Ingrese el nombre: ');
    readln(nombre);
    writeln('Ingrese direccion: ');
    readln(direccion);
    writeln('Ingrese documento: ');
    readln(documento);
  end;
  close(empleados);
end;

procedure imprimirArchivo(var empleados: file);
var
  campo, buffer: string;
begin
  reset(empleados, 1);
  while not (eof(empleados)) do begin
    BlockRead(empleados, buffer, 1);
    while (buffer <> '@') and not (eof(empleados)) do begin
			campo := '';
      while (buffer <> '@') and (buffer <> '#') and not (eof(empleados)) do begin
        campo := campo + buffer;
        BlockRead(empleados, buffer, 1);
      end;
      writeln(campo);
    end;
    // if not (eof(empleados)) then
    //   BlockRead(empleados, nombre, 1)
  end;
  close(empleados);
end;

begin
  Assign(empleados, 'empleados.txt');
  if (true) then
    cargarArchivo(empleados);
  imprimirArchivo(empleados);
end.
