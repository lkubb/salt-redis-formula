# frozen_string_literal: true

control 'redis.package.install' do
  title 'The required package should be installed'

  package_name = 'redis-server'

  describe package(package_name) do
    it { should be_installed }
  end
end
