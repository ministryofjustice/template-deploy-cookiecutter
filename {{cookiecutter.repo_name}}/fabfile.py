# -*- coding: utf-8 -*-
from fabric.api import task, sudo, run, settings, put, local, hide, cd, prefix
from fabric.api import env as env
from fabric.colors import red, green

from cotton import salt
from cotton.api import create

from lib.utils import list_valid_envs

env.hosts = ['54.76.151.42',]
env.user = 'ubuntu'
env.key_filename = 'manchester.pem'
env.depoy_path = "/srv/manchester_traffic_offences_pleas/"

AWS_CONFIG = {
    'dev': {
        'provider_zone': 'pleaonline_dev',
        'project': 'manchester-dev',
        'provisioning': True,
        'hosts': ['54.77.90.82'],
        'vm_name': 'salt_master.dev',
        'domainname': 'pleaonline.dsd.io',
    },
    'stage': {
        'provider_zone': 'pleaonline_dev',
        'project': 'manchester-stage',
        'provisioning': True,
    }
}

def _set_env(env_name):
    env_names = list_valid_envs()
    if env_name not in env_names:
        raise ValueError(red("%s not a valid env name.\nPlease use of of %s" %
            (env_name, ", ".join(name for name in env_names))))
    env.environment = env_name
    env.update(AWS_CONFIG[env_name])
    print AWS_CONFIG[env_name]

@task
def e(env="development"):
    _set_env(env)

@task
def build_master():
    try:
        with hide('aborts',):
            instance = create(name="salt_master.%s" % env.environment)
            instance.use_ip(env.hosts[0])
            kwargs = {'master': instance, 'salt_les': ['master']}
    except SystemExit, e:
        print "Instance already exists"

    salt.bootstrap_master()
    make_deploy_key()




@task
def make_deploy_key():
    # with hide('',):
    run('mkdir -p ~/.ssh/')
    # run("ssh-keygen -y -f ~/.ssh/id_rsa -t rsa -N ''")
    run("ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ''")
    run("chmod 600 ~/.ssh/id_rsa*")
    key = run("cat ~/.ssh/id_rsa.pub")
    print """
    New key created.  You'll want to add the following as a new deploy key in github:

    %s
    """ % green(key)

@task
def install_packages():
    packages = [
        "git",
        "postgresql",
        "postgresql-contrib",
        "postgresql-server-dev-9.1",
        "python-pip",
        "python-virtualenv",
        "python-dev",
        "libxml2-dev",
        "libxslt1-dev",
        "nginx",
    ]

    sudo("apt-get update")
    for package in packages:
        sudo("apt-get -q -y install %s" % package)

@task
def update_instance():
    with cd(env.depoy_path):
        run("git reset --hard && git pull")
        with prefix('source env/bin/activate'):
            run("pip install -U -r requirements/production.txt")
            run("python manage.py collectstatic --noinput")
            run("python manage.py syncdb")
            run("python manage.py migrate")
    sudo("service nginx reload")
    sudo("service postgresql restart")
    sudo("service pleaonline restart")


@task
def setup_instance():
    """
    This will be replaced with salt.  Do the basics for now.
    """
    install_packages()

    sudo("createdb manchester_traffic_offences || true", user="postgres")

    # AHHHHH
    run("rm ~/.ssh/config")
    run("chmod 600 ~/.ssh/id_rsa*")
    run('echo -e "Host github.com\n\tStrictHostKeyChecking no\n\tIdentityFile /home/ubuntu/.ssh/id_rsa\n" >> ~/.ssh/config')
    sudo('mkdir -p /root/.ssh')
    sudo('echo -e "Host github.com\n\tStrictHostKeyChecking no\n\tIdentityFile /home/ubuntu/.ssh/id_rsa\n" >> /root/.ssh/config')
    run("cat ~/.ssh/config")

    sudo("git clone git@github.com:ministryofjustice/manchester_traffic_offences_pleas.git %s || true" % env.depoy_path)
    sudo("chown -R ubuntu %s" % env.depoy_path)
    sudo("chmod -R 755 %s" % env.depoy_path)

    with cd(env.depoy_path):
        run("[ -d env ] || virtualenv env")

    put(local_path="config/nginx",
        remote_path="/etc/nginx/sites-enabled/manchester_traffic_offences_pleas",
        use_sudo=True)
    put(local_path="config/upstart",
        remote_path="/etc/init/pleaonline.conf",
        use_sudo=True)
    put(local_path="config/pg_hba.conf",
        remote_path="/etc/postgresql/9.1/main/pg_hba.conf",
        use_sudo=True)
    sudo("chown root:root /etc/init/pleaonline.conf")
    sudo("chmod 644 /etc/init/pleaonline.conf")
    sudo("rm /etc/nginx/sites-enabled/default || true")


    update_instance()


@task
def django_dev_server():
    with cd(env.depoy_path):
        with prefix('source env/bin/activate'):
            run("python manage.py runserver 0.0.0.0:8000")


@task
def ssh_cmd():
    # pillar = get_pillar()
    user = env.user
    ip = env.hosts[0]
    out = user + "@" + ip
    if env.key_filename is not None:
        keyfiles = env.key_filename
        out = out + ' -i ' + keyfiles
    print out
