#
# Cookbook Name:: open_directory
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright (c) 2015 J. Morgan Lieberthal
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

include_recipe 'setup::default'
include_recipe 'open_directory::passwords'
include_recipe 'open_directory::ssl'
include_recipe 'krb5::kadmin_init'
include_recipe 'krb5::kdc'
include_recipe 'krb5::rkerberos_gem'

krb5_principal 'root/admin' do
  password lazy { node.run_state['kadmin_password'] }
end

krb5_principal 'host/orion.jmorgan.org'

krb5_keytab '/etc/krb5.keytab' do
  principals %w(host/orion.jmorgan.org)
end

krb5_principal 'ldap/orion.jmorgan.org'

krb5_keytab '/etc/openldap/krb5.keytab.ldap' do
  principals %w(ldap/orion.jmorgan.org)
  owner node['openldap']['system_acct']
  group node['openldap']['system_group']
  notifies :restart, 'service[krb5-kdc]'
end

include_recipe 'open_directory::services'
include_recipe 'open_directory::ldap_schema'

krb5_principal 'diradmin/admin' do
  password lazy { node.run_state['kadmin_password'] }
end

cookbook_file '/root/od-structure.ldif'
