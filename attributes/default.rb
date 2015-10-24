override['krb5']['krb5_conf']['realms'] = {
  'default_realm' => default['krb5']['krb5_conf']['realms']['default_realm'],
  'default_realm_kdcs' => %w(orion.jmorgan.org),
  'default_realm_admin_server' => 'orion.jmorgan.org',
  'realms' => [default['krb5']['krb5_conf']['realms']['default_realm']]
}
