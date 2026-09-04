# Calculator CI/CD

Proyecto final del módulo de CI/CD del Diplomado DevSecOps.

El proyecto implementa una aplicación web de calculadora desarrollada con Spring Boot y un proceso completo de integración, publicación y despliegue continuo utilizando GitHub, GitHub Actions, Maven, JUnit, JaCoCo, GitHub Releases y scripts Bash.

El objetivo principal no es únicamente desarrollar la calculadora, sino demostrar un flujo CI/CD automatizado, repetible, verificable y trazable desde el desarrollo de una funcionalidad hasta la publicación y despliegue de una versión.

---

## 1. Objetivo del proyecto

Implementar un flujo de trabajo que permita:

- Desarrollar nuevas funcionalidades mediante ramas `feature/*`.
- Integrar cambios a `main` mediante Pull Requests.
- Ejecutar automáticamente compilación y pruebas.
- Generar reportes de cobertura con JaCoCo.
- Generar un archivo `.jar` ejecutable.
- Publicar versiones mediante Git tags y GitHub Releases.
- Automatizar el deployment mediante scripts Bash.
- Aplicar una estrategia Blue-Green.
- Validar la nueva versión mediante Health Checks y pruebas E2E.
- Verificar el tráfico mediante Nginx.
- Ejecutar rollback cuando una nueva versión presenta problemas.

---

## 2. Aplicación

La aplicación corresponde a una calculadora web desarrollada con Spring Boot.

Las operaciones del proyecto son:

- Suma.
- Resta.
- Multiplicación.
- División.

Cada operación se desarrolla de manera independiente utilizando ramas `feature/*`.

### Estado actual

| Funcionalidad | Estado |
|---|---|
| Aplicación Spring Boot | Implementada |
| Interfaz web | Implementada |
| Suma | Implementada |
| Resta | En desarrollo |
| Multiplicación | En desarrollo |
| División | En desarrollo |
| JUnit | Implementado |
| JaCoCo | Implementado |
| CI con GitHub Actions | Implementado |
| GitHub Release | Implementado |
| Scripts Blue-Green | Implementados |
| CD hacia AWS | Preparado, pendiente de infraestructura |
| Deployment AWS | Pendiente |

Este estado deberá actualizarse a medida que las demás operaciones sean integradas.

---

## 3. Tecnologías

El proyecto utiliza:

- Java 20
- Spring Boot
- Maven
- JUnit
- JaCoCo
- Spring Boot Actuator
- HTML
- CSS
- JavaScript
- Git
- GitHub
- GitHub Actions
- GitHub Releases
- Bash
- Linux
- Nginx
- SSH

Para la etapa final de deployment se utilizará una instancia Linux en AWS EC2.

---

## 4. Arquitectura general

El flujo previsto del proyecto es:

```text
                       DEVELOPER
                           │
                           ▼
                         GitHub
                           │
                    Feature Branch
                           │
                           ▼
                     Pull Request
                           │
                           ▼
                  GitHub Actions - CI
                           │
             ┌─────────────┼─────────────┐
             ▼             ▼             ▼
           Build         Tests         JaCoCo
             │             │             │
             └─────────────┼─────────────┘
                           ▼
                          JAR
                           │
                           ▼
                        Git Tag
                           │
                           ▼
                    GitHub Release
                           │
                           ▼
                     CD Workflow
                           │
                        SSH/SCP
                           │
                           ▼
                       Linux Server
                           │
                           ▼
                         Nginx
                           │
                  ┌────────┴────────┐
                  ▼                 ▼
              BLUE :8080        GREEN :8081
                  │                 │
                  └────────┬────────┘
                           ▼
                     Health Check
                           │
                           ▼
                       E2E Tests
                           │
                    ┌──────┴──────┐
                    ▼             ▼
                  PASS           FAIL
                    │             │
                    ▼             ▼
               New Version     Rollback
```

---

## 5. Estructura del repositorio

La estructura principal del proyecto es:

```text
calculator-cicd/
│
├── .github/
│   └── workflows/
│       ├── maven.yml
│       ├── release.yml
│       └── deploy.yml
│
├── scripts/
│   ├── deploy.sh
│   ├── health-check.sh
│   ├── e2e-test.sh
│   ├── traffic-test.sh
│   ├── switch-traffic.sh
│   └── rollback.sh
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   │
│   └── test/
│
├── pom.xml
├── README.md
└── CHANGELOG.md
```

---

## 6. Estrategia de branching

El proyecto utiliza principalmente:

```text
main
feature/*
```

La rama `main` contiene código integrado y validado.

Cada nueva funcionalidad debe implementarse en una rama independiente.

