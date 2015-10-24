RSpec.shared_examples 'converges successfully' do
  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
