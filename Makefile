stack_name = budget
php_container_id = $(shell docker ps --filter name="$(stack_name)_php-fpm" -q)
DOCKER=docker-compose

default: help

help::
	@printf "\n"
	@printf "\033[90;42m                                                    \033[39;0m\n"
	@printf "\033[90;42m           Raldo Makefile help:                     \033[39;0m\n"
	@printf "\033[90;42m                                                    \033[39;0m\n"
	@printf "\n"
	@printf "\033[32m   docker-build           \033[39m build container docker\n"
	@printf "\033[32m   docker-up              \033[39m run composer update in docker\n"
	@printf "\033[32m   composer-install       \033[39m run composer install in docker\n"
#	@printf "\033[32m   composer-update        \033[39m run composer update in docker\n"
#	@printf "\033[32m   composer-require       \033[39m run composer require in docker (package="group/mypackage-bundle")\n"
	@printf "\033[32m   shell                  \033[39m shell \n"
	@printf "\n"
	@printf "\033[32m   db-install             \033[39m run db creation and update commands in docker\n"
	@printf "\033[32m   complete-install       \033[39m run env, docker-build, composer-install, and db-install\n"
	@printf "\n"
#	@printf "\033[32m   fix                    \033[39m run php-cs-fixer in docker\n"
#	@printf "\033[32m   test                   \033[39m load test docker env and run behat test suite in docker\n"
#	@printf "\033[32m   security               \033[39m run sensiolabs security check on composer.lock\n"
#	@printf "\033[32m   check                  \033[39m run make fix, test, and security\n"
	@printf "\n"

################################################################################
########################### Project install commands ###########################
################################################################################

.PHONY: docker-build
docker-build:
	@printf "\033[90;44m           Docker-build          \033[39;0m\n"
	@printf "\n"
	$(DOCKER) build --force-rm --no-cache
	@printf "\n"

.PHONY: docker-up
docker-up:
	@printf "\033[90;44m           Docker up          \033[39;0m\n"
	@printf "\n"
	$(DOCKER) up -d --remove-orphans
	@printf "\n"

.PHONY: shell
shell:
	@printf "\033[90;44m           Command sh into container php-fpm          \033[39;0m\n"
	@printf "\n"
	docker exec -it "$(php_container_id)" /bin/bash
	@printf "\n"


################################################################################
########################### Composer commands ##################################
################################################################################

.PHONY: composer-update
composer-update:
	docker exec -it "$(php_container_id)" php -d memory_limit=-1 /usr/bin/composer update

.PHONY: composer-install
composer-install:
	docker exec -it "$(php_container_id)" php -d memory_limit=-1 /usr/bin/composer install

.PHONY: composer-require
composer-require:
	@printf "\033[90;44m           Composer Require          \033[39;0m\n"
	@printf "\n"
	$(EXEC) composer require $(package)
	@printf "\n"

################################################################################
########################### Command Symfony ####################################
################################################################################

.PHONY: sf
sf:
	docker exec -it "$(php_container_id)" php bin/console $(cmd)

.PHONY: db-update
db-update:
	docker exec -it "$(php_container_id)" php bin/console doctrine:schema:update --dump-sql --force

.PHONY: fixture
fixture:
	docker exec -it "$(php_container_id)" php bin/console doctrine:fixture:load -n

.PHONY: db-reset
db-reset:
	docker exec -it "$(php_container_id)" php bin/console doctrine:database:drop --force
	docker exec -it "$(php_container_id)" php bin/console doctrine:database:create
	docker exec -it "$(php_container_id)" php bin/console doctrine:schema:update --dump-sql --force
	docker exec -it "$(php_container_id)" php bin/console doctrine:fixture:load -n

.PHONY: cc
cc:
	docker exec -it "$(php_container_id)" php bin/console cache:clear

################################################################################
########################### Complete install ###################################
################################################################################

.PHONY: complete-install
complete-install: env docker-build docker-up composer-install
	docker exec -it "$(php_container_id)" php bin/console doctrine:database:create --if-not-exists
	docker exec -it "$(php_container_id)" php bin/console doctrine:schema:update --dump-sql --force
	docker exec -it "$(php_container_id)" php bin/console doctrine:fixture:load -n --purge-with-truncate
