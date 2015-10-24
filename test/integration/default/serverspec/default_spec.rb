require 'spec_helper'

RSpec.describe 'open_directory::default' do
  describe 'krb5 installation and setup' do
    describe file('/etc/krb5.conf') do
      it { is_expected.to be_file }
      it { is_expected.to exist }
      it 'has the right configuration' do
        expect(subject.content).to match(
          /\[libdefaults\]\s+^\s+default_realm = JMORGAN\.ORG/
        )
        expect(subject.content).to match(/\[realms\]\s+JMORGAN\.ORG = /)
      end
    end

    kdc_service = os[:family] == 'redhat' ? 'krb5kdc' : 'krb5-kdc'
    kadmin_service = os[:family] == 'redhat' ? 'kadmin' : 'krb5-admin-server'

    describe service(kdc_service) do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe service(kadmin_service) do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe command('kadmin.local -p admin/admin -q "listprincs"') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{host/orion\.jmorgan\.org} }
      its(:stdout) { is_expected.to match %r{admin/admin@JMORGAN\.ORG} }
      its(:stdout) { is_expected.to match %r{kadmin/admin@JMORGAN\.ORG} }
      its(:stdout) { is_expected.to match %r{kadmin/changepw@JMORGAN\.ORG} }
      its(:stdout) { is_expected.to match %r{kadmin/orion\.jmorgan\.org} }
      its(:stdout) { is_expected.to match %r{krbtgt/JMORGAN\.ORG@JMORGAN\.ORG} }
    end
  end
end
