shared_examples 'rookout::base' do

    describe service('docker') do
        it { should be_enabled }
        it { should be_running }
    end

    describe service('rookout-controller') do
        it { should be_enabled }
        it { should be_running }
    end

    describe command("docker inspect --format='{{json .State.Health.Status}}' rookout-controller | tr -d '\"'") do
        its(:stdout) { should eq 'healthy' }
    end

    describe service('rookout-data-on-prem') do
        it { should be_enabled }
        it { should be_running }
    end

    describe command("docker inspect --format='{{json .State.Health.Status}}' rookout-data-on-prem | tr -d '\"'") do
        its(:stdout) { should eq 'healthy' }
    end

    describe command("curl -s -o /dev/null -w '%{response_code}' localhost:7488") do
        its(:stdout) { should eq '200' }
    end

    describe command("curl -s -o /dev/null -w '%{response_code}' localhost:8080") do
        its(:stdout) { should eq '200' }
    end


end