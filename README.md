# DevOps Challenge

Prueba diseñada para ver tus habilidades en el mundo DevOps. Se evaluará las herramientas fundamentales que utilizamos
tales como docker, Nomad/Consul, CI/CD y Terraform. 

¡Te deseamos mucho éxito!

## Reglas

* Se debe de enviar un agregar commit luego de clonar el repositorio (Tryout begins...).
  - Solo se debe de agregar un archivo con extension ***.md**
  - El archivo debe de contener tus datos de contacto.
* Luego de concluir cada tarea debes de agregar un commit.
  - **No se permite un unico commit con todas las tareas**.
  - Una tarea puede tener multiples commits si asi lo consideras adecuado.
* Puedes realizar las tareas en el orden que creas conveniente.
* Puedes obviar algunas de las sub-tareas de las tareas.
* Cada tarea debe de ir en una carpeta dentro de la carpeta **code**
  - docker > docker files
  - ci-cd > pipelines (Bamboo, Jenkins, etc)
  - iac > terraform (TF files)
  - scripts > scripts (Pyhton, bash, etc.)
  - kubernetes > manifiestos y todo lo relacionado

## Tareas

### Docker

* Dockerizar la aplicacion dentro de la carpeta app
  - Multistage de ser posible
  - Tamaño reducido (`Produción`)
* Crear un docker-compose que contenga: **PHP 8.2**, **Nginx 1.18**, **MySQL 8.0**
  - Nginx debe escuchar en el puerto **8888** (`http://localhost:8888`)
  - Agregar la ruta `http://localhost:8888/info.php` (PHP Info)
  - Nginx depende de PHP
  - Agregar una red para estas imagenes (`chicho`)
  - Se debe de healthchecks para PHP y MySQL

### CI/CD
* Crear un pipeline para hacer build de una imagen docker (usar el codigo de la carpeta `app`)
  - Correr los tests si fuese el caso
  - Hacer build de la imagen

### Orquestacion
* Crear un Nomad job (group: **tryout**, task: **demo**) en modo servicio que ejecute hello-world
* Crear un Nomad job de tipo batch que se ejecute cada hora y haga curl a https://www.google.com

### IaC
>En lo mposible no usar modulos de terceros
* Crear una instancia EC2 basada en Amazon Linux 2 usando terraform
  - EBS de 30Gb
  - instancia t3a.micro
  - Agregar una IP elastica
* Crear un ALB
  - Agregar 2 listeners
    * Limitar por IP
    * Limitar por Metodo (POST)
  - Agregar la opcion de forzar HTTPS (HTTP -> HTTPS)

### Scripting (bash, python, perl, php, etc.)
* hacer un script para descargar un archivo de S3 (bucket: devops-tryouts)
* hacer un script para validar que un servicio este activo (Nginx en puerto 88)
* hacer un script para depurar imagenes docker
* Hacer un script para obtener datos de Consul (KV: config/app)

### Kubernetes
* Crear los manfiestos necesarios segun criterio, se puede usar helm
* Desplegar un servicio y mostrar la id del pod.
* Crear un ingress.
* Creacion de secretos y configmap que esto realize una inyeccion al pod y se haga la validacion de esto.
* Crear una politica de auto escalado con los siguientes párametros. 
  - scale in : CPU utilization > 80%
  - scale out : CPU Utilization < 60%
