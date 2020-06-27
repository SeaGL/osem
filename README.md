# Trial of upstream OSEM

This branch provides a data migration script and application configuration with
which SeaGL can preview migration to [upstream] OSEM.

As a base it uses [`AndrewKvalheim:future`][andrewkvalheim:future], which
applies several prospective changes to `openSUSE:master`.

## Deployment to Dokku

Prerequisites:

- [Dokku] with the [MySQL plugin], as in this [simple Dokku virtual machine](https://gist.github.com/AndrewKvalheim/ce7ee64e9c158f5e239307edb95a8818)
- a database dump from SeaGL's OSEM instance

Import the database:

```bash
ssh dokku@dokku mysql:create 'osem'
ssh dokku@dokku mysql:import 'osem' < 'osem1prod.sql'
```

Configure the app:

```bash
ssh dokku@dokku apps:create 'osem'
ssh dokku@dokku builder:set 'osem' selected 'herokuish'
ssh dokku@dokku git:set 'osem' deploy-branch 'main'
ssh dokku@dokku config:set 'osem' \
  OSEM_DB_ADAPTER='mysql2' \
  OSEM_EMAIL_ADDRESS='no-reply@seagl.org' \
  OSEM_HOSTNAME='osem.seagl.org' \
  OSEM_NAME='SeaGL' \
  MYSQL_DATABASE_SCHEME='mysql2' \
  RAILS_SERVE_STATIC_FILES='true' \
  SECRET_KEY_BASE="$(</dev/urandom tr -dc 'A-Za-z0-9' | head -c 64)"
ssh dokku@dokku mysql:link 'osem' 'osem'
```

Deploy the app and migrate data:

```bash
git remote add 'production' 'dokku@dokku:osem'
git push 'production' 'trial:main'
```

Clean up:

```bash
ssh dokku@dokku apps:destroy 'osem'
ssh dokku@dokku mysql:destroy 'osem'
```

[andrewkvalheim:future]: https://github.com/AndrewKvalheim/osem/tree/future#readme
[dokku]: https://dokku.com/
[mysql plugin]: https://github.com/dokku/dokku-mysql
[upstream]: https://github.com/openSUSE/osem