Ejemplos:

```text
feature/addition
feature/subtraction
feature/multiplication
feature/division
feature/deployment-support
```

### Flujo de trabajo

```text
main
  │
  └── feature/*
          │
          ▼
      desarrollo
          │
          ▼
       push
          │
          ▼
     GitHub Actions
          │
          ▼
    Pull Request
          │
          ▼
       revisión
          │
          ▼
       CI exitoso
          │
          ▼
         merge
          │
          ▼
         main
```

Las funcionalidades no deben desarrollarse directamente sobre `main`.

---

## 7. Protección de `main`

La rama `main` utiliza reglas de protección para evitar integraciones directas o cambios no revisados.

Las reglas configuradas incluyen:

- Integración mediante Pull Request.
- Al menos una aprobación.
- Resolución de conversaciones antes del merge.
- Ejecución satisfactoria del pipeline CI.
- Protección contra eliminación.
- Protección contra force push.
- Revisión de cambios antes de integrarlos.

Durante el proyecto también se demostró el comportamiento del pipeline cuando una prueba falla.

En ese escenario:

```text
Test FAIL
   ↓
CI FAIL
   ↓
Pull Request bloqueado
```

Después de corregir la prueba:

```text
Test PASS
   ↓
CI PASS
   ↓
Approval
   ↓
Merge
```

---

## 8. Versionamiento

El proyecto utiliza Semantic Versioning:

```text
MAJOR.MINOR.PATCH
```

Ejemplos:

```text
1.0.0
1.1.0
1.1.1
2.0.0
```

Los tags utilizan el prefijo `v`.

Ejemplo:

```text
v1.0.0
```

### Relación entre versión, tag y Release

```text
pom.xml
1.0.0
   │
   ▼
Tag
v1.0.0
   │
   ▼
GitHub Release
v1.0.0
   │
   ▼
calculator-cicd-1.0.0.jar
```

La versión declarada en `pom.xml` debe coincidir con el tag utilizado para publicar la Release.

---

## 9. Continuous Integration

El workflow principal de integración continua está ubicado en:

```text
.github/workflows/maven.yml
```

Se ejecuta cuando existen cambios en:

```text
main
feature/**
```

y también para Pull Requests hacia `main`.

El pipeline implementa:

```text
Checkout
   ↓
Setup JDK
   ↓
Build
   ↓
Unit Tests
   ↓
Code Coverage
   ↓
Package
   ↓
Artifacts
```

### Build

```bash
mvn -B clean compile --file pom.xml
```

### Unit Tests

```bash
mvn -B test --file pom.xml
```

### Code Coverage

JaCoCo genera el reporte de cobertura.

### Package

```bash
mvn -B package -DskipTests --file pom.xml
```

Al finalizar se publican como artifacts de GitHub Actions:

- JAR de la aplicación.
- Reporte JaCoCo.

---

## 10. Pruebas unitarias

Las pruebas unitarias utilizan JUnit.

Actualmente la operación de suma cuenta con pruebas para verificar diferentes escenarios de cálculo.

Las pruebas son ejecutadas automáticamente durante CI.

También se realizó una prueba controlada modificando intencionalmente un resultado esperado para demostrar que GitHub Actions detecta errores.

El resultado fue:

```text
JUnit FAIL
    ↓
Maven BUILD FAILURE
    ↓
GitHub Actions FAIL
    ↓
Pull Request bloqueado
```

Después de restaurar el resultado esperado, el pipeline volvió a finalizar correctamente.

---

## 11. Code Coverage

JaCoCo se utiliza para medir la cobertura de código.

El reporte se genera en:

```text
target/site/jacoco/
```

Localmente puede abrirse:

```text
target/site/jacoco/index.html
```

El reporte permite consultar información como:

- Classes.
- Methods.
- Lines.
- Branches, cuando la lógica evaluada contiene decisiones.

La cobertura permite identificar partes de la aplicación que no han sido verificadas mediante pruebas automatizadas.

No se busca únicamente obtener un porcentaje alto de cobertura, sino disponer de pruebas relevantes para la lógica del proyecto.

---

## 12. Artifact

El proceso genera un archivo `.jar` ejecutable.

Ejemplo:

```text
target/
└── calculator-cicd-1.0.1.jar
```

El artifact representa una versión concreta de la aplicación.

Durante el deployment no se debe volver a compilar el proyecto.

El flujo utilizado es:

```text
Maven
  ↓
JAR
  ↓
GitHub Release
  ↓
CD
  ↓
Linux
```

De esta manera se despliega el artifact publicado y no una nueva compilación realizada en el servidor.

---

