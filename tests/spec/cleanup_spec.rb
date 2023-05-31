require 'spec_helper'

describe 'Validate token is removed' do
    describe service('rookout-controller') do
        it { should be_enabled }
        it { should_not be_running }
    end

    describe command("cat /etc/rookout/config | grep ROOKOUT_TOKEN=dummy_token | tr -d '\n'") do
        its(:stdout) { should eq 'ROOKOUT_TOKEN=dummy_token' }
    end
end