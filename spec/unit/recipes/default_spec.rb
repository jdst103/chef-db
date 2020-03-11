#
# Cookbook:: node_cookbook
# Spec:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'node_cookbook::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'ubuntu', '16.04'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it "run get_update" do
      expect(chef_run).to update_apt_update 'update_sources'
    end

    it 'should add mongo to source list' do
      expect(chef_run).to add_apt_repository "mongodb-org"
    end

    it 'should install mongodb-org' do
      expect(chef_run).to upgrade_apt_package "mongodb-org"
    end

    it'should create a mongod.conf template in /lib/systemd/system/mongod.service' do
      expect(chef_run).to create_template('/lib/systemd/system/mongod.service')
      template = chef_run.template('/lib/systemd/system/mongod.service')
      expect(template).to notify('service[mongod]')
    end

    it'should create a mongod.conf template in /etc/mongod.conf' do
      expect(chef_run).to create_template('/etc/mongod.conf').with_variables(port: 27017, bindIp: '0.0.0.0')
    end

    it 'should make sure mongod is enabled' do
      expect(chef_run).to enable_service "mongod"
    end

    it 'should make sure mongod is running and started' do
      expect(chef_run).to start_service "mongod"
    end


  end
end