## 13. GitHub Releases

El workflow:

```text
.github/workflows/release.yml
```

se ejecuta mediante tags con el formato:

```text
v*.*.*
```

Ejemplo:

```bash
git tag v1.0.0
git push origin v1.0.0
```

El workflow realiza:

```text
Tag
 ↓
Validación del tag contra pom.xml
 ↓
Build
 ↓
Tests
 ↓
Package
 ↓
GitHub Release
 ↓
JAR
```

Antes de publicar la Release se verifica que:

```text
Tag version == pom.xml version
```

Por ejemplo:

```text
Tag:         v1.0.0
pom.xml:     1.0.0
Artifact:    calculator-cicd-1.0.0.jar
Release:     v1.0.0
```

La primera Release publicada durante el proyecto corresponde a:

```text
v1.0.0
```

---

## 14. Endpoint de identificación de instancia

Para demostrar el funcionamiento de Blue-Green se implementó:

```http
GET /api/instance
```

Ejemplo BLUE:

```json
{
  "application": "calculator-cicd",
  "version": "1.0.1",
  "instance": "BLUE",
  "port": "8080"
}
```

Ejemplo GREEN:

```json
{
  "application": "calculator-cicd",
  "version": "1.0.1",
  "instance": "GREEN",
  "port": "8081"
}
```

La instancia y versión se configuran mediante variables de entorno:

```text
APP_INSTANCE
APP_VERSION
```

---

## 15. Continuous Deployment

El workflow de deployment está definido en:

```text
.github/workflows/deploy.yml
```

Su responsabilidad será:

1. Obtener el `.jar` publicado en GitHub Release.
2. Configurar la conexión SSH.
3. Copiar el artifact al servidor.
4. Copiar los scripts Bash.
5. Ejecutar el proceso Blue-Green.
6. Verificar el deployment.
7. Ejecutar pruebas de tráfico.

El workflow dispone de:

```text
workflow_call
```

para ser invocado desde el workflow de Release y:

```text
workflow_dispatch
```

para permitir un deployment manual de una Release existente.

### Estado del CD

El workflow y los scripts están implementados en el repositorio.

La conexión con la infraestructura AWS se realizará durante la siguiente etapa del proyecto.

Hasta completar dicha configuración, el deployment automático hacia AWS debe considerarse pendiente de validación.

---

## 16. Habilitación del deployment AWS

El workflow de Release solamente ejecutará el deployment automático cuando se configure:

```text
ENABLE_AWS_DEPLOY=true
```

Mientras esta variable no exista o tenga otro valor:

```text
Release
   ↓
Artifact publicado
   ↓
AWS deployment skipped
```

Una vez habilitado:

```text
Release
   ↓
Artifact publicado
   ↓
deploy.yml
   ↓
AWS
```

La configuración específica de AWS y GitHub Secrets se documentará después de implementar y verificar la infraestructura.

---

## 17. Estrategia de deployment

La estrategia seleccionada es:

# Blue-Green Deployment

Se utilizan dos instancias lógicas de la misma aplicación:

```text
BLUE
└── 8080

GREEN
└── 8081
```

Nginx funciona como punto de entrada:

```text
                 NGINX
                  :80
                   │
           ┌───────┴───────┐
           ▼               ▼
      BLUE :8080       GREEN :8081
```

Solo una de las instancias recibe tráfico de usuarios en un momento determinado.

La otra queda disponible para recibir la nueva versión.

---

## 18. Justificación de Blue-Green

Blue-Green fue seleccionado porque permite:

- Mantener una versión funcional mientras se despliega otra.
- Ejecutar Health Checks antes de cambiar tráfico.
- Ejecutar pruebas E2E antes de promover una versión.
- Reducir el riesgo durante el deployment.
- Cambiar el tráfico mediante Nginx.
- Regresar rápidamente a la instancia anterior.
- Demostrar claramente el procedimiento de rollback.

Para una aplicación pequeña como esta calculadora, permite demostrar de forma sencilla los principios de promoción y recuperación de versiones.

---

## 19. Flujo Blue-Green

Supongamos que BLUE está activo:

```text
NGINX
  ↓
BLUE v1.0.1
```

Se despliega una nueva versión en GREEN:

```text
BLUE v1.0.1 ← sigue atendiendo usuarios

GREEN v1.0.2
      ↓
Health Check
      ↓
E2E
```

Si todo funciona:

```text
NGINX
  ↓
GREEN v1.0.2
```

BLUE continúa temporalmente disponible para rollback.

El siguiente deployment utiliza nuevamente BLUE.

```text
BLUE → GREEN → BLUE → GREEN
```

---

