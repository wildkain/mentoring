server '81.200.119.137', roles: %w{app db web}, ssh_options: {
    user: 'deployer',
    keys: %w(/home/tux/.ssh/id_rsa),
    forward_agent: true,
    auth_methods: %w(publickey password),
    port: 7055
                       }