# Task Manager API

Una API REST completa para gestión de tareas construida con NestJS, TypeORM y PostgreSQL, la cual consta como un block en el cual puedes listar tus tareas , y su respectivo crud en la cual podras ver tus tareas pendentes , tareas completadas, tambien con un login y un registrar usuarios todo encryptado con  jwt para la seguridad 
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

## 👥 Carlos Andres Ortegon Tique

- **Tu Nombre** - [GitHub](https://github.com/lolEstraski)


