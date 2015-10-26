#
# Cookbook Name:: open_directory
# Spec:: default
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

require 'spec_helper'

RSpec.describe 'open_directory::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }

  supported_platforms = {
    'centos' => %w(7.0 7.1.1503),
    'debian' => %w(8.0 8.1)
  }

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform} v#{version}" do
        let(:opts) { { platform: platform, version: version } }
        include_examples 'converges successfully'
        it 'includes the password recipe' do
          expect(chef_run).to include_recipe 'open_directory::passwords'
        end

        it 'includes the krb5 recipe' do
          expect(chef_run).to include_recipe 'krb5'
        end

        it 'includes the krb5::kadmin_init recipe' do
          expect(chef_run).to include_recipe 'krb5::kadmin_init'
        end

        it 'includes the custom service recipe' do
          expect(chef_run).to include_recipe 'open_directory::services'
        end

        it 'creates the root principal' do
          expect(chef_run).to create_krb5_principal('root/admin')
        end

        it 'creates the host principal' do
          expect(chef_run).to create_krb5_principal('host/orion.jmorgan.org')
        end

        it 'creates a keytab for the host principal' do
          expect(chef_run).to create_krb5_keytab('/etc/krb5.keytab').with(
            principals: %w(host/orion.jmorgan.org)
          )
        end

        it 'creates the ldap principal' do
          expect(chef_run).to create_krb5_principal('ldap/orion.jmorgan.org')
        end

        it 'creates a keytab for the ldap principal' do
          expect(chef_run).to create_krb5_keytab(
            '/etc/openldap/krb5.keytab.ldap'
          ).with(principals: %w(ldap/orion.jmorgan.org))
        end
      end
    end
  end
end
