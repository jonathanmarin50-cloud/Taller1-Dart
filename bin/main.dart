import 'dart:io';

/// Función principal que inicializa el catálogo y controla el ciclo del menú.
void main() {
  // Lista que almacenará los mapas con la información de cada producto
  final List<Map<String, dynamic>> productos = [];
  bool continuar = true;

  print('==================================================');
  print('   BIENVENIDO AL SISTEMA DE GESTIÓN DE PRODUCTOS  ');
  print('==================================================');

  // Ciclo principal para mantener activo el menú hasta que el usuario decida salir
  while (continuar) {
    mostrarMenu();
    stdout.write('Seleccione una opción (1-5): ');
    final String? entradaOpcion = stdin.readLineSync();
    final int? opcion = int.tryParse(entradaOpcion?.trim() ?? '');

    print(''); // Salto de línea estético

    // Estructura switch-case para manejar las opciones del menú
    switch (opcion) {
      case 1:
        agregarProducto(productos);
        break;
      case 2:
        listarProductos(productos);
        break;
      case 3:
        actualizarProducto(productos);
        break;
      case 4:
        eliminarProducto(productos);
        break;
      case 5:
        print('==================================================');
        print('  ¡Gracias por utilizar el sistema! Hasta pronto. ');
        print('==================================================');
        continuar = false;
        break;
      default:
        print('[ERROR] Opción inválida. Por favor, ingrese un número del 1 al 5.\n');
    }

    if (continuar) {
      stdout.write('\nPresione [ENTER] para volver al menú principal...');
      stdin.readLineSync();
      print('\n' + '-' * 50 + '\n');
    }
  }
}

/// Muestra en consola las opciones disponibles del sistema.
void mostrarMenu() {
  print('================= MENÚ PRINCIPAL =================');
  print('1. Agregar producto');
  print('2. Listar productos');
  print('3. Actualizar producto');
  print('4. Eliminar producto');
  print('5. Salir');
  print('==================================================');
}

/// Permite agregar un nuevo producto solicitando nombre, precio y cantidad.
void agregarProducto(List<Map<String, dynamic>> productos) {
  print('------------- AGREGAR NUEVO PRODUCTO -------------');

  // Lectura y validación del Nombre
  String nombre = '';
  while (nombre.isEmpty) {
    stdout.write('Ingrese el nombre del producto: ');
    final entrada = stdin.readLineSync()?.trim() ?? '';
    if (entrada.isEmpty) {
      print('[ERROR] El nombre del producto no puede estar vacío.');
    } else {
      nombre = entrada;
    }
  }

  // Lectura y validación del Precio
  double precio = -1;
  while (precio <= 0) {
    stdout.write('Ingrese el precio del producto (ej. 1500.50): ');
    final entrada = stdin.readLineSync()?.trim() ?? '';
    final parsed = double.tryParse(entrada);
    if (parsed == null || parsed <= 0) {
      print('[ERROR] El precio debe ser un número mayor a 0.');
    } else {
      precio = parsed;
    }
  }

  // Lectura y validación de la Cantidad disponible
  int cantidad = -1;
  while (cantidad < 0) {
    stdout.write('Ingrese la cantidad disponible (ej. 10): ');
    final entrada = stdin.readLineSync()?.trim() ?? '';
    final parsed = int.tryParse(entrada);
    if (parsed == null || parsed < 0) {
      print('[ERROR] La cantidad debe ser un número entero mayor o igual a 0.');
    } else {
      cantidad = parsed;
    }
  }

  // Creación del mapa para representar el producto
  final Map<String, dynamic> nuevoProducto = {
    'nombre': nombre,
    'precio': precio,
    'cantidad': cantidad,
  };

  // Almacenar el mapa en la lista
  productos.add(nuevoProducto);

  print('\n[ÉXITO] Producto "$nombre" agregado correctamente al catálogo.');
}

/// Lista todos los productos registrados mostrando su índice, nombre, precio y cantidad.
void listarProductos(List<Map<String, dynamic>> productos) {
  print('------------- CATÁLOGO DE PRODUCTOS -------------');

  if (productos.isEmpty) {
    print('No hay productos registrados en el catálogo.');
    return;
  }

  // Formato tipo tabla de productos
  print(
    '${'ÍNDICE'.padRight(8)} | '
    '${'NOMBRE'.padRight(20)} | '
    '${'PRECIO (\$)'.padLeft(12)} | '
    '${'CANTIDAD'.padLeft(10)}',
  );
  print('-' * 58);

  for (int i = 0; i < productos.length; i++) {
    final producto = productos[i];
    final String indiceStr = '[${i + 1}]'.padRight(8);
    final String nombreStr = producto['nombre'].toString().padRight(20);
    final String precioStr =
        (producto['precio'] as double).toStringAsFixed(2).padLeft(12);
    final String cantidadStr = producto['cantidad'].toString().padLeft(10);

    print('$indiceStr | $nombreStr | $precioStr | $cantidadStr');
  }

  print('-' * 58);
  print('Total de productos registrados: ${productos.length}');
}

