program ej_1;
  type
    ArchivoEnteros = file of integer;


procedure cargarArchivo(var archivo: ArchivoEnteros);
var
  num: integer;
begin
  rewrite(archivo);
  writeln('Ingrese el numero a cargar: (3000 para finalizar)');
  readln(num);
  while (num <> 3000) do begin
    write(archivo, num);
    writeln('Ingrese el numero a cargar: (3000 para finalizar)');
    readln(num);
  end;
  close(archivo);
end;

var
  archivo: ArchivoEnteros;
  nombre: string;
begin
  writeln('Ingrese el nombre del archivo: ');
  readln(nombre);
  Assign(archivo, nombre);
  cargarArchivo(archivo);
end.
