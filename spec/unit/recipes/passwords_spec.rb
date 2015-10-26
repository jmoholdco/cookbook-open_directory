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

RSpec.describe 'open_directory::passwords' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
  {
    'centos' => %w(7.0 7.1.1503),
    'debian' => %w(7.8 8.0 8.1)
  }.each do |platform, versions|
    versions.each do |version|
      context "on #{platform} v#{version}" do
        let(:opts) { { platform: platform, version: version } }
        include_examples 'converges successfully'

        it 'sets the master password from the vault' do
          expect(chef_run.node['krb5']['master_password']).to eq 'masterpass'
        end

        it 'sets the admin password from the vault' do
          expect(chef_run.node['krb5']['admin_password']).to eq 'adminpass'
        end

        it 'runs the ruby block to save the password in the node run_state' do
          expect(chef_run).to run_ruby_block('add_kadmin_password_to_run_state')
        end
      end
    end
  end
end
