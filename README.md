# Directorio de Gatos 🐱

Una aplicación Flutter moderna y elegante para explorar razas de gatos, construida con foco en el rendimiento, la estética premium y la robustez.

## ✨ Características
- 🐾 **Paginación Infinita**: Carga dinámica de 10 razas a la vez.
- 🔍 **Búsqueda en Tiempo Real**: Filtra razas localmente de forma instantánea.
- 🌓 **Modo Oscuro/Claro**: Soporte completo de temas con persistencia visual.
- 📡 **Manejo de Errores**: Tratamiento elegante de desconexiones con opción de reintento.
- 🏗️ **Arquitectura Robusta**: Código limpio y escalable.

## 🚀 Instrucciones de Ejecución

Para ejecutar este proyecto en tu entorno local, sigue estos pasos:

1. **Prerrequisitos**:
   - Tener instalado [Flutter](https://docs.flutter.dev/get-started/install) (canal stable).
   - Un emulador configurado o un dispositivo físico conectado.

2. **Instalación de dependencias**:
   ```bash
   flutter pub get
   ```

3. **Generación de código (Freezed/JSON)**:
   Este proyecto utiliza `freezed` para modelos inmutables y estados. Genera los archivos necesarios con:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Ejecución**:
   ```bash
   flutter run
   ```

---

## 🏗️ Arquitectura y Gestión de Estados

### Arquitectura: Capas Basada en Funcionalidad
El proyecto sigue una estructura de capas que separa claramente las responsabilidades:
- **Data (Repositories & Services)**: Punto de contacto con la API externa (`catfact.ninja`). Se encarga de las peticiones HTTP y la conversión de JSON a objetos de dominio.
- **Logic (Blocs/Cubits)**: Actúa como puente entre los datos y la UI. Controla la lógica de búsqueda, la paginación y la gestión de estados de error/carga.
- **UIs (Screens & Core)**: Componentes visuales que reaccionan a los cambios de estado emitidos por la capa lógica.

### Gestor de Estados: Flutter BLoC (Cubit)
Se ha seleccionado **Cubit** (una versión simplificada de BLoC) como el motor de estado principal por:
1. **Predecibilidad**: Los estados son inmutables y el flujo de datos es unidireccional, lo que facilita el debugging.
2. **Escalabilidad**: BLoC es el estándar de la industria para aplicaciones Flutter de alto rendimiento.
3. **Productividad**: Al usar Cubits, reducimos el código repetitivo sin perder el control sobre la lógica de negocio.
4. **Resiliencia**: Facilita enormemente el manejo de estados complejos como "Cargando", "Error de Red" y "Éxito" de forma centralizada.

---

## 📦 Releases Automáticos
El proyecto está configurado con **GitHub Actions**. Para generar un nuevo Release con el APK compilado automáticamente en GitHub:
1. Crea una etiqueta: `git tag v1.0.0`
2. Sube la etiqueta: `git push origin v1.0.0`
3. El APK aparecerá en la sección de "Releases" de tu repositorio en unos minutos.
