function(request) {
  local namespace = request.object,
  local fromNS = std.split(namespace.metadata.annotations["network-zone.allow-namespace"],","),
  local allowFromSelf = namespace.metadata.annotations["network-zone.allow-from-self"],

  // Create a networkpolicy for each namespace
  attachments: [  
  {
    apiVersion: "networking.k8s.io/v1",
    kind: "NetworkPolicy",
    metadata: {
      namespace: namespace.metadata.name,
      name: "deny-by-default"
    },
    spec: {
      podSelector: {},
      ingress: []
    }
  }] + [
  {
    apiVersion: "networking.k8s.io/v1",
    kind: "NetworkPolicy",
    metadata: {
      namespace: namespace.metadata.name,
      name: "allow-from-" + ns
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
  ] + (
    if allowFromSelf == 'true' then [{
      apiVersion: "networking.k8s.io/v1",
      kind: "NetworkPolicy",
      metadata: {
        namespace: namespace.metadata.name,
        name: "allow-from-self"
      },
      spec: {
        podSelector: {},
        ingress: [
          {
             from: [
               {
                 podSelector: {}
               }
             ]
          }
        ]
      }
    }
  ])
}
