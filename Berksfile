source 'https://supermarket.chef.io'

metadata

cookbook 'sslcerts', path: '../sslcerts'
cookbook 'setup', path: '../setup'

group :integration do
  cookbook 'apt'
  cookbook 'selinux'
end