/// Permite actualizar uno, varios o todos los atributos de un producto existente.
void actualizarProducto(List<Map<String, dynamic>> productos) {
  print('-------------- ACTUALIZAR PRODUCTO ---------------');

  if (productos.isEmpty) {
    print('No hay productos disponibles para actualizar.');
    return;
  }

  // Listamos brevemente para que el usuario conozca los índices
  listarProductos(productos);
  print('');

  int? indice;
  while (indice == null) {
    stdout.write('Ingrese el número de índice del producto a actualizar: ');
    final entrada = stdin.readLineSync()?.trim() ?? '';
    final parsed = int.tryParse(entrada);

    if (parsed == null || parsed < 1 || parsed > productos.length) {
      print('[ERROR] Índice fuera de rango. Debe ser entre 1 y ${productos.length}.');
      stdout.write('¿Desea intentar de nuevo? (S/N): ');
      final reintentar = stdin.readLineSync()?.trim().toUpperCase() ?? 'N';
      if (reintentar != 'S' && reintentar != 'SI') {
        print('Operación de actualización cancelada.');
        return;
      }
    } else {
      indice = parsed - 1; // Ajuste a índice de lista (0-based)
    }
  }

  final producto = productos[indice];
  print('\nModificando producto: "${producto['nombre']}"');
  print('Nota: Presione [ENTER] sin escribir nada para conservar el dato actual.\n');

  // Actualizar Nombre
  stdout.write('Nuevo nombre [Actual: ${producto['nombre']}]: ');
  final nuevoNombre = stdin.readLineSync()?.trim() ?? '';
  if (nuevoNombre.isNotEmpty) {
    producto['nombre'] = nuevoNombre;
  }

  // Actualizar Precio
  bool precioValido = false;
  while (!precioValido) {
    stdout.write('Nuevo precio [Actual: \$${(producto['precio'] as double).toStringAsFixed(2)}]: ');
    final entradaPrecio = stdin.readLineSync()?.trim() ?? '';
    if (entradaPrecio.isEmpty) {
      // Mantener precio actual
      precioValido = true;
    } else {
      final parsedPrecio = double.tryParse(entradaPrecio);
      if (parsedPrecio == null || parsedPrecio <= 0) {
        print('[ERROR] El precio debe ser un número mayor a 0.');
      } else {
        producto['precio'] = parsedPrecio;
        precioValido = true;
      }
    }
  }

  // Actualizar Cantidad
  bool cantidadValida = false;
  while (!cantidadValida) {
    stdout.write('Nueva cantidad [Actual: ${producto['cantidad']}]: ');
    final entradaCantidad = stdin.readLineSync()?.trim() ?? '';
    if (entradaCantidad.isEmpty) {
      // Mantener cantidad actual
      cantidadValida = true;
    } else {
      final parsedCantidad = int.tryParse(entradaCantidad);
      if (parsedCantidad == null || parsedCantidad < 0) {
        print('[ERROR] La cantidad debe ser un entero mayor o igual a 0.');
      } else {
        producto['cantidad'] = parsedCantidad;
        cantidadValida = true;
      }
    }
  }

  print('\n[ÉXITO] Producto actualizado correctamente:');
  print(' - Nombre: ${producto['nombre']}');
  print(' - Precio: \$${(producto['precio'] as double).toStringAsFixed(2)}');
  print(' - Cantidad: ${producto['cantidad']}');
}

/// Permite eliminar un producto del catálogo por su número de índice.
void eliminarProducto(List<Map<String, dynamic>> productos) {
  print('--------------- ELIMINAR PRODUCTO ----------------');

  if (productos.isEmpty) {
    print('No hay productos registrados para eliminar.');
    return;
  }

  // Listar para que el usuario conozca los índices
  listarProductos(productos);
  print('');

  stdout.write('Ingrese el número de índice del producto a eliminar: ');
  final entrada = stdin.readLineSync()?.trim() ?? '';
  final parsed = int.tryParse(entrada);

  if (parsed == null || parsed < 1 || parsed > productos.length) {
    print('[ERROR] Índice fuera de rango o inválido.');
    return;
  }

  final int indice = parsed - 1;
  final productoAEliminar = productos[indice];

  // Confirmación previa a la eliminación
  stdout.write('¿Está seguro de eliminar "${productoAEliminar['nombre']}"? (S/N): ');
  final confirmacion = stdin.readLineSync()?.trim().toUpperCase() ?? 'N';

  if (confirmacion == 'S' || confirmacion == 'SI') {
    final eliminado = productos.removeAt(indice);
    print('\n[ÉXITO] Producto "${eliminado['nombre']}" eliminado satisfactoriamente.');
  } else {
    print('\n[INFO] Eliminación cancelada por el usuario.');
  }
}
