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
        expect(subject.content).to match(
          /\[realms\]\s+JMORGAN\.ORG = \{\n\s+kdc = orion\.jmorgan\.org\n\s\}/
        )
      end
    end
  end
end
