# FlagsApp 2.0

Este proyecto consta en el desarollo de una app en Ruby on Rails, para poder cumplir con los requerimientos especificados por el cliente.

En esta segunda version de la aplicacion el cliente nos solicito orientar la aplicacion a una arquitectura de microservicios debido a los problemas de escabilidad en el mismo, producto del gran exito de la anterior version.

## Introduccion

Estas instrucciones te van a permitir poder correr el proyecto tanto en un ambiente local para testing y develop, como en un ambiente de produccion.

La documentacion se encuentra en el siguiente link [**click aqui**](https://github.com/crizulm/flagsapp/blob/master/Documentacion.pdf)

### Pre requesitios

Para poder ejecutar Flagsapp es necesario tener instalado las siguientes herramientas

- [**Ruby 2.5.1P57**](https://www.ruby-lang.org/es/)
- [**Rails 5.2.0**](https://rubyonrails.org)
- [**PostgreSQL 10.5**](https://www.postgresql.org)
- [**Imagemagick 7.0.8**](https://www.imagemagick.org)

### Desplegado development y test

A continuacion iremos a explicar paso por paso como hacer para poder ejecutar FlagsApp en un ambiente de desarollo.

1- **Configurando variables de entorno**
Primero que nada debemos configurar las variables de entorno en el archivo que se encuentra en <kbd>config/application.yml</kbd> dentro de la seccion **development** las variables que debemos configurar son las siguientes:
```
development:
  INVITES_URL_SERVICE: "http://invites-flagsapp.herokuapp.com" # URL del microservicio de invitaciones
  INVITES_TOKEN_SERVICE: "oneToken" # Token de autenticacion del microservicio de invitaciones
  REPORTS_URL_SERVICE: "http://reports-flagsapp.herokuapp.com" # URL del microservicio de reportes
  REPORTS_TOKEN_SERVICE: "oneToken" # Token de autenticacion del microservicio de reportes
  GOOGLE_CLIENT_ID: "oneClientId" # Client ID de las credenciales para Google OAuth
  GOOGLE_CLIENT_SECRET: "oneSecretId" # Secret de las credenciales para Google OAuth
  ROLLBAR_ACCESS_TOKEN: "oneRollbarToken" # Token del servicio Rollbar
```
2-  **Instalando las Gemas utilizadas**
Lo segundo que debemos hacer es instalar las gemas que utilizamos corriendo el siguiente comando
```
$ bundle install
```
3- **Corriendo las migraciones**
Luego debemos crear la base de datos, y correr las migraciones necesarias; para esto debemos correr los siguientes comandos:
```
$ rails db:create
$ rails db:migrate
```
4- **Correr la app**
Por ultimo debemos simplemente correr nuestra app en el servidor Puma
```
$ rails server
```
La aplicacion deberia estar corriendo en [localhost:3000](https://localhost:3000)

## Desplegado production

La aplicacion fue desplegada en Heroku y se puede acceder mediante el siguiente link [flagsapp-ort.herokuapp.com](https://flagsapp-ort.herokuapp.com)

## Gemas

Para el desarollo de la app se utilizaron las siguientes gemas

- Okcomputer
- Rollbar
- Coocon
- Rubocop
- Devise
- Bootstrap
- JQuery
- Font Awesome
- Carrierwave
- Mini Magick
- Figaro
- Hint
- Rest Client
- New Relic APM
- Active link to
- Omniauth Google OAuth

## Versionado

Nosotros utilizamos [Github](http://github.com/) para el control de version. Se opto por utilizar 2 branches principales.

- <kbd>master</kbd> - Branch que contiene el codigo en produccion.
- <kbd>develop</kbd> - Branch que se utiliza para desarollar y introducir nuevas features

- <kbd>feature/**name**</kbd> - Branch que se utiliza para el desarollo de cada feature en el sistema.

Notas: Cabe destacar que la aplicacion es desplegada mediante pipelines en la rama **master**

## Autores

* Matias Crizul
* Santiago Marchisio

