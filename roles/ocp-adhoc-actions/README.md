ocp-adhoc-actions
=========

Excutes particular actions if variable is set

```
#restart master proces
ansible-playbook -i inventory site.yml -l dev -s -k -e "restart_master_proc=true"
```

