# Changelog

Todos los cambios relevantes del proyecto serán documentados en este archivo.

El proyecto utiliza Semantic Versioning (`MAJOR.MINOR.PATCH`) para identificar las versiones publicadas.

---

---

## [Unreleased]

### Added

- Soporte para estrategia Blue-Green Deployment.
- Endpoint `GET /api/instance` para identificar la instancia activa.
- Identificación de versión mediante `APP_VERSION`.
- Identificación de instancia mediante `APP_INSTANCE`.
- Script `health-check.sh`.
- Script `e2e-test.sh`.
- Script `traffic-test.sh`.
- Script `switch-traffic.sh`.
- Script `rollback.sh`.
- Script principal `deploy.sh`.
- Workflow `.github/workflows/deploy.yml`.
- Estructura para almacenar releases versionadas.
- Estructura para logs de BLUE y GREEN.
- Gestión de PID para las instancias.
- Registro de instancia activa mediante `active-instance`.
- Validación de configuración Nginx antes del cambio de tráfico.
- Recuperación de configuración Nginx en caso de error.
- Integración preparada entre Release y Continuous Deployment.
- Opción de habilitar AWS mediante `ENABLE_AWS_DEPLOY`.

### Changed

- Versión del proyecto preparada para `1.0.1`.
- El proceso de deployment reutiliza el artifact publicado en GitHub Release.
- Los logs se almacenan de forma independiente por instancia y versión.

### Pending

- Configuración de AWS EC2.
- Instalación y configuración de Nginx en Linux.
- Configuración de GitHub Secrets para EC2.
- Validación funcional de `deploy.sh` en Linux.
- Validación funcional de `switch-traffic.sh`.
- Validación funcional de `rollback.sh`.
- Ejecución automática completa de CD.
- Evidencia de promoción BLUE → GREEN.
- Evidencia de rollback GREEN → BLUE.

---
## [1.2.0]

### Added
- Operación de multiplicación mediante GET /api/multiply.
- Formulario web conectado al endpoint de multiplicación.
- Pruebas del servicio para positivos, negativos, cero y decimales.
- Pruebas del endpoint para resultados y parámetros inválidos.

## [1.1.0]

### Added

- Operación de división.
- Endpoint REST `GET /api/divide?a={a}&b={b}`.
- Servicio `DivisionService` con la lógica de división.
- Modelo de respuesta `DivisionResponse`.
- Modelo de respuesta de error `DivisionErrorResponse`.
- Validación de división entre cero con respuesta `400 Bad Request`.
- Pruebas unitarias `DivisionServiceTest`, incluida la división entre cero.
- Pruebas de capa web `DivisionControllerTest` sobre el endpoint.
- Interfaz web de la operación de división.
- Integración frontend mediante `js/division.js`.

### Changed

- Versión del proyecto actualizada a `1.1.0`.
- `.gitignore` ignora archivos `*.pem` y `*.key` para evitar publicar claves privadas.

---

## [1.0.0]

### Added

- Aplicación inicial desarrollada con Spring Boot.
- Interfaz web inicial de la calculadora.
- Operación de suma.
- Endpoint REST para suma.
- Servicio para lógica de suma.
- Pruebas unitarias con JUnit.
- Integración de JaCoCo.
- Generación automática de reporte de Code Coverage.
- Pipeline de Continuous Integration con GitHub Actions.
- Etapa automática de Build.
- Ejecución automática de Unit Tests.
- Generación de reporte JaCoCo.
- Generación del artifact `.jar`.
- Publicación del JAR como artifact de GitHub Actions.
- Publicación del reporte JaCoCo como artifact.
- Protección de la rama `main`.
- Integración de funcionalidades mediante Pull Request.
- Ejecución del CI para ramas `feature/*`.
- Demostración controlada de un pipeline fallido.
- Corrección del test y recuperación del pipeline.
- GitHub Release automatizada mediante GitHub Actions.
- Release `v1.0.0`.
- Artifact `calculator-cicd-1.0.0.jar` publicado en GitHub Release.

---

## Versiones futuras

Las siguientes versiones se definirán de acuerdo con las funcionalidades integradas al proyecto.

Se utilizará el formato:

```text
MAJOR.MINOR.PATCH