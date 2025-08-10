# Task Manager API

Una API REST completa para gestión de tareas construida con NestJS, TypeORM y PostgreSQL, la cual consta como un block en el cual puedes listar tus tareas , y su respectivo crud en la cual podras ver tus tareas pendientes , tareas completadas, tambien con un login y un registrar usuarios todo encryptado con  jwt para la seguridad 
## 🛠️ Stack Tecnológico
- **Framework**: NestJS
- **Base de datos**: PostgreSQL
- **ORM**: TypeORM
- **Autenticación**: JWT
- **Validación**: class-validator
- **Containerización**: Docker & Docker Compose
## 🔧 Instalación
### 1. Clonar el repositorio
```bash
git clone https://github.com/lolEstraski/wagonPrueba-.git

```
### 2. Instalar dependencias
```bash
npm install
```
### 3. Configurar variables de entorno
Crear un archivo `.env` en la raíz del proyecto  service  haga `cd service` en caso  de ser desplegado  saltar este paso
```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=tasks
DB_PASSWORD=h6kKePc3hXr4mRoe21AI8Gb82X5h6X4s
DB_DATABASE=task_manager

# JWT
JWT_SECRET=tu-jwt-secret-muy-seguro
JWT_EXPIRES_IN=7d

# App
PORT=3001
NODE_ENV=development
```

### 4. Levantar la base de datos con Docker
```bash
docker-compose up -d
```
### 6. Iniciar el servidor
```bash
# Desarrollo
npm run start:dev

## 🐳 Docker
### Ejecutar con Docker Compose
```bash
# Levantar todos los servicios
docker-compose up -d
# Ver logs
docker-compose logs -f
# Detener servicios
docker-compose down
# Limpiar volúmenes (elimina datos)
docker-compose down -v
``
## 🧪 Testing
```bash
# Tests unitarios
npm run test
# Coverage
npm run test:cov
```

### 3. Configurar mobile
haga `cd mobile` 
```
flutter pub get
flutter run
```

## 📌 Endpoints

### 🔐 Autenticación
- `POST /auth/register` - Registrar usuario
- `POST /auth/login` - Iniciar sesión

### 📝 Tareas *(requieren token JWT)*
- `GET /tasks` - Obtener todas tus tareas
- `GET /tasks/:id` - Obtener una tarea específica
- `POST /tasks` - Crear nueva tarea
- `PUT /tasks/:id` - Actualizar tarea
- `DELETE /tasks/:id` - Eliminar tarea
 Todos los endpoints de tareas requieren autenticación (envía token en el header `Authorization`)

### 3. link backeed desplegado
link de backend  deslegado  'https://proyecto-tareas-tjdj.onrender.com'

### 4. despliegue 
<img width="2167" height="1269" alt="image" src="https://github.com/user-attachments/assets/52ed1b80-4c46-49e3-8ef9-6f2fb8bd3cb0" />
### 5. aplicacion funcionando 
<img width="1251" height="780" alt="image" src="https://github.com/user-attachments/assets/6df28147-8a90-45c7-925f-495e63f6c3ed" />
<img width="1240" height="650" alt="image" src="https://github.com/user-attachments/assets/594175d0-e9c6-469c-8496-2861c21c4023" />
<img width="1239" height="632" alt="image" src="https://github.com/user-attachments/assets/6b1ae7d0-ac7d-4891-8070-cf883dc606b7" />
<img width="1233" height="455" alt="image" src="https://github.com/user-attachments/assets/d3c18897-42b0-40bb-baa2-cb89faeeda0b" />
<img width="1247" height="461" alt="image" src="https://github.com/user-attachments/assets/855d348a-3915-439d-9198-4375afbcc9d2" />
<img width="1239" height="347" alt="image" src="https://github.com/user-attachments/assets/e2d67f72-9399-4a62-94a5-4854080a24f1" />
<img width="1222" height="491" alt="image" src="https://github.com/user-attachments/assets/06d75265-8b3d-4873-b5ed-54a50caf4543" />

##  decision tecnica
una de las decisiones  tomadas en el transcurso del proyecto  es relaizar este patron  Test Driven Development (TDD) método de codificación en el que primero se escribe una prueba que falla, luego se escribe el código para que supere la prueba de desarrollo y se limpia el código. Este proceso se recicla para una nueva característica o cambio. haciendo un adelanto de como debe funcionar  nuestra apliacion haciendo dichas pruebas nos podes ahorra mucho trabajo ya que  son muy especificas  y son de gran utilidad, antes de hacer una cantidad de codigo  regado. asi simplificando  las cosas , otra decision es la implemntacion de jwt para todo  para que solo el usuario con su respectivo token pueda ver sus tareas, modificarlas. y es parte vital de la seguridad  toda aplicacion deberia tener.

## Resumen de la IA
nos apoyamos de la IA  para mapear  o encontrar ciertos errores, y darnos algunas ideas, tam,bien ciertos errores  que no mirabamos simple vista, algunas correciones de nuestra idea para no quedarnos estancados siempre siguiendo  este patron  Estructura de Pruebas Completa DTOs, Validación de datos de entrada/salida Services: Lógica de negocio y manejo de errores Controllers: Endpoints HTTP y validaciones Entity: Modelo de datos con TypeORM ella nos colaboraba  cuando  algo estaba mal y tambien refactorizando codigo  construir algo  y para que fuera mas legible brindando  nuestras  propias ideas de como queriamos  que  saliera, tambien nos ayudo mucho ya que el framework de flutter no lo conocia muy bien  era algo dificil en alguno de los git commit  se ve que pedimos ayuda para refactorizar , en la parte del backend tenia conocimientos previos aun asi ciertas caracteristicas  se me escapan pero gracias a la ia logramois nuestro cometido  un aplicacion fncional, las ia.

## 👥 Carlos Andres Ortegon Tique

- **Tu Nombre** - [GitHub](https://github.com/lolEstraski)


