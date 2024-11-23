run.nginx: build.nginx
        @docker rm -f nginx
        @docker run \
                -d \
                --rm \
                --name nginx \
                --network host \
                -v ./nginx-sites/yacs:/etc/nginx/sites-available/yacs \
                nginx-yacs

run.production.db:
        @docker run \
                -d \
                --rm \
                --network yacs-production \
                --name yacs-production-db \
                -e POSTGRES_USER=${db_user} \
                -e POSTGRES_PASSWORD=${db_password} \
                -e POSTGRES_DB=${db_name} \
                -v yacs_production_data:/var/lib/postgresql/data \
                leandronsp/yacs-db:${version}

populate.production.db:
        @docker exec \
                -it \
                yacs-production-db \
                bash -c "cat /db/init.sql | psql -U ${db_user} ${db_name}"
        @docker exec \
                -it \
                yacs-production-db \
                bash -c "cat /db/populate.sql | psql -U ${db_user} ${db_name}"

run.production.app:
        @docker run \
                -d \
                -it \
                --rm \
                --network yacs-production \
                --name yacs-production-app \
                -p 4000:4000 \
                -e APP_ENV=production \
                -e DB_HOST=${db_host} \
                -e DB_USER=${db_user} \
                -e DB_PASSWORD=${db_password} \
                -e DB_NAME=${db_name} \
                leandronsp/yacs:${version}
