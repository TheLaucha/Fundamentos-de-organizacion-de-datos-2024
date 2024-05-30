program ej_2;
  type
    ArchivoEnteros = file of integer;

procedure analizar(var archivo: ArchivoEnteros);
  var
    cont: integer;
    total: integer;
    cantMenor: integer;
    prom: real;
    num: integer;
  begin
    reset(archivo);
    cont := 0;
    cantMenor := 0;
    total := 0;
    while not (eof(archivo)) do begin
      read(archivo, num);
      writeln('Numero leido: ', num);
      cont := cont + 1;
      total := total + num;
      if (num < 1500) then
        cantMenor += 1;
    end;
    prom := total / cont;
    writeln('El total de los numeros es: ', total);
    writeln('La cantidad de numeros leidos es: ', cont);
    writeln('La cantidad de numeros menores a 1500 son: ', cantMenor);
    writeln('El promedio de los numeros ingresados es: ', prom:0:2);
    close(archivo);
  end;

var
  archivo: ArchivoEnteros;
  nombre: string;
begin
  writeln('Ingrese el nombre del archivo a procesar: ');
  readln(nombre);
  Assign(archivo, nombre);
  analizar(archivo);
end.
