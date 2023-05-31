shared_examples 'rookout::base' do

    describe service('docker') do
        it { should be_enabled }
        it { should be_running }
    end

    describe service('rookout-controller') do
        it { should be_enabled }
        it { should be_running }
    end

    describe service('rookout-data-on-prem') do
        it { should be_enabled }
        it { should be_running }
    end

    describe command('curl localhost:7488') do
        its(:stdout) { should contain("Rookout Service [OK]") }
    end

    describe command('curl localhost:8080') do
        its(:stdout) { should contain("Rookout Datastore [OK]") }
    end

end