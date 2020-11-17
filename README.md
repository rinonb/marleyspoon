## Setup

Create a copy of the .env file

``cp .env.example .env``

Make sure to fill env variables in the new .env file. You will need these variables set before you can start the app:
```
REDIS_HOST
REDIS_PORT
CONTENTFUL_SPACE_ID
CONTENTFUL_ENVIRONMENT
CONTENTFUL_ACCESS_TOKEN
```
***
### Starting the app

#### Docker Compose

Source the .env file and start docker

```
source .env
docker-compose up
```

#### Local host

In order to run the app locally, without docker, you need to:
1. Install Ruby 2.7.2
2. Have Redis running
3. Set REDIS_HOST and REDIS_PORT to your local redis instance in .env

```
bundle install
source .env
rackup
```

Go to http://localhost:9898/ 🎊 
***
## Specs
All specs are written with rspec:

``rspec spec``
