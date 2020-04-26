This repository uses a docker GitHub action to build a simple python project
PKGBUILD in a minimal system and then run namcap.

See the most recent run on the namcap page for more details.
Expanding Test > pkgbuild > Makepkg build and check shows the output log of `entrypoint.sh` run on a docker container, including lists of installed packages at various times.

Relevant namcap output:

    helloworld W: Referenced library 'python' is an uninstalled dependency
    helloworld I: Script link detected (python) in file ['usr/bin/helloworld']
    helloworld W: Dependency included and not needed ('python')
    helloworld I: Depends as namcap sees them: depends=()
