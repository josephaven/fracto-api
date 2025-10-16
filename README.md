# FRACTO API

Backend en **Laravel 11 + Sanctum + PostgreSQL** para la aplicación educativa **FRACTO**, desarrollada como parte de las prácticas profesionales en la Universidad Veracruzana.  
Esta API gestiona el registro, autenticación y sesiones de jugadores que interactúan con la app **Godot**, permitiendo sincronizar progreso, estadísticas y sesiones de minijuegos.

---

## Características principales

- API RESTful basada en Laravel Sanctum (tokens personales Bearer)
- Autenticación de usuarios (registro, login, logout, perfil)
- Integración con base de datos **PostgreSQL**
- Documentación completa en formato **OpenAPI 3.0 (Swagger/ReDoc)**
- Soporte CORS y estructura para futuras extensiones (juego, estadísticas, exportación CSV)

---

## Requisitos

| Herramienta | Versión recomendada |
|--------------|--------------------|
| PHP          | ≥ 8.2              |
| Composer     | ≥ 2.6              |
| PostgreSQL   | ≥ 14               |
| Node.js (solo para docs) | ≥ 18 |

---

## Instalación local

```bash
# 1. Clonar el repositorio
git clone https://github.com/josephaven/fracto-api.git
cd fracto-api

# 2. Instalar dependencias PHP
composer install

# 3. Copiar variables de entorno
cp .env.example .env

# 4. Generar clave de aplicación
php artisan key:generate

# 5. Configurar tu conexión PostgreSQL en .env
#    (DB_DATABASE=fracto, DB_USERNAME=postgres, DB_PASSWORD=tu_clave)

# 6. Ejecutar migraciones
php artisan migrate

# 7. Levantar el servidor local
php artisan serve

```

## Endpoints principales (v1)

| Método | Ruta | Descripción |
|:------:|:-----|:------------|
| POST | https://fracto-api.onrender.com/api/v1/auth/register | Registro de usuario |
| POST | https://fracto-api.onrender.com/api/v1/auth/login | Inicio de sesión |
| GET  | https://fracto-api.onrender.com/api/v1/auth/me | Perfil autenticado |
| POST | https://fracto-api.onrender.com/api/v1/auth/logout | Cerrar sesión actual |
| POST | https://fracto-api.onrender.com/api/v1/auth/logout-all | Cerrar todas las sesiones |


## Autenticación

El sistema usa **Laravel Sanctum** para emitir tokens personales.

Ejemplo de encabezado: Authorization: Bearer <token>


## Estructura mínima de la base de datos

| Tabla | Descripción |
|:------|:-------------|
| users | Usuarios registrados |
| personal_access_tokens | Tokens de autenticación (Laravel Sanctum) |


## Documentación técnica

- OpenAPI Spec: `openapi/fracto-auth.yml`
- Vista ReDoc local: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)

Para regenerar:
```bash
npx @redocly/cli build-docs openapi/fracto-auth.yml -o public/docs/index.html
```

## Pruebas y ejemplos

Puedes probar los endpoints con:

- **Postman** → importa `openapi/fracto-auth.yml`
- **Thunder Client (VS Code)** → abre directamente el archivo YAML
- **cURL:**
```bash
curl -X POST http://127.0.0.1:8000/api/v1/auth/register \
-H "Content-Type: application/json" \
-d '{"name":"Jose","email":"zS000000@estudiantes.uv.mx","password":"supersegura123"}'
```

## Seguridad y buenas prácticas

- Hash de contraseñas con bcrypt
- Tokens personales con Laravel Sanctum
- Configuración CORS abierta en desarrollo (`config/cors.php`)
- Rate limiting: `->middleware('throttle:60,1')`
- Logs centralizados (canal stack, nivel debug)
- Variables sensibles solo en `.env`

## Autor

**Joseph Javier Avendaño Rodríguez**  
Facultad de Contaduría y Administración - Campus Coatzacoalcos - Universidad Veracruzana  
2025 © FRACTO

## Licencia
Proyecto distribuido bajo **Licencia MIT**