## 20. Estructura de deployment Linux

La estructura diseñada para el servidor es:

```text
/opt/calculator-cicd/
│
├── releases/
│   ├── v1.0.1/
│   │   └── calculator-cicd-1.0.1.jar
│   │
│   └── v1.0.2/
│       └── calculator-cicd-1.0.2.jar
│
├── logs/
│   ├── blue-v1.0.1.log
│   └── green-v1.0.2.log
│
├── run/
│   ├── blue.pid
│   ├── green.pid
│   └── active-instance
│
└── scripts/
    ├── deploy.sh
    ├── health-check.sh
    ├── e2e-test.sh
    ├── traffic-test.sh
    ├── switch-traffic.sh
    └── rollback.sh
```

La creación y validación de esta estructura en AWS está pendiente para la etapa de infraestructura.

---

## 21. Scripts Bash

### `deploy.sh`

Orquesta el deployment completo.

Responsabilidades:

- Recibir versión y artifact.
- Identificar la instancia actualmente activa.
- Seleccionar BLUE o GREEN como destino.
- Guardar el JAR en `releases/`.
- Detener una ejecución anterior del slot destino.
- Iniciar la nueva versión.
- Guardar PID y logs.
- Ejecutar Health Check.
- Ejecutar E2E.
- Cambiar tráfico.
- Verificar la aplicación mediante Nginx.
- Ejecutar rollback si corresponde.

Ejemplo futuro en Linux:

```bash
./scripts/deploy.sh \
  v1.0.1 \
  /tmp/calculator-cicd-1.0.1.jar
```

---

### `health-check.sh`

Comprueba el estado del servicio mediante Spring Boot Actuator.

Ejemplo:

```bash
./scripts/health-check.sh localhost 8080
```

Endpoint utilizado:

```text
/actuator/health
```

Resultado esperado:

```json
{
  "status": "UP"
}
```

El script utiliza reintentos para permitir que Spring Boot termine de iniciar.

---

### `e2e-test.sh`

Comprueba una operación real de la aplicación desplegada.

Actualmente valida:

```text
2 + 3 = 5
```

mediante:

```http
GET /api/add?a=2&b=3
```

El Health Check comprueba que la aplicación está disponible.

La prueba E2E comprueba que la funcionalidad real responde correctamente.

---

### `traffic-test.sh`

Realiza múltiples solicitudes a:

```http
GET /api/instance
```

Ejemplo:

```bash
./scripts/traffic-test.sh localhost 80 10
```

Esto permite observar qué instancia está procesando las solicitudes.

---

### `switch-traffic.sh`

Modifica la configuración de Nginx para dirigir tráfico a:

```text
BLUE :8080
```

o:

```text
GREEN :8081
```

Antes de recargar Nginx se ejecuta:

```bash
nginx -t
```

La configuración anterior se conserva temporalmente para poder restaurarla si la nueva configuración presenta errores.

---

### `rollback.sh`

Permite restaurar el tráfico hacia la instancia anterior.

Antes de cambiar tráfico:

1. Verifica que la instancia anterior esté disponible.
2. Ejecuta el cambio de tráfico.
3. Ejecuta una prueba E2E mediante Nginx.
4. Actualiza `active-instance`.

---

## 22. Health Check

Spring Boot Actuator expone:

```http
GET /actuator/health
```

El proceso de deployment no promueve una nueva instancia directamente.

Primero se ejecuta:

```text
Deploy
   ↓
Health Check
```

Solo si el resultado es:

```text
UP
```

el proceso continúa.

---

## 23. Pruebas End-to-End

Después del Health Check se ejecuta una prueba sobre la funcionalidad de la aplicación.

```text
Deploy
   ↓
Health Check
   ↓
E2E
   ↓
PASS / FAIL
```

Si la prueba falla antes del cambio de tráfico:

```text
Nueva instancia
      ↓
E2E FAIL
      ↓
Instancia detenida
      ↓
Instancia anterior continúa activa
```

Por tanto, no es necesario ejecutar rollback porque el tráfico nunca llegó a la nueva versión.

---

## 24. Rollback

El rollback se utiliza cuando el fallo ocurre después de promover la nueva instancia.

Ejemplo:

```text
BLUE activo
    ↓
Deploy GREEN
    ↓
Health ✅
    ↓
E2E ✅
    ↓
Traffic → GREEN
    ↓
Verificación final ❌
    ↓
Rollback
    ↓
Traffic → BLUE
    ↓
E2E
    ↓
BLUE recuperado
```

El procedimiento permite:

- Detectar el fallo.
- Mantener o recuperar la versión anterior.
- Restaurar el tráfico.
- Verificar que el sistema volvió a funcionar.

