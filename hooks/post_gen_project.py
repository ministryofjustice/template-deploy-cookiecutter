import logging
import os
import pkgutil
#
# This cookiecutter post project creation script will search for template-deploy salt
# files and copy them to the new project
#


#Generate salt directory dynamically
project_dir = "{{cookiecutter.project_name}}-deploy"
td_salt_files = [
    os.path.join('salt', 'top.sls')]
for td_salt_file in td_salt_files:
    target_dir = os.path.dirname(td_salt_file)
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    #td_salt_file_path = os.path.join(project_dir, td_salt_file)
    if os.path.exists(td_salt_file):
        msg = ("File '{}' already exists, not overwriting....'".format(td_salt_file))
        logging.error(msg)
        sys.exit(1)
    else:
        salt_data = pkgutil.get_data('template_deploy', td_salt_file)
        with open(td_salt_file, "w") as salt_out:
            salt_out.write(salt_data)
            msg = ("Writing template-deploy salt data to file '{}'".format(td_salt_file))
            logging.info(msg)
