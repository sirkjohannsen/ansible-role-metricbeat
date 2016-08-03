# java-spec
require 'spec_helper'

describe package('metricbeat') do
  it { should be_installed }
end

describe file('/etc/metricbeat/metricbeat.yml') do
  it { should exist }
end

describe service('metricbeat') do
  it { should be_enabled }
  it { should be_running }
end

describe command('curl -s localhost:9200/.kibana/') do
  its(:stdout) { should match /{"created":".*"}/ }
end
