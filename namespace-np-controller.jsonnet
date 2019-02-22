function(request) {
  local namespace = request.object,
  local fromNS = std.split(namespace.metadata.annotations["network-zone.allow-namespace"],","),

  // Create a networkpolicy for each namespace
  attachments: [
  {
    apiVersion: "networking.k8s.io/v1",
    kind: "NetworkPolicy",
    metadata: {
      namespace: namespace.metadata.name,
      name: namespace.metadata.name + "-allow-from-" + ns
    },
    spec: {
      podSelector: {},
      ingress: [
        {
           from: [
             {
               namespaceSelector: {
                 matchLabels: {
                   name: ns
                 }
               }
             }
           ]
        }
      ]
    }
  }    
  for ns in fromNS   
  ]
}