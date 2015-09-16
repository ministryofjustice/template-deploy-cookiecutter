import pkg_resources
from fabric.colors import red

try:
    # Check the versions are right before we try to import anything from these two modules
    pkg_resources.require("bootstrap-cfn>=0.5.10")
    pkg_resources.require("bootstrap-salt>=1.1.2")
except:
    print red("\n\nVersion requirement not met, "
              "please re-install requirements by running:\n\n    "
              "pip install -r requirements.txt\n\n")
    raise

from template_deploy.fab_tasks import *
