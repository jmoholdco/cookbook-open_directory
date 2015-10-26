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

RSpec.describe 'open_directory::ldap_schema' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(opts) do |node|
      node.automatic['fqdn'] = 'orion.jmorgan.org'
      node.automatic['domain'] = 'jmorgan.org'
    end.converge(described_recipe)
  end
  supported_platforms = {
    'centos' => %w(7.0 7.1.1503),
    'debian' => %w(7.8 8.0 8.1)
  }

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform} v#{version}" do
        let(:opts) { { platform: platform, version: version } }
        let(:prefix) { platform == 'centos' ? '/etc/openldap' : '/etc/ldap' }
        include_examples 'converges successfully'

        it 'includes the openldap::server recipe' do
          expect(chef_run).to include_recipe 'openldap::server'
        end

        describe 'adding the apple-specific schema' do
          it 'creates the schema directory' do
            expect(chef_run).to create_directory("#{prefix}/schema")
          end

          it 'adds samba.schema' do
            expect(chef_run).to create_cookbook_file(
              "#{prefix}/schema/samba.schema"
            )
          end

          it 'adds apple.schema' do
            expect(chef_run).to create_cookbook_file(
              "#{prefix}/schema/apple.schema"
            )
          end
        end

        describe 'the node attributes' do
          let(:node) { chef_run.node['openldap'] }
          it 'has the right dn' do
            expect(node['basedn']).to eq 'dc=jmorgan,dc=org'
          end

          it 'has the right cn' do
            expect(node['cn']).to eq 'admin'
          end

          it 'has the right server' do
            expect(node['server']).to eq 'orion.jmorgan.org'
          end

          it 'does not manage ssl certificates' do
            expect(node['manage_ssl']).to be_falsy
          end
        end
      end
    end
  end
end
