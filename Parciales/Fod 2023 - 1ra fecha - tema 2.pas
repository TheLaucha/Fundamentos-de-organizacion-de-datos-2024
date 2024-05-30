program parcial;
  type
    rEmpleado = record
      dni: integer;
      nombre: string;
      apellido: string;
      edad: integer;
      domicilio: string;
      fechaNac: string;
    end;

    ArchivoEmpleados = file of rEmpleado;

  procedure leerEmpleado(var emp: rEmpleado);
  begin
    with emp do begin
      writeln('Ingrese dni: ');
      readln(dni);
      writeln('Ingrese nombre: ');
      readln(nombre);
       writeln('Ingrese apellido: ');
      readln(apellido);
      writeln('Ingrese edad: ');
      readln(edad);
      writeln('Ingrese domicilio: ');
      readln(domicilio);
      writeln('Ingrese fecha de nacimiento: ');
      readln(fechaNac);
    end;
  end;

  procedure agregarEmpleado(var empleados: ArchivoEmpleados);
  var
    emp: rEmpleado;
    existe: boolean;
    cab: rEmpleado;
  begin
    leerEmpleado(emp);
    existe := existeEmpleado(emp.dni, empleados); // Se dispone
    if (existe) then
      writeln('El empleado ya existe')
    else begin
      reset(empleados);
      read(empleados, cab);
      if (cab.dni < 0) then begin
        seek(empleados, Abs(cab.dni));
        read(empleados, cab); // Leo el proximo lugar libre
        seek(empleados, filepos(empleados)-1); // Vuelvo al lugar libre
        write(empleados, emp) // Agrego el nuevo empleado en el lugar libre
        seek(empleados, 0);
        write(empleados, cab);
      end
      else begin
        writeln('No hay espacio libre en el archivo')
      end;
      close(empleados);
    end;
  end;

  procedure quitarEmpleado(var empleados: ArchivoEmpleados);
  var
    dni:integer;
    existe: boolean;
    cab, emp: rEmpleado;
  begin
    writeln('Ingrese DNI a eliminar: ');
    readln(dni);
    existe := existeEmpleado(dni, empleados);
    if (existe) then begin
      reset(empleados);
      read(empleados, cab); // Leo la cabecera
      read(empleados, emp); // Leo primer registro emp
      // Busco el empleado a eliminar, se sabe que existe
      while (emp.dni <> dni) do
        read(empleados, emp);
      // Cuando encuentro
      seek(empleados, filepos(empleados)-1); // Me posiciono en la pos a eliminar
      emp.dni := cab.dni; // Escribo la pos que estaba en la cabecera
      cab.dni := -(filepos(empelados)) // Guardo la pos actual a eliminar en negativo
      write(empleados, emp); // Guardo el registro empleado con la pos que habia en la cabecera
      seek(empleados, 0);
      write(empleados, cab) // Guardo en la cabecera la nueva posicion eliminada;
      close(empleados);
    end;
    else
      writeln('El empleado con DNI ingresado no existe');
  end;

  var
    empleados: ArchivoEmpleados;
  begin
    Assign(empleados, 'empleados');
    // Se asume que el archivo ya fue creado
    agregarEmpleado(empleados);
    quitarEmpleado(empleados);
  end;