---

## 25. Ejecución local

### Requisitos

- Java 20.
- Maven.
- Git.

Verificar Java:

```bash
java -version
```

Verificar Maven:

```bash
mvn -version
```

### Compilar y ejecutar pruebas

```bash
mvn clean verify
```

### Ejecutar Spring Boot

```bash
mvn spring-boot:run
```

La aplicación estará disponible normalmente en:

```text
http://localhost:8080
```

---

## 26. Ejecución manual BLUE

Después de generar el JAR:

```bash
mvn clean package
```

En PowerShell:

```powershell
$env:APP_INSTANCE="BLUE"
$env:APP_VERSION="1.0.1"

java -jar target\calculator-cicd-1.0.1.jar `
  --server.port=8080
```

---

## 27. Ejecución manual GREEN

En otra terminal PowerShell:

```powershell
$env:APP_INSTANCE="GREEN"
$env:APP_VERSION="1.0.1"

java -jar target\calculator-cicd-1.0.1.jar `
  --server.port=8081
```

Puede comprobarse:

```text
http://localhost:8080/api/instance
http://localhost:8081/api/instance
```

---

## 28. Validación de scripts

Los scripts pueden verificarse sintácticamente con Bash:

```bash
bash -n scripts/health-check.sh
bash -n scripts/e2e-test.sh
bash -n scripts/traffic-test.sh
bash -n scripts/switch-traffic.sh
bash -n scripts/rollback.sh
bash -n scripts/deploy.sh
```

Los scripts que dependen de Nginx y `systemctl` requieren un entorno Linux para su prueba funcional completa.

---

## 29. Flujo CI/CD completo

```text
Desarrollo
    ↓
feature/*
    ↓
Push
    ↓
CI
    ↓
Pull Request
    ↓
Tests / Coverage
    ↓
Approval
    ↓
Merge main
    ↓
Actualizar versión
    ↓
Tag
    ↓
Release workflow
    ↓
GitHub Release
    ↓
JAR
    ↓
CD workflow
    ↓
Servidor Linux
    ↓
Blue-Green
    ↓
Health Check
    ↓
E2E
    ↓
Switch Traffic
    ↓
Traffic Test
    ↓
PASS / FAIL
       │
       ├── PASS → Nueva versión activa
       │
       └── FAIL → Rollback
```

---

## 30. Evidencias del proyecto

Durante el desarrollo se deberán conservar evidencias de:

- Repositorio GitHub.
- Ramas utilizadas.
- Protección de `main`.
- Pull Requests.
- Aprobaciones.
- CI exitoso.
- CI fallido intencionalmente.
- Corrección del CI.
- Reporte JaCoCo.
- Artifacts del workflow.
- Git tags.
- GitHub Releases.
- Archivo `.jar` publicado.
- Ejecución BLUE.
- Ejecución GREEN.
- Endpoint `/api/instance`.
- Health Check.
- E2E.
- Configuración Nginx.
- Deployment.
- Cambio de tráfico.
- Rollback.

---

## 31. Estado de infraestructura

La etapa de infraestructura AWS todavía no se considera completada.

Los siguientes componentes están preparados en código:

```text
deploy.yml
deploy.sh
health-check.sh
e2e-test.sh
traffic-test.sh
switch-traffic.sh
rollback.sh
```

Los siguientes elementos serán configurados y validados durante la etapa de infraestructura:

```text
AWS EC2
Linux
Java 20
Nginx
SSH
GitHub Secrets
ENABLE_AWS_DEPLOY
/opt/calculator-cicd/
Deployment automático
Rollback real
```

Una vez completada dicha etapa, esta sección deberá actualizarse con la configuración y evidencias finales.

---

## 32. Integrantes

Proyecto desarrollado como trabajo grupal para el módulo de CI/CD del Diplomado DevSecOps.

Integrantes:

- Edmundo Junior Zenteno Rojas
- Integrante 2
- Integrante 3
- Integrante 4

Los nombres restantes deberán actualizarse con la información definitiva del equipo.

---

## 33. Conclusión

El proyecto busca demostrar la integración de todas las etapas principales de un proceso CI/CD:

```text
Branching
    ↓
Versionamiento
    ↓
Continuous Integration
    ↓
Testing
    ↓
Code Coverage
    ↓
Artifact
    ↓
GitHub Release
    ↓
Continuous Deployment
    ↓
Blue-Green
    ↓
Health Check
    ↓
E2E
    ↓
Verification
    ↓
Rollback
```

Cada componente posee una responsabilidad específica y forma parte de un flujo integrado de entrega de software.