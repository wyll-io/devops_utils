[kubernetes_cluster]
%{ for ip in master_nodes ~}
${ip}
%{ endfor ~}
%{ for ip in worker_nodes ~}
${ip}
%{ endfor ~}

# ## Configure 'ip' variable to bind kubernetes services on a
# ## different ip than the default iface
# ## We should set etcd_member_name for etcd cluster. The node that is not a etcd member do not need to set the value, or can set the empty string value.
[all]
%{ for ip in master_nodes ~}
${ip}
%{ endfor ~}
%{ for ip in worker_nodes ~}
${ip}
%{ endfor ~}

# ## configure a bastion host if your nodes are not directly reachable
# [bastion]
# bastion ansible_host=x.x.x.x ansible_user=some_user

[kube_control_plane]
%{ for ip in master_nodes ~}
${ip}
%{ endfor ~}

[etcd]
%{ for ip in master_nodes ~}
${ip}
%{ endfor ~}

[kube_node]
%{ for ip in master_nodes ~}
${ip}
%{ endfor ~}
%{ for ip in worker_nodes ~}
${ip}
%{ endfor ~}

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr
