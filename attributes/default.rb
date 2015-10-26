override['krb5']['krb5_conf']['realms'] = {
  'default_realm' => default['krb5']['krb5_conf']['realms']['default_realm'],
  'default_realm_kdcs' => %w(orion.jmorgan.org),
  'default_realm_admin_server' => 'orion.jmorgan.org',
  'realms' => [default['krb5']['krb5_conf']['realms']['default_realm']]
}

# override['openldap']['basedn'] = 'dc=jmorgan,dc=org'
override['openldap']['server'] = node['fqdn']
override['openldap']['schemas'] = %w( core.schema
                                      cosine.schema
                                      nis.schema
                                      inetorgperson.schema
                                      samba.schema
                                      apple.schema )

override['openldap']['packages']['bdb'] = 'db4-utils' if platform? 'centos'
override['sslcerts']['ssl_dir'] = value_for_platform_family(
  'rhel' => '/etc/pki/tls',
  'default' => '/etc/ssl'
)
