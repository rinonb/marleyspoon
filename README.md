## Setup

Create a copy of the .env file

``cp .env.example .env``

Make sure to fill env variables in the new .env file.
***
### Starting the app

#### Docker Compose

Source the .env file and start docker

```
source .env
docker-compose up
```

#### Local host

If you wish to run the app locally without docker:

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