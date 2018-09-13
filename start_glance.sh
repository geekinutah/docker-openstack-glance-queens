#!/bin/bash

export HOST_ADDRESS=`hostname -I | sed 's/^[[:space:]]*//g'`
cat /openrc.j2 | python -c 'import os;import sys; import jinja2; sys.stdout.write(jinja2.Template(sys.stdin.read()).render(env=os.environ))' > /openrc

for i in cache glare manage registry; do
    cat /etc/glance/glance-$i.conf.j2 | python -c 'import os;import sys; import jinja2; sys.stdout.write(jinja2.Template(sys.stdin.read()).render(env=os.environ))' > /etc/glance/glance-$i.conf;
done

/usr/local/bin/glance-glare --config-file=/etc/glance/glance-glare.conf &
/usr/local/bin/glance-registry --config-file=/etc/glance/glance-registry.conf &
/usr/local/bin/glance-api --config-file=/etc/glance/glance-api.conf
